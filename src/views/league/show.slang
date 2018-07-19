h1 Show League
p = league.name
p = league.description
p
  == link_to("back", "/leagues", class: "btn btn-light btn-sm")
  == link_to("edit", "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
  == link_to("delete", "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")

h2 Members
p
  - players = league.players
  - if players.any?
    ul
      == league.players.each do |player|
        li player.name
      end
  - else
    | No members to show
