-- +micrate Up
CREATE TABLE memberships (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,

  player_id BIGINT,
  league_id BIGINT,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  FOREIGN KEY (player_id) REFERENCES players(id),
  FOREIGN KEY (league_id) REFERENCES leagues(id)
);

-- +micrate Down
DROP TABLE IF EXISTS memberships;
