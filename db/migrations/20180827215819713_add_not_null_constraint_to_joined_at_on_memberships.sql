-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
UPDATE memberships
  SET joined_at = created_at
  WHERE joined_at IS NULL;

ALTER TABLE memberships ALTER COLUMN joined_at SET NOT NULL;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE memberships ALTER COLUMN joined_at DROP NOT NULL;

UPDATE memberships
  SET joined_at = NULL;
