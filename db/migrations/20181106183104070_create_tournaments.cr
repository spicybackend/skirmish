class CreateTournaments < Jennifer::Migration::Base
  def up
    create_table(:tournaments) do |t|
      t.bigint :id, { :primary => true, :auto_increment => true }

      t.bigint("league_id")
      t.timestamp :finished_at

      t.timestamps
    end
  end

  def down
    drop_table(:tournaments)
  end
end
