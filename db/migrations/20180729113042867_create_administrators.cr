class CreateAdministrators < Jennifer::Migration::Base
  def up
    exec(
      "CREATE TABLE administrators (
        id BIGSERIAL PRIMARY KEY,
        user_id BIGSERIAL REFERENCES users(id) ON DELETE CASCADE,

        created_at TIMESTAMP,
        updated_at TIMESTAMP
      );"
    )
  end

  def down
    exec("DROP TABLE IF EXISTS administrators;")
  end
end
