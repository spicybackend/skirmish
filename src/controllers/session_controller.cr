class SessionController < ApplicationController
  def new
    redirect_url = params[:redirect]?

    if signed_in?
      flash[:warning] = I18n.translate("session.already_signed_in")
      redirect_to redirect_url || landing_url
    else
      user = User.build({
        name: "",
        email: "",
        verification_code: ""
      })

      render("new.slang")
    end
  end

  def create
    user = User.where { _email == params["email"].to_s }.to_a.first?
    redirect_url = params[:redirect]?

    if user && user.authenticate(params["password"].to_s)
      if user.unverified?
        flash[:warning] = I18n.translate("verification.not_yet_activated")
        redirect_to "/verification/#{user.email}"
      else
        session[:user_id] = user.id
        session[:player_id] = Player.where { _user_id == user.id }.to_a.first.id

        flash[:info] = I18n.translate("session.logged_in_successfully")
        redirect_to redirect_url || landing_url
      end
    else
      flash[:danger] = I18n.translate("session.authentication_failed")
      user = User.build({
        name: "",
        email: "",
        verification_code: ""
      })

      render("new.slang")
    end
  end

  def delete
    session.delete(:user_id)

    flash[:info] = I18n.translate("session.logged_out")
    redirect_to "/"
  end
end
