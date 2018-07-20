-- +micrate Up
CREATE TABLE games (
  id BIGINT PRIMARY KEY,

  league_id BIGINT,
  winner_id BIGINT,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  FOREIGN KEY (league_id) REFERENCES leagues(id),
  FOREIGN KEY (winner_id) REFERENCES players(id)
)

-- +micrate Down
DROP TABLE IF EXISTS games;
