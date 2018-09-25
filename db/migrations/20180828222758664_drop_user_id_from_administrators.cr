class DropUserIdFromAdministrators < Jennifer::Migration::Base
  def up
    exec("ALTER TABLE administrators DROP COLUMN IF EXISTS user_id;")
  end

  def down
    exec("ALTER TABLE administrators ADD COLUMN user_id BIGSERIAL;")

    exec("UPDATE administrators
      SET user_id = users.id
      FROM users
      JOIN players ON players.user_id = users.id;"
    )

    exec("ALTER TABLE administrators ALTER COLUMN user_id SET NOT NULL;")
    exec("ALTER TABLE administrators ADD CONSTRAINT administrators_user_id_fkey FOREIGN KEY (user_id) REFERENCES users (id) MATCH FULL ON DELETE CASCADE;")
  end
end
