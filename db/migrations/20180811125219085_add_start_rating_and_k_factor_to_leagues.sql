-- +micrate Up
ALTER TABLE leagues
  ADD start_rating INT NOT NULL DEFAULT "1000",
  ADD k_factor DOUBLE NOT NULL DEFAULT "32";

UPDATE leagues
  SET start_rating = 1000, k_factor = 32;

-- +micrate Down
ALTER TABLE leagues
  DROP start_rating,
  DROP k_factor;
