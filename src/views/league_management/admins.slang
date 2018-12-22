== render(partial: "league_management/_nav.slang")

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
            == submit(t("admin.league.actions.remove_admin"), class: "btn btn-danger")

== form(action: "/leagues/#{league.id}/admins", method: :post, class: "main") do
  h4 Add Admin
  == csrf_tag
  .form-group
    select.form-control.btn.btn-secondary name="player_id"
      - available_players_for_admin.each do |player|
        option value="#{player.id}" = player.tag
  .form-group
    == submit t("admin.league.actions.add_admin"), class: "btn btn-warning"
