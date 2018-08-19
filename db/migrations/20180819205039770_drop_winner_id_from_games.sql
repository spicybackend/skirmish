-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
ALTER TABLE games
  DROP FOREIGN KEY game_winner_fk;

ALTER TABLE games
  DROP winner_id;

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back

UPDATE games, participations
  SET games.winner_id = participations.player_id
  WHERE games.id = participations.game_id
  AND participations.won = 1;
