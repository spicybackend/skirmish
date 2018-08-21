-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE participations
  MODIFY rating INT NULL;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
ALTER TABLE participations
  MODIFY rating INT NOT NULL;
