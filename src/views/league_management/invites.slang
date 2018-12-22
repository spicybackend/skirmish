== render(partial: "league_management/_nav.slang")

- if invites_sent.empty?
  h3 No pending invites
- else
  .invites.tiles
    - invites_sent.each do |invite|
      - player = invite.player!

      a.tile href="/profile/#{player.tag}"
        .icon
          img src="#{gravatar_src_for(player)}"
        .content = player.display_name
        - unless player.id == current_player.not_nil!.id
          - if invite.approved? && !invite.accepted?
            .secondary
              == form(action: "/leagues/#{league.id}/invites/#{invite.id}", method: :delete) do
                == csrf_tag
                == submit(t("invitation.actions.uninvite"), class: "btn btn-danger")

== form(action: "/leagues/#{league.id}/invites", method: :post, class: "main") do
  h4 Invite Player
  == csrf_tag
  .form-group
    select.form-control.btn.btn-secondary name="player_id"
      - available_players.each do |player|
        option value="#{player.id}" = player.tag
  .form-group
    == submit t("invitation.actions.invite"), class: "btn btn-primary"
