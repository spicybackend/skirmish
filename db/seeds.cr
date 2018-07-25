require "../config/application.cr"

admin = User.new
admin.username = "Admin"
admin.email = "admin@example.com"
admin.password = "password"
admin.save!

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
  )

  [alice, bob].each_with_index do |player, index|
    Participation.create!(
      game_id: logged_hotdog_game.id,
      player_id: player.id,
      won: index == 0,
    )
  end
end