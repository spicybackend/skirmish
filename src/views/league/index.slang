.row
  .col.justify-content-between.btn-toolbar
    h2 Leagues
    - if current_user
      .button-group
        a.btn.btn-success.btn-sm href="/leagues/new" New

.table-responsive
  table.table.table-striped
    thead
      tr
        th Name
        th Description
        th.right Actions
    tbody
      - leagues.each do |league|
        tr
          td = league.name
          td = league.description
          td.right
            span
              == link_to("read", "/leagues/#{league.id}", class: "btn btn-primary btn-sm")
              - if current_user.try(&.admin_of?(league))
                == link_to("edit", "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
                == link_to("delete", "/leagues/#{ league.id }?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
