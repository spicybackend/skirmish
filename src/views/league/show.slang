h1 = league.name
p = league.description

p
  == link_to("Back", "/leagues", class: "btn btn-light btn-sm")
  == link_to("Edit", "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
  == link_to("Delete", "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")

h2 Members
- players = league.active_players

- if current_user
  - if membership.active?
    == form(action: "/leagues/#{league.id.to_s}/leave", method: :patch) do
      == csrf_tag
      == submit("Leave", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
  - else
    == form(action: "/leagues/#{league.id.to_s}/join", method: membership.id ? :patch : :post) do
      == csrf_tag
      == submit("Join", class: "btn btn-primary btn-sm")

p
  - if players.any?
    ul
      - players.each do |player|
        li = player.user.username
  - else
    | No members to show
