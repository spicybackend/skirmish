-- +micrate Up
CREATE TABLE memberships (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,

  player_id BIGINT,
  league_id BIGINT,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  CONSTRAINT membership_player_fk
    FOREIGN KEY (player_id)
    REFERENCES players(id) ON DELETE CASCADE,
  CONSTRAINT membership_league_fk
    FOREIGN KEY (league_id)
    REFERENCES leagues(id) ON DELETE CASCADE
);

-- +micrate Down
DROP TABLE IF EXISTS memberships;
