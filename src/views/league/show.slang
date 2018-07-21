h1 = league.name
p = league.description

p
  == link_to("Back", "/leagues", class: "btn btn-light btn-sm")
  == link_to("Edit", "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
  == link_to("Delete", "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")

h2 Members
- if current_user
  == render(partial: "_membership_form.slang")

- players = league.active_players
- if players.any?
  ul
    - players.each do |player|
      li = player.user.username
- else
  | No members to show
