require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  LAYOUT = "application.slang"

  include JasperHelpers
  include ReadableTimeHelpers
  include ProfileHelper

  def auth_page?
    auth_url_regexes = [/signup/, /signin/, /session/, /registration/, /multi_auth/]
    current_path = context.request.path

    auth_url_regexes.any? do |auth_url_regex|
      current_path.match(auth_url_regex)
    end
  end

  def current_user
    context.current_user
  end

  def current_player
    context.current_player
  end

  def current_player_context
    current_player.try(&.player_context)
  end

  def signed_in?
    current_user && current_player ? true : false
  end

  private def redirect_signed_out_user
    unless signed_in?
      flash[:info] = "Must be logged in"
      redirect_to "/signin?redirect=#{context.request.path}"
    end
  end
end
