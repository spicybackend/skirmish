class AddNotNullConstraintToJoinedAtOnMemberships < Jennifer::Migration::Base
  def up
    exec(
      "UPDATE memberships
      SET joined_at = created_at
      WHERE joined_at IS NULL;"
    )

    exec("ALTER TABLE memberships ALTER COLUMN joined_at SET NOT NULL;")
  end

  def down
    exec("ALTER TABLE memberships ALTER COLUMN joined_at DROP NOT NULL;")
    exec("UPDATE memberships SET joined_at = NULL;")
  end
end
