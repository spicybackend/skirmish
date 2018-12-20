== render(partial: "league_management/_navs.slang")
.notifications
  - if requests.empty?
    .notification
      span No pending requests.
  - else
    - requests.each do |invite|
      - player = invite.player!
      a href="/profile/#{player.tag}"
        .notification
          img.icon.gravatar src="#{gravatar_src_for(player)}"
          span.content = player.tag
          - unless player.id == current_player.not_nil!.id
            span.time
            - if invite.accepted? && !invite.approved?
              == form(action: "/leagues/#{league.id}/requests/#{invite.id}", method: :patch) do
                == csrf_tag
                == submit(t("invitation.actions.approve"), class: "btn btn-success")
