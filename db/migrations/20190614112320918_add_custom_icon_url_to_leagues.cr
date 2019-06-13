class AddCustomIconUrlToLeagues < Jennifer::Migration::Base
  def up
    change_table(:leagues) do |t|
      t.add_column(:custom_icon_url, :text)
    end
  end

  def down
    change_table(:leagues) do |t|
      t.drop_column(:custom_icon_url)
    end
  end
end
