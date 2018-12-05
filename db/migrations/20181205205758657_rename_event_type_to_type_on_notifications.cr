class RenameEventTypeToTypeOnNotifications < Jennifer::Migration::Base
  def up
    exec(
      "ALTER TABLE notifications
      RENAME COLUMN event_type TO type;"
    )
  end

  def down
    exec(
      "ALTER TABLE notifications
      RENAME COLUMN type TO event_type;"
    )
  end
end
