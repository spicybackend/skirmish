class AddReceiveEmailNotificationsToUsers < Jennifer::Migration::Base
  def up
    exec("ALTER TABLE users ADD COLUMN IF NOT EXISTS receive_email_notifications BOOLEAN NOT NULL DEFAULT true;")
  end

  def down
    exec("ALTER TABLE users DROP COLUMN receive_email_notifications;")
  end
end
