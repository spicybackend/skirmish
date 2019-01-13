class ChangeHashedPasswordToPasswordDigestOnUsers < Jennifer::Migration::Base
  def up
    exec(
      "ALTER TABLE users
      RENAME COLUMN hashed_password TO password_digest;"
    )
  end

  def down
    exec(
      "ALTER TABLE users
      RENAME COLUMN password_digest TO hashed_password;"
    )
  end
end
