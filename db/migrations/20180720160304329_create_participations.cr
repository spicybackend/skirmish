class CreateParticipations < Jennifer::Migration::Base
  def up
    exec(
      "CREATE TABLE IF NOT EXISTS participations (
        id BIGSERIAL PRIMARY KEY,

        game_id BIGSERIAL REFERENCES games(id) ON DELETE CASCADE,
        player_id BIGSERIAL REFERENCES players(id),
        won BOOLEAN NOT NULL,
        rating INTEGER,

        created_at TIMESTAMP,
        updated_at TIMESTAMP
      );"
    )
  end

  def down
    exec("DROP TABLE IF EXISTS participations;")
  end
end
