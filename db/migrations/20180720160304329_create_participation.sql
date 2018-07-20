-- +micrate Up
CREATE TABLE participations (
  id BIGINT PRIMARY KEY,

  game_id BIGINT,
  player_id BIGINT,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  FOREIGN KEY (game_id) REFERENCES games(id),
  FOREIGN KEY (player_id) REFERENCES players(id)
)

-- +micrate Down
DROP TABLE IF EXISTS participations;
