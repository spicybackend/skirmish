-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE administrators
ADD COLUMN league_id BIGSERIAL NOT NULL REFERENCES leagues(id) ON DELETE CASCADE;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE administrators
DROP COLUMN league_id;
