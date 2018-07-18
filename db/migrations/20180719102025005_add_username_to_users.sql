-- +micrate Up
ALTER TABLE users
ADD username VARCHAR(16) FIRST;

UPDATE users
SET username = SUBSTRING_INDEX(email, '@', 1);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE users
DROP username;