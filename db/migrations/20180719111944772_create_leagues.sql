-- +micrate Up
CREATE TABLE leagues (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,

  name VARCHAR(32),
  description VARCHAR(1024),

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);


-- +micrate Down
DROP TABLE IF EXISTS leagues;
