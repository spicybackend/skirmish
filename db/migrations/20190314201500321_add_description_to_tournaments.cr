class AddDescriptionToTournaments < Jennifer::Migration::Base
  def up
    change_table(:tournaments) do |t|
      t.add_column(:description, :text)
    end
  end

  def down
    change_table(:tournaments) do |t|
      t.drop_column(:description)
    end
  end
end
