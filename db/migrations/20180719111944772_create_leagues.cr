class CreateLeagues < Jennifer::Migration::Base
  def up
    exec(
      "CREATE TABLE IF NOT EXISTS leagues (
        id BIGSERIAL PRIMARY KEY,

        name VARCHAR(32),
        description VARCHAR(1024),
        start_rating INT NOT NULL DEFAULT 1000,
        k_factor DOUBLE PRECISION NOT NULL DEFAULT 32.0,

        created_at TIMESTAMP,
        updated_at TIMESTAMP
      );"
    )
  end

  def down
    exec("DROP TABLE IF EXISTS leagues;")
  end
end
