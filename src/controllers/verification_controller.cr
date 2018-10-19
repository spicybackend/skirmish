class VerificationController < ApplicationController
  def show
    if user = User.where { _email == params[:email] }.first
      if user.activated?
        redirect_to "/"
      else
        render("show.slang")
      end
    else
      flash[:danger] = "Can't find an account linked to that email address"
    end
  end

  def create
  #   Jennifer::Adapter.adapter.transaction do
  #     user = create_user_from_params
  #     player = create_player_from_params(user)

  #     WelcomeMailer.new(player).send

  #     session[:user_id] = user.id
  #     session[:player_id] = player.id
  #   end

  #   flash["success"] = "Registered successfully."
  #   redirect_to "/"
  # rescue ex : Jennifer::RecordInvalid
  #   user = build_user_from_params.tap(&.valid?)
  #   player = build_player_from_params.tap(&.valid?)

  #   flash["danger"] = "Could not complete registration!"
  #   render("new.slang")
  end
end
