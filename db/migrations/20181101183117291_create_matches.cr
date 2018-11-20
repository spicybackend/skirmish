class CreateMatches < Jennifer::Migration::Base
  def up
    create_table(:matches) do |t|
      t.bigint :id, { :primary => true, :auto_increment => true }

      t.bigint("tournament_id")
      t.bigint("player_a_id")
      t.bigint("player_b_id")
      t.bigint("winner_id")
      t.bigint("next_match_id")
      t.integer :level

      t.timestamps
    end
  end

  def down
    drop_table(:matches)
  end
end
