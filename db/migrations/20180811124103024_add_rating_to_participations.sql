-- +micrate Up
ALTER TABLE participations
  ADD rating INT NOT NULL;

UPDATE participations
SET rating = 1000;

-- +micrate Down
ALTER TABLE participations
  DROP rating;
