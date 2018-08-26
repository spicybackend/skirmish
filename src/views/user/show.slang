h2 Profile

.row
  .col-sm-11
    h3 User Info
  .col-sm-1
   == link_to("edit", "/profile/edit", class: "btn btn-success btn-sm")

p class="small"
  == "#{player.tag}"
p
  == user.email

h3 Recent Games
== render(partial: "_recent_games.slang")

h3 Memberships
- leagues = player.leagues
== render(partial: "_memberships.slang")
