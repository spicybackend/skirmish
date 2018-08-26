.row
  .col-sm-11
    h2 = league.name
  .col-sm-1
    - if current_user
      == render(partial: "_membership_form.slang")

p = league.description

p
  == link_to("Back", "/leagues", class: "btn btn-light btn-sm")
  - if membership.active?
    == link_to("Log Game", "/leagues/#{league.id}/games/new", class: "btn btn-primary btn-sm")
  - if current_user.try(&.admin?)
    == link_to("Edit", "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
    == link_to("Delete", "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")

h3 Recent Games
== render(partial: "_recent_games.slang")

h3 Members
- members = league.active_players
== render(partial: "_members.slang")
