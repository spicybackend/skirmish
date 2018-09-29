.row
  h2.col.justify-content-between.btn-toolbar Profile
    .button-group
      == link_to(t("general.actions.edit"), "/profile/edit", class: "btn btn-success")

.player-profile
  img.gravatar src="#{gravatar_src_for(player)}"
  span.name = player.tag

h3 Recent Games
== render(partial: "_recent_games.slang")

h3 Memberships
- leagues = player.leagues
== render(partial: "_memberships.slang")
