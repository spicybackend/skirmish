.notifications
  - player.recent_games.each do |game|
    - league = game.league!
    a href="/leagues/#{league.id}/games/#{game.id}"
      .notification
        img.icon src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
        - won_or_lost = game.winner.id == player.id ? "Won" : "Lost"
        - other_player = game.players_query.where { _id != player.id }.to_a.map(&.tag).join(", ")
        span.content = "#{won_or_lost} against #{other_player} in #{league.name}"
        span.time = time_units_since(game.created_at)
