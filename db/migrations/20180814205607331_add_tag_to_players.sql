-- +micrate Up
ALTER TABLE players
  ADD tag VARCHAR(16) NOT NULL;

UPDATE players
  INNER JOIN users ON players.user_id = users.id
  SET tag = users.username;

-- +micrate Down
ALTER TABLE players
  DROP tag;
