h2 League Management
p.description = "For #{league.name}"

h3 Invites
h4 Requests
.requests.tiles
  - invites_received.each do |invite|
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

h4 Pending
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
  == csrf_tag

  h4 Invite Player

  .form-group
    select.form-control.btn.btn-secondary name="player_id"
      - available_players.each do |player|
        option value="#{player.id}" = player.display_name

  .form-group
    == submit t("invitation.actions.invite"), class: "btn btn-primary"


h3 Admins
.admins.tiles
  - admin_players.each do |player|
    a.tile href="/profile/#{player.tag}"
      .icon
        img src="#{gravatar_src_for(player)}"
      .content = player.display_name
      - unless player.id == current_player.not_nil!.id
        .secondary
          == form(action: "/leagues/#{league.id}/admins/#{player.id}", method: :delete) do
            == csrf_tag
            == submit(t("league.actions.remove_admin"), class: "btn btn-danger")

== form(action: "/leagues/#{league.id}/admins", method: :post, class: "main") do
  == csrf_tag

  h4 Add Admin

  .form-group
    select.form-control.btn.btn-secondary name="player_id"
      - available_players_for_admin.each do |player|
        option value="#{player.id}" = player.display_name

  .form-group
    == submit t("league.actions.add_admin"), class: "btn btn-warning"
