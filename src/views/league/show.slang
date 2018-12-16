.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text = league.name
    .btn-group
      span.toggle-button-group
        .btn-group
          - if membership.id && membership.active?
            == link_to(t("league.actions.log_game"), "/leagues/#{league.id}/games/new", class: "btn btn-primary")
            button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
              span.sr-only Toggle Dropdown
            .dropdown-menu.dropdown-menu-right
              == form(action: "/leagues/#{league.id}/leave", method: :patch) do
                == csrf_tag
                == submit(t("league.actions.leave"), "data-confirm": "Are you sure you want to leave #{league.name}?", class: "dropdown-item danger")
          - elsif league.open?
            == form(action: "/leagues/#{league.id}/join", method: membership.id ? :patch : :post) do
              == csrf_tag
              == submit(t("league.actions.join"), class: "btn btn-primary")
          - elsif unaccepted_invite
            == form(action: "/leagues/#{league.id}/invites/#{unaccepted_invite.id}", method: :patch) do
              == csrf_tag
              == submit(t("invitation.actions.accept"), class: "btn btn-success")
          - elsif league.closed?
            == form(action: "/leagues/#{league.id}/requests", method: :post) do
              == csrf_tag
              == submit(t("invitation.actions.request"), class: "btn btn-primary")

      - if current_player.try(&.admin_of?(league))
        span.toggle-button-group
          .btn-group
            button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
              | Admin Tools
            .dropdown-menu.dropdown-menu-right
              == link_to(t("tournament.actions.open"), "/leagues/#{league.id}/tournaments/new", class: "dropdown-item")
              == link_to(t("general.actions.edit"), "/leagues/#{league.id}/edit", class: "dropdown-item")
              == link_to(t("league.actions.manage_admins"), "/leagues/#{league.id}/management", class: "dropdown-item")
              .dropdown-divider
              == link_to(t("general.actions.delete"), "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure you want to delete #{league.name}?", class: "dropdown-item danger")

p.description = league.description
p.description
  | Not the league you're looking for?
  == link_to("Browse other leagues", "/leagues")

h3.justify-content-between.btn-toolbar Tournaments
  - if tournament
    .btn-group
      == link_to(t("general.actions.view"), "/leagues/#{league.id}/tournaments/#{tournament.id}", class: "btn btn-primary")
- if tournament
  - if tournament.in_progress?
    p There's currently a tournament in progress.
    == render(partial: "tournament/_tournament_tree.slang")
  - elsif tournament.finished?
    p = "The winner of the last tournament was #{tournament.winner.try(&.tag)}."
  - else tournament.open?
    p A new tournament is open for entry!
- else
  p No tournament has been opened for #{league.name}

h3 Leaderboard
- leaderboard = Leaderboard::PureSkill.new(league: league)
== render(partial: "_leaderboard.slang")

h3 Recent Games
== render(partial: "_recent_games.slang")
