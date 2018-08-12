h2 Profile

.row
  .col-sm-11
    h3 User Info
  .col-sm-1
   == link_to("edit", "/profile/edit", class: "btn btn-success btn-sm")

p class="small"
  == "@#{user.username}"
p
  == user.email

- if player = user.player
  h3 Memberships
  - leagues = player.leagues
  table.table.table-striped
    thead
      tr
        th Name
        th Description
        th Rating
        th Actions
    tbody
      - leagues.each do |league|
        tr
          td = league.name
          td = league.description
          td = player.rating_for(league)
          td
            span
              == link_to("read", "/leagues/#{league.id}", class: "btn btn-primary btn-sm")
