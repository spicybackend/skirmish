class NotificationController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def index
    player = current_player.not_nil!
    notifications = notifications_for_player(player).map(&.presented)

    render("index.slang")
  end

  def show
    player = current_player.not_nil!

    if notification = Notification.find(params[:id])
      if notification.player_id != player.id
        flash[:danger] = "Can't find notification"
        redirect_to "/notifications"; return
      end

      presented_notification = notification.presented

      notification.read_at = Time.now
      notification.save!

      redirect_to presented_notification.action_url
    else
      flash[:danger] = "Can't find notification"
      redirect_to "/notifications"
    end
  end

  def read
    player = current_player.not_nil!
    notification = Notification.find(params[:id])

    if notification && notification.player_id == player.id
      notification.read_at = Time.now
      notification.save!
    else
      flash[:danger] = "Can't find notification"
    end

    redirect_to "/notifications"
  end

  def read_all
    player = current_player.not_nil!

    notifications = Notification.all("WHERE player_id = ? AND read_at IS NULL", [player.id])
    bulk_read_query = "UPDATE notifications SET read_at = NOW() WHERE id in (#{notifications.map(&.id).join(", ")})"
    Notification.exec(bulk_read_query) if notifications.any?

    redirect_to "/notifications"
  end

  private def notifications_for_player(player)
    Notification.all("WHERE player_id = ? ORDER BY created_at DESC", [player.id])
  end
end
