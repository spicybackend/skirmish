-- +micrate Up
CREATE TABLE players (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  CONSTRAINT player_user_fk
    FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE
);

INSERT INTO players (user_id, created_at, updated_at)
SELECT id, NOW(), NOW() FROM users;

-- +micrate Down
DROP TABLE IF EXISTS players;