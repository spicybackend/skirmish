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

    if update(user)
      flash[:success] = "Updated Profile successfully."
      redirect_to "/profile"
    else
      flash[:danger] = "Could not update Profile!"
      render("edit.slang")
    end
  end

  private def update(user)
    return false unless user && user_params.valid?

    user.set_attributes(user_params.to_h)
    user.valid? && user.save
  end

  private def user_params
    params.validation do
      required(:email) { |f| !f.nil? && !f.empty? }
      required(:username) { |f| !f.nil? && !f.empty? }
      optional(:password) { |f| !f.nil? && !f.empty? }
    end
  end
end
