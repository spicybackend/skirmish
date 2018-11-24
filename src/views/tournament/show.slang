.row
  h2.col.justify-content-between.btn-toolbar Tournament
    .btn-group
      span.toggle-button-group
        .btn-group
          - if tournament.open?
            - if current_entrant
              == link_to(t("tournament.actions.leave"), "/leagues/#{league.id}/tournaments/#{tournament.id}/leave?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure you want to leave the tournament?", class: "btn btn-danger")
            - else
              == form(action: "/leagues/#{league.id}/tournaments/#{tournament.id}/join", method: :post) do
                == csrf_tag
                == submit(t("tournament.actions.join"), class: "btn btn-primary")
          - elsif tournament.in_progress? && current_entrant
            == link_to(t("league.actions.log_game"), "/leagues/#{league.id}/games/new", class: "btn btn-primary")
      - if current_player.try(&.admin_of?(league))
        span.toggle-button-group
          .btn-group
            button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
              | Admin Tools
            .dropdown-menu.dropdown-menu-right
              - if tournament.open?
                == form(action: "/leagues/#{league.id}/tournaments/#{tournament.id}/start", method: :patch) do
                  == csrf_tag
                  == submit(t("tournament.actions.start"), class: "dropdown-item")
                .dropdown-dividerw
              == link_to(t("general.actions.delete"), "/leagues/#{league.id}/tournaments/#{tournament.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure you want to delete the tournament?", class: "dropdown-item danger")

p.description = league.name

- if tournament.in_progress?
  h3 In Progress
  == render(partial: "_matches.slang")
- elsif tournament.open?
  h3 Entrants
  .notifications
    - tournament.players.each do |player|
      a href="/profile/#"
        .notification
          img.icon.gravatar src="#{gravatar_src_for(player)}"
          span.content = player.tag
          span.time = player.rating_for(league)
- elsif tournament.finished?
  h3 Finished
  == render(partial: "_matches.slang")
