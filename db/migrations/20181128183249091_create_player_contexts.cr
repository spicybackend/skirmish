class CreatePlayerContexts < Jennifer::Migration::Base
  def up
    create_table(:player_contexts) do |t|
      t.bigint :id, { :primary => true, :auto_increment => true }

      t.bigint("player_id")
      t.bigint("league_id")

      t.timestamps
    end
  end

  def down
    drop_table(:player_contexts)
  end
end
