def create_player_with_mock_user(tag : String? = nil, password : String? = nil, verified : Bool = true)
  user = User.new({
    email: "#{Random::Secure.hex}@test.com",
    receive_email_notifications: false,
    verification_code: Random::Secure.hex(8),
    activated_at: verified ? Time.now : nil
  })
  user.password = password || Random::Secure.hex
  user.save!

  Player.create!(
    user_id: user.id,
    tag: tag || Random::Secure.hex(8)
  )
end

def create_league(name : String? = nil, description : String? = nil, start_rating : Int32? = nil, k_factor : Float64? = nil)
  League.create!(
    name: name || Random::Secure.hex,
    description: description || Random::Secure.hex,
    start_rating: start_rating || League::DEFAULT_START_RATING,
    k_factor: k_factor || League::DEFAULT_K_FACTOR
  )
end

def create_and_pit_players(league : League)
  player_one = create_player_with_mock_user
  player_two = create_player_with_mock_user
  player_three = create_player_with_mock_user

  Membership.create!(player_id: player_one.id, league_id: league.id, joined_at: Time.now)
  Membership.create!(player_id: player_two.id, league_id: league.id, joined_at: Time.now)
  Membership.create!(player_id: player_three.id, league_id: league.id, joined_at: Time.now)

  game_logger = League::LogGame.new(league: league, winner: player_one, loser: player_three, logger: player_one)
  game_logger.call
  game = game_logger.game
  Game::Confirm.new(game: game, confirming_player: player_three).call

  [player_one, player_two, player_three]
end

def create_notification(player : Player, notification_type : String? = nil, source : Jennifer::Model::Base? = nil, title : String? = nil, content : String? = nil, sent_at : Time? = Time.now, read_at : Time? = nil)
  Notification.create!({
    player_id: player.id,
    type: notification_type || Notification::GENERAL,
    source_type: source.nil? ? nil : source.class.name,
    source_id: source.try(&.id),
    title: title || "New Notification",
    content: content || "with some descriptive content",
    sent_at: sent_at,
    read_at: read_at
  })
end
