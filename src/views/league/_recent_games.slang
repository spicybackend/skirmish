h2 Recent Games

.table-responsive
  table.table.table-striped
    thead
      tr
        th Winner
        th Loser
        th When
    tbody
      - recent_games.each do |game|
        tr class="clickable-row" onclick="document.location='/leagues/#{league.id}/games/#{game.id}'"
          td = game.winner.try(&.tag)
          td = game.loser.try(&.tag)
          // TODO look into readable date options
          td = game.created_at