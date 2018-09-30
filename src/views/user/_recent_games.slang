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
        - league = game.league!
        tr
          td = league.name
          td = game.winner.id == player.id ? "Won" : "Lost"
          td = game.players_query.where { _id != player.id }.to_a.map(&.tag).join(", ")
          // TODO look into readable date options
          td = time_units_since(game.created_at)
          td.right
            span
              == link_to(t("general.actions.view"), "/leagues/#{league.id}/games/#{game.id}", class: "btn btn-primary")
