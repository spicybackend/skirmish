class CreateTournaments < Jennifer::Migration::Base
  def up
    create_table(:tournaments) do |t|
      t.reference :league
      t.timestamp :finished_at

      t.timestamps
    end
  end

  def down
    drop_table(:tournaments)
  end
end
