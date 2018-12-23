== render(partial: "league_management/_nav.slang")

- if inactive_memberships.empty?
  h3 No inactive players
- else
  .players.tiles
    - inactive_memberships.each do |membership|
      - player = membership.player!
      a.tile href="/profile/#{player.tag}"
        .icon
          img src="#{gravatar_src_for(player)}"
        .content = player.tag
        .secondary
          == form(action: "/leagues/#{league.id}/membership/#{membership.id}/rejoin", method: :patch) do
            == csrf_tag
            == submit(t("admin.league.actions.rejoin"), "data-confirm": "Are you sure you want to resurrect #{player.tag} back into the league?", class: "btn btn-primary")
