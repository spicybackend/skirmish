- active = context.request.path == "/" ? "active" : ""
li class="nav-item nav-item-home #{active}"
  a.nav-link.home href="/" Home

- active = context.request.path.starts_with?("/leagues") ? "active" : ""
li class="nav-item #{active}"
  a.nav-link.leagues href="/leagues" Leagues

span.navbar-split

- active = context.request.path.starts_with?("/notifications") ? "active" : ""
li class="nav-item #{active}"
  a.nav-link.notifications href="/notifications" Notifications
    - notification_count = notification_count_for(player)
    - if notification_count > 0
      span.notification-count == notification_count

- active = context.request.path.starts_with?("/profile") ? "active" : ""
li class="nav-item #{active}"
  a.nav-link.profile href="/profile" = player.tag
a.gravatar href="/profile"
  img.gravatar src="#{gravatar_src_for(player)}"
