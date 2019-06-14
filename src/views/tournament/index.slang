.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Tournaments
    .btn-group
      - if current_player.try(&.admin_of?(league)) && tournaments.all? { |tournament| tournament.finished_at }
        span.toggle-button-group
          .btn-group
            button type="button" class="btn btn-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
              | Admin Tools
            .dropdown-menu.dropdown-menu-right
              == link_to(t("tournament.actions.open"), "/leagues/#{league.id}/tournaments/new", class: "dropdown-item")

p.description
  | For
  == link_to(league.name, "/leagues/#{league.id}")

.tournaments.tiles
  - tournaments.each do |tournament|
    a.tile href="/leagues/#{league.id}/tournaments/#{tournament.id}"
      == render(partial: "league/_icon.slang")
      - if tournament.open?
        content Open to join
      - elsif tournament.in_progress?
        content In progress
      - else
        content Won by #{tournament.winner.try(&.tag)}
      .secondary Created #{time_units_since(tournament.created_at)}
