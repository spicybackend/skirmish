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
