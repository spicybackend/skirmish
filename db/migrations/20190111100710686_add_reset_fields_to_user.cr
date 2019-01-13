class AddResetFieldsToUser < Jennifer::Migration::Base
  def up
    change_table(:users) do |t|
      t.add_column(:reset_digest, :string)
      t.add_column(:reset_sent_at, :timestamp)
      t.add_index("users_reset_digest_index", :reset_digest, type: :uniq)
    end
  end

  def down
    change_table(:users) do |t|
      t.drop_column(:reset_digest)
      t.drop_column(:reset_sent_at)
    end
  end
end
