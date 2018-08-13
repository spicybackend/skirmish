require "../config/application.cr"

admin = User.new
admin.username = "Admin"
admin.email = "admin@example.com"
admin.password = "password"
admin.save!


Administrator.create!(
  user_id: admin.id
)

unless Amber.env.production?
  alice = User.new
  alice.username = "Alice"
  alice.email = "alice@example.com"
  alice.password = "password"
  alice.save!

  bob = User.new
  bob.username = "Bob"
  bob.email = "bob@example.com"
  bob.password = "password"
  bob.save!

  charlie = User.new
  charlie.username = "Charlie"
  charlie.email = "charlie@example.com"
  charlie.password = "password"
  charlie.save!

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

  # In this seeds file we're actually using user ids as the player ids...
  # TODO Clean this up when tag is actually set on the players table instead of the users (as username)
  if player_bob = bob.player
    Game::Confirm.new(
      game: logged_hotdog_game,
      confirming_player: player_bob
    ).call
  end

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
