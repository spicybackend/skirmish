- path = context.request.path
- player = current_player.not_nil!

- if current_league = current_player_context.try(&.league)
  - active = (path.starts_with?("/leagues") && !(path.includes?("/tournaments") || path.includes?("/games/new"))) ? "active" : ""
  li class="nav-item #{active}"
    a.nav-link.leagues href="/leagues/#{current_league.id}" = current_league.name

  - active = path.match(/\/leagues\/\d+\/tournaments/) ? "active" : ""
  li class="nav-item #{active}"
    a.nav-link.tournaments href="/leagues/#{current_league.id}/tournaments" Tournaments

  - if player.member_of?(current_league)
    - active = path.match(/\/leagues\/\d+\/games\/new/) ? "active" : ""
    li class="nav-item #{active} nav-log-game"
      a.nav-link.log-game href="/leagues/#{current_league.id}/games/new" Log Game

- else
  - active = path.starts_with?("/leagues") ? "active" : ""
  li class="nav-item #{active}"
    a.nav-link.leagues href="/leagues" Leagues

span.navbar-split

- active = path.starts_with?("/notifications") ? "active" : ""
li class="nav-item #{active}"
  a.nav-link.notifications href="/notifications" Notifications
    - notification_count = notification_count_for(player)
    - if notification_count > 0
      span.notification-count == notification_count

- active = path.starts_with?("/profile") ? "active" : ""
li class="nav-item #{active}"
  a.nav-link.profile href="/profile" = player.tag
a.gravatar href="/profile"
  img.gravatar src="#{gravatar_src_for(player)}"
