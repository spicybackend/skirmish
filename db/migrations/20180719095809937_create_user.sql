-- +micrate Up
CREATE TABLE users (
  id BIGINT PRIMARY KEY,
  email VARCHAR(255),
  hashed_password VARCHAR(60),
  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS users;
