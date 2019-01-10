== render(partial: "league_management/_nav.slang")

- if active_memberships.empty?
    h3 No active players
- else
  .players.tiles
    - active_memberships.each do |membership|
      - player = membership.player!
      a.tile href="/profile/#{player.tag}"
        .icon
          img.gravatar src="#{gravatar_src_for(player)}"
        .content = player.tag
        - unless player.id == current_player.not_nil!.id
          .secondary
            == form(action: "/leagues/#{league.id}/membership/#{membership.id}/leave", method: :patch) do
              == csrf_tag
              == submit(t("admin.league.actions.leave"), "data-confirm": "Are you sure you want to kick #{player.tag} from the league?", class: "btn btn-warning")
