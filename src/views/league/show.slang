.row
  .col.justify-content-between.btn-toolbar
    h2 = league.name
    - if current_user
      .button-group
        == link_to(t("general.actions.back"), "/leagues", class: "btn btn-light btn-sm")
        - if membership.active?
          == link_to(t("league.actions.log_game"), "/leagues/#{league.id}/games/new", class: "btn btn-primary btn-sm")
        - if current_player.try(&.admin_of?(league))
          == link_to(t("general.actions.edit"), "/leagues/#{league.id}/edit", class: "btn btn-success btn-sm")
          == link_to(t("general.actions.delete"), "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")

p = league.description

- if current_user
  p
    .button-group
      == render(partial: "_membership_form.slang")

h3 Recent Games
== render(partial: "_recent_games.slang")

h3 Leaderboard
- leaderboard = Leaderboard::PureSkill.new(league: league)
== render(partial: "_leaderboard.slang")
