== render(partial: "league_management/_nav.slang")

- if requests.empty?
    h3 No pending requests
- else
  .requests.tiles
    - requests.each do |invite|
      - player = invite.player!

      a.tile href="/profile/#{player.tag}"
        .icon
          img src="#{gravatar_src_for(player)}"
        .content = player.display_name
        - unless player.id == current_player.not_nil!.id
          - if invite.accepted? && !invite.approved?
            .secondary
              == form(action: "/leagues/#{league.id}/requests/#{invite.id}", method: :patch) do
                == csrf_tag
                == submit(t("invitation.actions.approve"), class: "btn btn-success")
