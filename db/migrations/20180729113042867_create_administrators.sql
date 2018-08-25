-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE administrators (
  id BIGSERIAL PRIMARY KEY,
  user_id BIGSERIAL REFERENCES users(id) ON DELETE CASCADE,

  created_at TIMESTAMP,
  updated_at TIMESTAMP
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE IF EXISTS administrators;
