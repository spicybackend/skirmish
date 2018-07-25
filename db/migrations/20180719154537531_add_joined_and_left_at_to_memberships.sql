-- +micrate Up
ALTER TABLE memberships
  ADD joined_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  ADD left_at TIMESTAMP NULL DEFAULT NULL;

UPDATE memberships
SET joined_at = created_at;

-- +micrate Down
ALTER TABLE memberships
  DROP joined_at,
  DROP left_at;
