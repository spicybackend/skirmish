def create_player_with_mock_user(tag : String? = nil)
  user = User.new({
    email: "#{Random::Secure.hex}@test.com",
    receive_email_notifications: false,
    verification_code: Random::Secure.hex(8)
  })
  user.password = Random::Secure.hex
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

def create_notification(player : Player, event_type : String? = nil, source : Jennifer::Model::Base? = nil, title : String? = nil, content : String? = nil, sent_at : Time? = Time.now, read_at : Time? = nil)
  Notification.create!({
    player_id: player.id,
    event_type: event_type || Notification::GENERAL,
    source_type: source.nil? ? nil : source.class.name,
    source_id: source.try(&.id),
    title: title || "New Notification",
    content: content || "with some descriptive content",
    sent_at: sent_at,
    read_at: read_at
  })
end
