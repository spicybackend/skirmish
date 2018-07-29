-- +micrate Up
CREATE TABLE participations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,

  game_id BIGINT NOT NULL,
  player_id BIGINT NOT NULL,
  won BOOLEAN NOT NULL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  CONSTRAINT participation_game_fk
    FOREIGN KEY (game_id)
    REFERENCES games(id) ON DELETE CASCADE,
  CONSTRAINT participation_player_fk
    FOREIGN KEY (player_id)
    REFERENCES players(id)
);

-- +micrate Down
DROP TABLE IF EXISTS participations;
