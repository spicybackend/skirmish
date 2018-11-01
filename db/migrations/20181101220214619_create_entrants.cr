class CreateEntrants < Jennifer::Migration::Base
  def up
    create_table(:entrants) do |t|
      t.reference :tournament
      t.reference :player

      t.timestamps
    end
  end

  def down
    drop_table(:entrants)
  end
end
