== render(partial: "league_management/_navs.slang")
.notifications
  - if inactive_memberships.empty?
    .notification
      span No inactive players.
  - else
    - inactive_memberships.each do |membership|
      - player = membership.player!
      a href="/profile/#{player.tag}"
        .notification
          img.icon.gravatar src="#{gravatar_src_for(player)}"
          span.content = player.tag
          span.time
            == form(action: "/leagues/#{league.id}/membership/#{membership.id}/rejoin", method: :patch) do
              == csrf_tag
              == submit(t("admin.league.actions.rejoin"), "data-confirm": "Are you sure you want to add back #{player.tag} from this league?", class: "btn btn-primary")
