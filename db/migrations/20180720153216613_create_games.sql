-- +micrate Up
CREATE TABLE games (
  id BIGSERIAL PRIMARY KEY,

  league_id BIGSERIAL REFERENCES leagues(id) ON DELETE CASCADE,
  logged_by_id BIGINT NOT NULL REFERENCES players(id) ON DELETE CASCADE,
  confirmed_by_id BIGINT REFERENCES players(id) ON DELETE CASCADE,
  confirmed_at TIMESTAMP,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS games;
