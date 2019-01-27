class AddDeltaToGames < Jennifer::Migration::Base
  def up
    change_table(:games) do |t|
      t.add_column(:rating_delta, :integer)
    end
  end

  def down
    change_table(:games) do |t|
      t.drop_column(:rating_delta)
    end
  end
end
