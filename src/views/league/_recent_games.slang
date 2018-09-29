.table-responsive
  table.table.table-striped
    thead
      tr
        th Winner
        th Loser
        th When
        th.right Actions
    tbody
      - league.recent_games.each do |game|
        tr
          td = game.winner.try(&.tag)
          td = game.loser.try(&.tag)
          td = game.confirmed? ? time_units_since(game.confirmed_at) : t("game.status.pending")
          td.right
            span
              == link_to(t("general.actions.view"), "/leagues/#{league.id}/games/#{game.id}", class: "btn btn-primary")
