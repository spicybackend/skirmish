.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Tournaments
    .btn-group
      - if current_player.try(&.admin_of?(league)) && tournaments.all? { |tournament| tournament.finished_at }
        span.toggle-button-group
          .btn-group
            button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
              | Admin Tools
            .dropdown-menu.dropdown-menu-right
              == link_to(t("tournament.actions.open"), "/leagues/#{league.id}/tournaments/new", class: "dropdown-item")

p.description
  | For
  == link_to(league.name, "/leagues/#{league.id}")

.notifications
  - tournaments.each do |tournament|
    a href="/leagues/#{league.id}/tournaments/#{tournament.id}"
      .notification
        img.icon src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
        - if tournament.open?
          span.content Open to join
        - elsif tournament.in_progress?
          span.content In progress
        - else
          span.content Won by #{tournament.winner.try(&.tag)}
        span.time Created #{time_units_since(tournament.created_at)}
