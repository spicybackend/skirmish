class CreateAuthProviders < Jennifer::Migration::Base
  def up
    create_table(:auth_providers) do |t|
      t.bigint :id, { :primary => true, :auto_increment => true }

      t.string("provider")
      t.string("token")
      t.bigint("user_id")

      t.timestamps
    end
  end

  def down
    drop_table(:auth_providers)
  end
end
