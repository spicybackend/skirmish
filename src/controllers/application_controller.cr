require "jasper_helpers"
require "./concerns/session_helper"

class ApplicationController < Amber::Controller::Base
  include ViewModel
  include SessionHelper
  include JasperHelpers
  include ApplicationHelper
  include ReadableTimeHelpers
  include ProfileHelper
  include RouterHelper

  LAYOUT = "application.slang"

  @page_title : String? = nil

  macro page(klass, *args)
    {{klass}}.new({{args.splat}}{% if args.size > 0 %},{% end %} context, flash, current_user, @page_title).render
  end

  def auth_page?
    auth_url_regexes = [/signup/, /signin/, /session/, /registration/, /multi_auth/]
    current_path = context.request.path

    auth_url_regexes.any? do |auth_url_regex|
      current_path.match(auth_url_regex)
    end
  end

  private def redirect_signed_out_user
    unless signed_in?
      flash[:info] = "Must be logged in"
      redirect_to "/signin?redirect=#{context.request.path}"
    end
  end

  private def landing_url
    if league_id = current_player_context.try(&.league_id)
      "/leagues/#{league_id}"
    else
      "/leagues"
    end
  end

  private def root_path
    "/"
  end

  private def user_path(user : User)
    "/profile/#{user.player!.tag}"
  end

  private def redirect_back
    redirect_to request.headers["Referer"]? || root_path
  end

  private def t(key, *args, **opts)
    I18n.translate("#{key}", *args, **opts)
  end
end
