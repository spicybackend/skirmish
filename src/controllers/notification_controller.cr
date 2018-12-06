class NotificationController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def index
    player = current_player.not_nil!
    unread_notifications = Notification.for_player(player).unread.order(created_at: :desc).to_a
    read_notifications = Notification.for_player(player).read.order(created_at: :desc).to_a

    render("index.slang")
  end

  def show
    player = current_player.not_nil!

    if notification = Notification.find(params[:id])
      if notification.player_id != player.id
        flash[:danger] = "Can't find notification"
        redirect_to "/notifications"; return
      end

      notification.read!

      redirect_to notification.action_url
    else
      flash[:danger] = "Can't find notification"
      redirect_to "/notifications"
    end
  end

  def read
    player = current_player.not_nil!
    notification = Notification.find(params[:id])

    if notification && notification.player_id == player.id
      notification.read!
    else
      flash[:danger] = "Can't find notification"
    end

    redirect_to "/notifications"
  end

  def read_all
    player = current_player.not_nil!

    notifications = Notification.where { _player_id == player.id }.where { _read_at == nil }
    notifications.update(read_at: Time.now)

    redirect_to "/notifications"
  end
end
