class SessionController < ApplicationController
  def new
    user = User.build({
      email: "",
      verification_code: ""
    })

    render("new.slang")
  end

  def create
    user = User.where { _email == params["email"].to_s }.to_a.first?

    if user && user.authenticate(params["password"].to_s)
      session[:user_id] = user.id
      session[:player_id] = Player.where { _user_id == user.id }.to_a.first.id

      flash[:info] = "Successfully logged in"
      redirect_to "/"
    else
      flash[:danger] = "Invalid email or password"
      user = User.build({
        email: ""
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
