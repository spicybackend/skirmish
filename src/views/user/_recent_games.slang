.table-responsive
  table.table.table-striped
    thead
      tr
        th League
        th Status
        th Against
        th When
        th.right Actions
    tbody
      - player.recent_games.each do |game|
        tr
          td = game.league.name
          td = game.winner_id == player.id ? "Won" : "Lost"
          td = game.players.all("AND players.id != ?", [player.id]).map(&.tag).join(", ")
          // TODO look into readable date options
          td = time_units_since(game.created_at)
          td.right
            span
              == link_to("read", "/leagues/#{game.league.id}/games/#{game.id}", class: "btn btn-primary btn-sm")
