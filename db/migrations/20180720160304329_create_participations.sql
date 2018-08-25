-- +micrate Up
CREATE TABLE participations (
  id BIGSERIAL PRIMARY KEY,

  game_id BIGSERIAL REFERENCES games(id) ON DELETE CASCADE,
  player_id BIGSERIAL REFERENCES players(id),
  won BOOLEAN NOT NULL,
  rating INTEGER,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS participations;
