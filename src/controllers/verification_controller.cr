class VerificationController < ApplicationController
  def show
    if user = User.where { _email == params[:email] }.first
      if user.activated?
        flash[:warning] = "User has already been activated"
        redirect_to "/signin"
      else
        render("show.slang")
      end
    else
      flash[:warning] = "Can't find an account linked to that email address"
      redirect_to "/"
    end
  end

  def verify
    if user = User.where { _verification_code == params[:verification_code] }.first
      if user.activated?
        flash[:warning] = "User has already been activated"
        redirect_to "/signin"
      else
        user.activate!

        flash[:success] = "Activated successfully"
        redirect_to "/signin"
      end
    else
      flash[:warning] = "Can't find an account linked to that email address"
      redirect_to "/"
    end
  end
end
