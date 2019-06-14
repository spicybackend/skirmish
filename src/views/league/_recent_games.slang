.recent-games.tiles
  - league.recent_games.each do |game|
    - league = game.league!
    - winner = game.winner
    - other_player = game.players_query.where { _id != winner.id }.to_a.map(&.tag).join(", ")

    a.tile href="/leagues/#{league.id}/games/#{game.id}"
      == render(partial: "league/_icon.slang")
      .content = "#{winner.tag} won against #{other_player}"
      .secondary = time_units_since(game.created_at)
