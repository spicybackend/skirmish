require "../config/application.cr"
# Automatically load schema and run migrations on the test database
Jennifer::Migration::Runner.load_schema
Jennifer::Migration::Runner.migrate

Jennifer::Adapter.adapter.transaction do
  if Amber.env.development?
    alice_user = User.build(
      email: "alice@skirmish.online",
      receive_email_notifications: false,
      verification_code: Random::Secure.hex(8),
      activated_at: Time.now
    )
    alice_user.password = "password"
    alice_user.save!
    alice = Player.create!(
      tag: "Alice",
      user_id: alice_user.id
    )

    bob_user = User.build(
      email: "bob@skirmish.online",
      receive_email_notifications: false,
      verification_code: Random::Secure.hex(8),
      activated_at: Time.now
    )
    bob_user.password = "password"
    bob_user.save!
    bob = Player.create!(
      tag: "Bob",
      user_id: bob_user.id
    )

    charlie_user = User.build(
      email: "charlie@skirmish.online",
      receive_email_notifications: false,
      verification_code: Random::Secure.hex(8),
      activated_at: Time.now
    )
    charlie_user.password = "password"
    charlie_user.save!
    charlie = Player.create!(
      tag: "Charlie",
      user_id: charlie_user.id
    )

    danielle_user = User.build(
      email: "danielle@skirmish.online",
      receive_email_notifications: false,
      verification_code: Random::Secure.hex(8),
      activated_at: Time.now
    )
    danielle_user.password = "password"
    danielle_user.save!
    danielle = Player.create!(
      tag: "Danielle",
      user_id: danielle_user.id
    )

    erik_user = User.build(
      email: "erik@skirmish.online",
      receive_email_notifications: false,
      verification_code: Random::Secure.hex(8),
      activated_at: Time.now
    )
    erik_user.password = "password"
    erik_user.save!
    erik = Player.create!(
      tag: "Erik",
      user_id: erik_user.id
    )

    hotdog_league = League.create!(
      name: "Hotdog Eating League (HEL)",
      description: "Down a hotdog as fast as possible!",
      start_rating: League::DEFAULT_START_RATING,
      k_factor: League::DEFAULT_K_FACTOR,
    )

    Administrator.create!(
      player_id: alice.id,
      league_id: hotdog_league.id
    )

    [alice, bob, charlie, danielle, erik].each do |player|
      Membership.create!(
        player_id: player.id,
        league_id: hotdog_league.id,
        joined_at: Time.now
      )
    end

    tournament = Tournament::Open.new(league: hotdog_league).call.not_nil!
    [alice, bob, charlie, danielle, erik].each do |player|
      Tournament::Enter.new(player: player, tournament: tournament).call
    end
    Tournament::Start.new(tournament: tournament).call

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

    game_logger = League::LogGame.new(
      league: hotdog_league,
      winner: charlie,
      loser: danielle,
      logger: charlie
    )
    game_logger.call
    logged_hotdog_game = game_logger.game

    Game::Confirm.new(
      game: logged_hotdog_game,
      confirming_player: danielle
    ).call
  end
end
