table.table.table-striped
  thead
    tr
      th Ranking
      th Name
      th Rating
  tbody
    - leaderboard.rankings.each do |ranking, player|
      tr
        td = ranking
        td = player.tag
        td = player.rating_for(league)
