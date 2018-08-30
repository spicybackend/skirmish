class NotificationController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def index
    player = current_player.not_nil!
    notifications = notifications_for_player(player)

    render("index.slang")
  end

  def show
    notification = Notification.find(params[:id])
    # Some presenter to find action to direct to, eg. viewing a logged game

    redirect_to "/notifications"
  end

  def read
    # AJAX action only?
    notification = Notification.find(params[:id])

    if notification
      notification.read_at = Time.now
      notification.save!
    end

    # render("new.slang")
  end

  def read_all
    player = current_player.not_nil!

    # See if the latter can be tidied up with the code reuse:
    # notifications = notifications_for_player(player).all("AND read_at = ?", [false])

    Notification.all("WHERE player_id = ? AND read_at = ?", [player.id, false]).find_each do |notification|
      notification.read_at = Time.now
      notification.save!
    end
  end

  private def notifications_for_player(player)
    Notification.all("WHERE player_id = ?", [player.id])
  end
end
