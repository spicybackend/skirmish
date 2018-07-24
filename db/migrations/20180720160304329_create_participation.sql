-- +micrate Up
CREATE TABLE participations (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,

  game_id BIGINT NOT NULL,
  player_id BIGINT NOT NULL,
  won BOOLEAN NOT NULL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  FOREIGN KEY (game_id) REFERENCES games(id),
  FOREIGN KEY (player_id) REFERENCES players(id)
);

-- +micrate Down
DROP TABLE IF EXISTS participations;
