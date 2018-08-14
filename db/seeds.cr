require "../config/application.cr"

admin_user = User.new
admin_user.email = "admin@example.com"
admin_user.password = "password"
admin_user.save!
admin = Player.create!(
  tag: "admin",
  user_id: admin_user.id
)

Administrator.create!(
  user_id: admin.id
)

unless Amber.env.production?
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

  [alice, bob].each do |player|
    Membership.create!(
      player_id: player.id,
      league_id: hotdog_league.id,
    )
  end

  logged_hotdog_game = Game.create!(
    league_id: hotdog_league.id,
    winner_id: alice.id,
    logged_by_id: alice.id
  )

  Game::Confirm.new(
    game: logged_hotdog_game,
    confirming_player: bob
  ).call

  [alice, bob].each_with_index do |player, index|
    won = index == 0

    Participation.create!(
      game_id: logged_hotdog_game.id,
      player_id: player.id,
      won: won,
      rating: Rating::DetermineNewRating.new(
        old_rating: hotdog_league.start_rating || League::DEFAULT_START_RATING,
        other_rating: hotdog_league.start_rating || League::DEFAULT_START_RATING,
        won: won,
        league: hotdog_league
      ).call
    )
  end
end
