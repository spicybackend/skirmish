class UserController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def show
    player = Player.where { _tag == params[:player_tag]? }.first || current_player.not_nil!
    user = player.user!

    own_profile? = player.id == current_player.not_nil!.id

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

    begin
      Jennifer::Adapter.adapter.transaction do
        update!(user, player)

        flash[:success] = "Updated Profile successfully."
        redirect_to "/profile"
      end
    rescue ex : Jennifer::RecordInvalid
      flash[:danger] = "Could not update Profile!"
      render("edit.slang")
    end
  end

  private def update!(user : User, player : Player)
    user.name = params[:name]
    user.email = params[:email]
    player.tag = params[:username]

    (!user.changed? || user.save!) && (!player.changed? || player.save!)
  end

  private def profile_params
    params.validation do
      required(:name) { |f| !f.nil? && !f.empty? }
      required(:email) { |f| !f.nil? && !f.empty? }
      required(:username) { |f| !f.nil? && !f.empty? }
      optional(:password) { |f| !f.nil? && !f.empty? }
    end
  end
end
