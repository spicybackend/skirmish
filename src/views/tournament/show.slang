.row
  h2.col.justify-content-between.btn-toolbar Tournament
    .btn-group
      - if current_entrant
        == form(action: "/leagues/#{league.id}/tournaments/#{tournament.id}/leave", method: :post) do
          == csrf_tag
          == submit(t("league.actions.join"), class: "btn btn-primary")
      - else
        == form(action: "/leagues/#{league.id}/tournaments/#{tournament.id}/join", method: :post) do
          == csrf_tag
          == submit(t("league.actions.join"), class: "btn btn-primary")

      / - if current_player.try(&.admin_of?(league))
        span.toggle-button-group
          .btn-group
            button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
              | Admin Tools
            .dropdown-menu.dropdown-menu-right
              == link_to(t("tournament.actions.open"), "/leagues/#{league.id}/tournaments/new", class: "dropdown-item")
              == link_to(t("general.actions.edit"), "/leagues/#{league.id}/edit", class: "dropdown-item")
              .dropdown-divider
              == link_to(t("general.actions.delete"), "/leagues/#{league.id}?_csrf=#{csrf_token}", "data-method": "delete", "data-confirm": "Are you sure you want to delete #{league.name}?", class: "dropdown-item danger")

span.description = league.name

.notifications
  - tournament.players.each do |player|
    a href="/profile/#"
      .notification
        span.content = "ranking"
        img.icon.gravatar src="#{gravatar_src_for(player)}"
        span.content = player.tag
        span.time = player.rating_for(league)
