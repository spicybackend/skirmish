== render(partial: "league_management/_navs.slang")
.notifications
  - if active_memberships.empty?
    .notification
      span No active players.
  - else
    - active_memberships.each do |membership|
      - player = membership.player!
      a href="/profile/#{player.tag}"
        .notification
          img.icon.gravatar src="#{gravatar_src_for(player)}"
          span.content = player.tag
          span.time
            == form(action: "/leagues/#{league.id}/membership/#{membership.id}/leave", method: :patch) do
              == csrf_tag
              == submit(t("admin.league.actions.leave"), "data-confirm": "Are you sure you want to make leave #{player.tag} from the league?", class: "btn btn-danger")
