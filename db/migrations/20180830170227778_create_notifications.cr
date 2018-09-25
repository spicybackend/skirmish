class CreateNotifications < Jennifer::Migration::Base
  def up
    exec(
      "CREATE TABLE IF NOT EXISTS notifications (
        id BIGSERIAL PRIMARY KEY,

        player_id BIGINT NOT NULL REFERENCES players(id) ON DELETE CASCADE,
        event_type VARCHAR NOT NULL,
        title VARCHAR NOT NULL,
        content VARCHAR NOT NULL,
        source_type VARCHAR NULL,
        source_id BIGINT NULL,
        sent_at TIMESTAMP,
        read_at TIMESTAMP,
        created_at TIMESTAMP,
        updated_at TIMESTAMP
      );"
    )

    exec("CREATE INDEX IF NOT EXISTS notifications_player_id_idx ON notifications (player_id);")
  end

  def down
    exec("DROP TABLE IF EXISTS notifications;")
  end
end
