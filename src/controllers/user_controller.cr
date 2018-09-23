class UserController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def show
    user = current_user.not_nil!
    player = current_player.not_nil!

    render("show.slang")
  end

  def edit
    user = current_user.not_nil!
    player = current_player.not_nil!

    render("edit.slang")
  end

  def update
    user = current_user.not_nil!
    player = current_player.not_nil!

    if update(user, player)
      flash[:success] = "Updated Profile successfully."
      redirect_to "/profile"
    else
      flash[:danger] = "Could not update Profile!"
      render("edit.slang")
    end
  end

  private def update(user : User, player : Player)
    return false unless profile_params.valid?

    user.update_attributes(profile_params.to_h.reject("username"))
    player.update_attributes(tag: profile_params[:username])

    user.valid? && player.valid? && user.save && player.save
  end

  private def profile_params
    params.validation do
      required(:email) { |f| !f.nil? && !f.empty? }
      required(:username) { |f| !f.nil? && !f.empty? }
      optional(:password) { |f| !f.nil? && !f.empty? }
    end
  end
end
