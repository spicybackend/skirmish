class VerificationController < ApplicationController
  def show
    if user = User.where { _email == params[:email] }.first
      if user.activated?
        flash[:warning] = I18n.translate("verification.already_activated")
        redirect_to "/signin"
      else
        render("show.slang")
      end
    else
      flash[:warning] = I18n.translate("verification.user_not_found")
      redirect_to "/"
    end
  end

  def verify
    if user = User.where { _verification_code == params[:verification_code] }.first
      if user.activated?
        flash[:warning] = I18n.translate("verification.already_activated")
        redirect_to "/signin"
      else
        user.activate!

        flash[:success] = I18n.translate("verification.activated_successfully")
        redirect_to "/signin"
      end
    else
      flash[:warning] = I18n.translate("verification.user_not_found")
      redirect_to "/"
    end
  end
end
