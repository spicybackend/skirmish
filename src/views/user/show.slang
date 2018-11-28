.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Profile
    - if own_profile?
      .button-group
        == link_to(t("general.actions.edit"), "/profile/edit", class: "btn btn-primary")
        == link_to(t("authentication.sign_out"), "/signout", class: "btn btn-danger")

.player-profile.animated.zoomIn.fast
  img.gravatar src="#{gravatar_src_for(player)}"
  h3.name = player.tag

- if own_profile?
  h3 Unconfirmed Games
  .notifications
    - player.unconfirmed_games.each do |game|
      - league = game.league!
      a href="/leagues/#{league.id}/games/#{game.id}"
        .notification
          img.icon src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
          - won_or_lost = game.winner.id == player.id ? "Won" : "Lost"
          - other_player = game.players_query.where { _id != player.id }.to_a.map(&.tag).join(", ")
          span.content = "#{won_or_lost} against #{other_player} in #{league.name}"
          span.time = time_units_since(game.created_at)

h3 Recent Games
== render(partial: "_recent_games.slang")

h3 Memberships
- leagues = player.leagues
== render(partial: "_memberships.slang")
