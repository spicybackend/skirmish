.row
  .col-sm-11
    h2 Leagues
  .col-sm-1
    a.btn.btn-success.btn-sm href="/leagues/new" New
.table-responsive
  table.table.table-striped
    thead
      tr
        th Name
        th Description
        th Actions
    tbody
      - leagues.each do |league|
        tr
          td = league.name
          td = league.description
          td
            span
              == link_to("read", "/leagues/#{league.id}", class: "btn btn-primary btn-sm")
              == link_to("edit", "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
              == link_to("delete", "/leagues/#{ league.id }?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
