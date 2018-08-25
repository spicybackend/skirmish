-- +micrate Up
CREATE TABLE memberships (
  id BIGSERIAL PRIMARY KEY,

  player_id BIGSERIAL REFERENCES players(id) ON DELETE CASCADE,
  league_id BIGSERIAL REFERENCES leagues(id) ON DELETE CASCADE,

  joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  left_at TIMESTAMP,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS memberships;
