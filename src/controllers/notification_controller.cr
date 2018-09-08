class NotificationController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def index
    player = current_player.not_nil!
    notifications = notifications_for_player(player).map(&.presented)

    render("index.slang")
  end

  def read
    notification = Notification.find(params[:id])

    if notification
      notification.read_at = Time.now
      notification.save!
    end

    respond_with do
      html ->{ redirect_to "/notifications" }
      json notification.to_json
    end
  end

  def read_all
    player = current_player.not_nil!

    notifications = Notification.all("WHERE player_id = ? AND read_at IS NULL", [player.id])
    bulk_read_query = "UPDATE notifications SET read_at = NOW() WHERE id in (#{notifications.map(&.id).join(", ")})"
    Notification.exec(bulk_read_query) if notifications.any?

    respond_with do
      html ->{ redirect_to "/notifications" }
      json notifications.to_json
    end
  end

  private def notifications_for_player(player)
    Notification.all("WHERE player_id = ?", [player.id])
  end
end
