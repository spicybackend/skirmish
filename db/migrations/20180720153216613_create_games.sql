-- +micrate Up
CREATE TABLE games (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,

  league_id BIGINT,
  winner_id BIGINT,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  CONSTRAINT game_league_fk
    FOREIGN KEY (league_id)
    REFERENCES leagues(id) ON DELETE CASCADE,
  CONSTRAINT game_winner_fk
    FOREIGN KEY (winner_id)
    REFERENCES players(id)
);

-- +micrate Down
DROP TABLE IF EXISTS games;
