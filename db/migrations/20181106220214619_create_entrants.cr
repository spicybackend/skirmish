class CreateEntrants < Jennifer::Migration::Base
  def up
    create_table(:entrants) do |t|
      t.bigint :id, { :primary => true, :auto_increment => true }

      t.bigint("tournament_id")
      t.bigint("player_id")

      t.timestamps
    end
  end

  def down
    drop_table(:entrants)
  end
end
