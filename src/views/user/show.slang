h1 Profile
h2 User Info
p class="small"
  == "@#{user.username}"
p
  == user.email
p
  == link_to("edit", "/profile/edit", class: "btn btn-success btn-sm")

- if player = user.player
  h2 Leagues
  p
    - leagues = player.leagues
    - if leagues.any?
      ul
        - player.leagues.each do |league|
          li = league.name
        end
    - else
      | No memberships to show
