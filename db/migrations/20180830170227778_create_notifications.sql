-- +micrate Up
CREATE TABLE notifications (
  id INTEGER NOT NULL PRIMARY KEY,
  player_id BIGINT,
  event_type VARCHAR,
  sent_at TIMESTAMP,
  read_at TIMESTAMP,
  title VARCHAR,
  content VARCHAR,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX notifications_player_id_idx ON notifications (player_id);

-- +micrate Down
DROP TABLE IF EXISTS notifications;
