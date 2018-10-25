class DeleteGameNotificationsWithoutExistingSource < Jennifer::Migration::Base
  def up
    exec(
      "DELETE FROM notifications
      WHERE notifications.source_type LIKE 'Game'
      AND notifications.source_id NOT IN (
        SELECT id FROM games
      );"
    )
  end

  def down
    # No coming back from this one :o
  end
end
