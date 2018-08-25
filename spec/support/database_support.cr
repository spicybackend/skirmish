def delete_all_from_table(table_name : String)
  database_adapter.open do |database|
    database.exec "DELETE FROM #{table_name};"
  end
end

def database_adapter
  Granite::Adapters.registered_adapters.first
end

def create_player_with_mock_user(tag : String)
  user = User.new
  user.email = "#{Random::Secure.hex}@test.com"
  user.password = Random::Secure.hex
  user.save!

  Player.create!(
    user_id: user.id,
    tag: tag
  )
end
