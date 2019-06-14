- league = game.league!
- won_or_lost = game.winner.id == player.id ? "Won" : "Lost"
- other_player = game.players_query.where { _id != player.id }.to_a.map(&.tag).join(", ")

a.tile href="/leagues/#{league.id}/games/#{game.id}"
  == render(partial: "league/_icon.slang")
  .content = "#{won_or_lost} against #{other_player} in #{league.name}"
  .secondary = time_units_since(game.created_at)
