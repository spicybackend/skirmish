h1 = league.name
p = league.description

p
  == link_to("Back", "/leagues", class: "btn btn-light btn-sm")
  == link_to("Edit", "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
  == link_to("Delete", "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")

== render(partial: "_recent_games.slang")

h2 Members
- if membership.active? && league.active_players.size > 1
  .form-group
    == link_to("Log Game", "/leagues/#{league.id}/games/new", class: "btn btn-primary btn-sm")

- if current_user
  == render(partial: "_membership_form.slang")

- if league.active_players.any?
  ul
    - league.active_players.each do |player|
      li = player.user.username
- else
  | No members to show
