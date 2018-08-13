-- +micrate Up
ALTER TABLE games
  ADD logged_by_id BIGINT NOT NULL,
  ADD confirmed_by_id BIGINT NULL DEFAULT NULL,
  ADD confirmed_at TIMESTAMP NULL DEFAULT NULL,

  ADD CONSTRAINT logged_by_player_id
    FOREIGN KEY (logged_by_id)
    REFERENCES players(id) ON DELETE CASCADE,

  ADD CONSTRAINT confirmed_by_player_id
    FOREIGN KEY (confirmed_by_id)
    REFERENCES players(id) ON DELETE CASCADE;

UPDATE games
  SET logged_by_id = games.winner_id,
      confirmed_by_id = games.winner_id,
      confirmed_at = games.created_at;

-- +micrate Down
ALTER TABLE games
  DROP FOREIGN KEY logged_by_player_id,
  DROP FOREIGN KEY confirmed_by_player_id;

ALTER TABLE games
  DROP logged_by_id,
  DROP confirmed_by_id,
  DROP confirmed_at;
