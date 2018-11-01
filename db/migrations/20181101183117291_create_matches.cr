class CreateMatches < Jennifer::Migration::Base
  def up
    create_table(:matches) do |t|
      t.reference :tournament
      t.reference :player_a
      t.reference :player_b
      t.reference :winner
      t.reference :next_match
      t.integer :level

      t.timestamps
    end
  end

  def down
    drop_table(:matches)
  end
end
