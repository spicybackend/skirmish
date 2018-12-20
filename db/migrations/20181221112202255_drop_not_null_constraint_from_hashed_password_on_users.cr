class DropNotNullConstraintFromHashedPasswordOnUsers < Jennifer::Migration::Base
  def up
    exec("ALTER TABLE users ALTER COLUMN hashed_password DROP NOT NULL")
  end

  def down
    exec("ALTER TABLE users ALTER COLUMN hashed_password SET NOT NULL")
  end
end
