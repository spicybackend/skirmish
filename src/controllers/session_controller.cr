class SessionController < ApplicationController
  def new
    if signed_in?
      flash[:warning] = "Already signed in"
      redirect_to "/"
    else
      user = User.build({
        email: "",
        verification_code: ""
      })

      render("new.slang")
    end
  end

  def create
    user = User.where { _email == params["email"].to_s }.to_a.first?

    if user && user.authenticate(params["password"].to_s)
      if user.unverified?
        flash[:warning] = "Account hasn't been verified"
        redirect_to "/verification/#{user.email}"
      else
        session[:user_id] = user.id
        session[:player_id] = Player.where { _user_id == user.id }.to_a.first.id

        flash[:info] = "Successfully logged in"
        redirect_to "/"
      end
    else
      flash[:danger] = "Invalid email or password"
      user = User.build({
        email: "",
        verification_code: ""
      })

      render("new.slang")
    end
  end

  def delete
    session.delete(:user_id)

    flash[:info] = "Logged out. See ya later!"
    redirect_to "/"
  end
end
