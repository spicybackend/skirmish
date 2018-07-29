-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE administrators (
  id BIGINT PRIMARY KEY AUTO_INCREMENT,
  user_id BIGINT NOT NULL,

  created_at TIMESTAMP,
  updated_at TIMESTAMP,

  CONSTRAINT administrator_user_fk
    FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS administrators;