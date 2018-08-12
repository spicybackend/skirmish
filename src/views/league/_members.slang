table.table.table-striped
  thead
    tr
      th Name
      th Rating
  tbody
    - members.each do |player|
      tr
        td = player.tag
        td = player.rating_for(league)
