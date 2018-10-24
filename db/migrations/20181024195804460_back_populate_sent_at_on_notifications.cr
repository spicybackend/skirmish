class BackPopulateSentAtOnNotifications < Jennifer::Migration::Base
  def up
    exec("UPDATE notifications SET sent_at = notifications.created_at;")
  end

  def down
    exec("UPDATE notifications SET sent_at = NULL;")
  end
end
