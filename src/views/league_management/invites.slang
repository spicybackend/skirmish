== render(partial: "league_management/_navs.slang")
.notifications
  - if invites_sent.empty?
    .notification
      span No pending invites.
  - else
    - invites_sent.each do |invite|
      - player = invite.player!
      a href="/profile/#{player.tag}"
        .notification
          img.icon.gravatar src="#{gravatar_src_for(player)}"
          span.content = player.tag
          - unless player.id == current_player.not_nil!.id
            span.time
            == form(action: "/leagues/#{league.id}/invites/#{invite.id}", method: :delete) do
              == csrf_tag
              == submit(t("invitation.actions.uninvite"), class: "btn btn-danger")

  == form(action: "/leagues/#{league.id}/invites", method: :post, class: "main") do
    == csrf_tag

    h4 Invite Player

    .form-group
      select.form-control.btn.btn-secondary name="player_id"
        - available_players.each do |player|
          option value="#{player.id}" = player.tag

    .form-group
      == submit t("invitation.actions.invite"), class: "btn btn-primary"
