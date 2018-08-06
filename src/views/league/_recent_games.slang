h2 Recent Games

.table-responsive
  table.table.table-striped
    thead
      tr
        th Winner
        th Loser
        th When
        th Actions
    tbody
      - recent_games.each do |game|
        tr
          td = game.winner.try(&.tag)
          td = game.loser.try(&.tag)
          // TODO look into readable date options
          td = game.created_at
          td
            span
              == link_to("read", "/leagues/#{league.id}/games/#{game.id}", class: "btn btn-primary btn-sm")