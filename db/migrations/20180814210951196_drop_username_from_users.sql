-- +micrate Up
ALTER TABLE users
  DROP username;

-- +micrate Down
ALTER TABLE users
  ADD username VARCHAR(16);

UPDATE users
  INNER JOIN players ON players.user_id = users.id
  SET username = players.tag;
