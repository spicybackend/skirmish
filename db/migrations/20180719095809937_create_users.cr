class CreateUsers < Jennifer::Migration::Base
  def up
    exec(
      "CREATE TABLE IF NOT EXISTS users (
        id BIGSERIAL PRIMARY KEY,
        email VARCHAR(255) NOT NULL,
        hashed_password VARCHAR(60) NOT NULL,

        created_at TIMESTAMP,
        updated_at TIMESTAMP
      );"
    )
  end

  def down
    exec("DROP TABLE IF EXISTS users;")
  end
end
