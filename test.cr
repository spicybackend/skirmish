class Thing
  def self.create_player_with_mock_user(tag : String? = nil, password : String? = nil, verified : Bool = true)
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
end


Jennifer::Adapter.adapter.transaction do
  league = League.all.last.not_nil!
  tournament = Tournament::CreateTournament.new(league: league).call.not_nil!

  puts league
  puts tournament

  new_players = [
    Thing.create_player_with_mock_user,
    Thing.create_player_with_mock_user,
    Thing.create_player_with_mock_user,
    Thing.create_player_with_mock_user,
    Thing.create_player_with_mock_user,
    Thing.create_player_with_mock_user,
    Thing.create_player_with_mock_user,
    Thing.create_player_with_mock_user
  ]

  puts Player.all.count

  new_players.each do |player|
    Entrant.create!(tournament_id: tournament.id, player_id: player.id)
  end


  Tournament::StartTournament.new(tournament).call
end
