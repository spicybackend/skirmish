def create_player_with_mock_user(tag : String | Nil = nil)
  user = User.new
  user.email = "#{Random::Secure.hex}@test.com"
  user.password = Random::Secure.hex
  user.save!

  Player.create!(
    user_id: user.id,
    tag: tag || Random::Secure.hex(8)
  )
end

def create_league(name : String | Nil = nil, description : String | Nil = nil, start_rating : Int32 | Nil = nil, k_factor : Float64 | Nil = nil)
  League.create!(
    name: name || Random::Secure.hex,
    description: description || Random::Secure.hex,
    start_rating: start_rating || League::DEFAULT_START_RATING,
    k_factor: k_factor || League::DEFAULT_K_FACTOR
  )
end
