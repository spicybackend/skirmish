require "jasper_helpers"

class ApplicationController < Amber::Controller::Base
  include JasperHelpers
  LAYOUT = "application.slang"

  include ReadableTimeHelpers
  include ProfileHelper

  def current_user
    context.current_user
  end

  def current_player
    if user = current_user
      user.player.not_nil!
    end
  end

  def signed_in?
    current_user && current_player ? true : false
  end

  private def redirect_signed_out_user
    unless signed_in?
      flash[:info] = "Must be logged in"
      redirect_to "/signin"
    end
  end
end
