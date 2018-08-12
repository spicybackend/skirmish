  table.table.table-striped
    thead
      tr
        th Name
        th Description
        th Rating
        th.right Actions
    tbody
      - leagues.each do |league|
        tr
          td = league.name
          td = league.description
          td = player.rating_for(league)
          td.right
            span
              == link_to("read", "/leagues/#{league.id}", class: "btn btn-primary btn-sm")
