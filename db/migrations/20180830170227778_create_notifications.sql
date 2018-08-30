-- +micrate Up
CREATE TABLE notifications (
  id BIGSERIAL PRIMARY KEY,

  player_id BIGSERIAL NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  event_type VARCHAR NOT NULL,
  sent_at TIMESTAMP,
  read_at TIMESTAMP,
  title VARCHAR NOT NULL,
  content VARCHAR NOT NULL,
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);
CREATE INDEX notifications_player_id_idx ON notifications (player_id);

-- +micrate Down
DROP TABLE IF EXISTS notifications;
