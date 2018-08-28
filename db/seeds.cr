require "../config/application.cr"

if Amber.env.development?
  alice_user = User.new
  alice_user.email = "alice@example.com"
  alice_user.password = "password"
  alice_user.save!
  alice = Player.create!(
    tag: "Alice",
    user_id: alice_user.id
  )

  bob_user = User.new
  bob_user.email = "bob@example.com"
  bob_user.password = "password"
  bob_user.save!
  bob = Player.create!(
    tag: "Bob",
    user_id: bob_user.id
  )

  charlie_user = User.new
  charlie_user.email = "charlie@example.com"
  charlie_user.password = "password"
  charlie_user.save!
  charlie_user = Player.create!(
    tag: "Charlie",
    user_id: charlie_user.id
  )

  hotdog_league = League.create!(
    name: "Hotdog Eating League (HEL)",
    description: "Down a hotdog as fast as possible!",
    start_rating: League::DEFAULT_START_RATING,
    k_factor: League::DEFAULT_K_FACTOR,
  )

  Administrator.create!(
    user_id: alice_user.id,
    league_id: hotdog_league.id
  )

  [alice, bob].each do |player|
    Membership.create!(
      player_id: player.id,
      league_id: hotdog_league.id,
      joined_at: Time.now
    )
  end

  game_logger = League::LogGame.new(
    league: hotdog_league,
    winner: alice,
    loser: bob,
    logger: alice
  )
  game_logger.call
  logged_hotdog_game = game_logger.game

  Game::Confirm.new(
    game: logged_hotdog_game,
    confirming_player: bob
  ).call
end
