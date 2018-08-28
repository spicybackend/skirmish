-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE administrators
 ADD COLUMN player_id BIGSERIAL;

UPDATE administrators
   SET player_id = players.id
  FROM players
  JOIN users ON players.user_id = users.id
 WHERE users.id = administrators.user_id;

ALTER TABLE administrators ALTER COLUMN player_id SET NOT NULL;
ALTER TABLE administrators ADD CONSTRAINT administrators_player_id_fkey FOREIGN KEY (player_id) REFERENCES players (id) MATCH FULL ON DELETE CASCADE;


-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE administrators
       DROP COLUMN player_id;
