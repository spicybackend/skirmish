h2 League Management
p.description = "For #{league.name}"

h3 Invites
h4 Requests
.notifications
  - invites_received.each do |invite|
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

h4 Pending
.notifications
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


h3 Admins
.notifications
  - admin_players.each do |player|
    a href="/profile/#{player.tag}"
      .notification
        img.icon.gravatar src="#{gravatar_src_for(player)}"
        span.content = player.tag
        - unless player.id == current_player.not_nil!.id
          span.time
            == form(action: "/leagues/#{league.id}/admins/#{player.id}", method: :delete) do
              == csrf_tag
              == submit(t("league.actions.remove_admin"), class: "btn btn-danger")

== form(action: "/leagues/#{league.id}/admins", method: :post, class: "main") do
  == csrf_tag

  h4 Add Admin

  .form-group
    select.form-control.btn.btn-secondary name="player_id"
      - available_players_for_admin.each do |player|
        option value="#{player.id}" = player.tag

  .form-group
    == submit t("league.actions.add_admin"), class: "btn btn-warning"
