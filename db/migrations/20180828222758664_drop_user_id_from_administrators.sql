-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE administrators
DROP COLUMN user_id;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE administrators
 ADD COLUMN user_id BIGSERIAL;

UPDATE administrators
   SET user_id = users.id
  FROM users
  JOIN players ON players.user_id = users.id;

ALTER TABLE administrators ALTER COLUMN user_id SET NOT NULL;
ALTER TABLE administrators ADD CONSTRAINT administrators_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) MATCH FULL ON DELETE CASCADE;
