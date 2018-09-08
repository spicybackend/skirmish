-- +micrate Up
CREATE TABLE notifications (
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
);
CREATE INDEX notifications_player_id_idx ON notifications (player_id);

-- +micrate Down
DROP TABLE IF EXISTS notifications;
