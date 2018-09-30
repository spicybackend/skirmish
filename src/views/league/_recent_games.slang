.notifications
  - league.recent_games.each do |game|
    - league = game.league!
    a href="/leagues/#{league.id}/games/#{game.id}"
      .notification
        img.icon src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
        - winner = game.winner
        - other_player = game.players_query.where { _id != winner.id }.to_a.map(&.tag).join(", ")
        span.content = "#{winner.tag} won against #{other_player} in #{league.name}"
        span.time = time_units_since(game.created_at)
