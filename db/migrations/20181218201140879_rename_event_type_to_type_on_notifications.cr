class RenameEventTypeToTypeOnNotifications < Jennifer::Migration::Base
  def up
    exec("
      ALTER TABLE notifications
      RENAME event_type TO type;
    ")

    exec("
      UPDATE notifications
      SET type = 'GameLoggedNotification';
    ")  # these are the only type of notifications we have in the database at this time

    exec("
      alter table notifications alter column type drop not null;
    ")  # no longer necessary
  end

  def down
    exec("
      ALTER TABLE notifications
      RENAME type TO event_type;
    ")

    exec("
      UPDATE notifications
      SET event_type = 'game_logged';
    ")  # these are the only type of notifications we have in the database at this time
  end
end
