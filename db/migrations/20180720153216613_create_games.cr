class CreateGames < Jennifer::Migration::Base
  def up
    exec(
      "CREATE TABLE games (
        id BIGSERIAL PRIMARY KEY,

        league_id BIGSERIAL REFERENCES leagues(id) ON DELETE CASCADE,
        logged_by_id BIGINT NOT NULL REFERENCES players(id) ON DELETE CASCADE,
        confirmed_by_id BIGINT REFERENCES players(id) ON DELETE CASCADE,
        confirmed_at TIMESTAMP,

        created_at TIMESTAMP,
        updated_at TIMESTAMP
      );"
    )
  end

  def down
    exec("DROP TABLE IF EXISTS games;")
  end
end
