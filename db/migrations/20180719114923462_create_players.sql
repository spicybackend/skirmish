-- +micrate Up
CREATE TABLE players (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGSERIAL REFERENCES users(id) ON DELETE CASCADE,

  tag VARCHAR(16) NOT NULL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
DROP TABLE IF EXISTS players;
