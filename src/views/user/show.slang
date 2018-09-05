.row
  .col.justify-content-between.btn-toolbar
    h2 Profile
    .button-group
      == link_to(t("general.actions.edit"), "/profile/edit", class: "btn btn-success btn-sm")

h3 User Info

p class="small"
  == "#{player.tag}"
p
  == user.email

h3 Recent Games
== render(partial: "_recent_games.slang")

h3 Memberships
- leagues = player.leagues
== render(partial: "_memberships.slang")
