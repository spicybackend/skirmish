class CreatePlayers < Jennifer::Migration::Base
  def up
    exec(
      "CREATE TABLE players (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGSERIAL REFERENCES users(id) ON DELETE CASCADE,

        tag VARCHAR(16) NOT NULL,

        created_at TIMESTAMP,
        updated_at TIMESTAMP
      );"
    )
  end

  def down
    exec("DROP TABLE IF EXISTS players;")
  end
end
