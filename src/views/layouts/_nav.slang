a.navbar-brand href="/" Skirmish

ul.navbar-nav
  - active = context.request.path == "/" ? "active" : ""
  li class="nav-item nav-item-home #{active}"
    a.nav-link.home href="/" Home

  - active = context.request.path.starts_with?("/leagues") ? "active" : ""
  li class="nav-item #{active}"
    a.nav-link.leagues href="/leagues" Leagues

  span.navbar-split

  - if player = current_player
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

  - else
    span.nav-auth
      - active = context.request.path.starts_with?("/signup") ? "active" : ""
      li class="nav-item #{active} signup"
        a.nav-link href="/signup" == t "authentication.sign_up"

      - active = context.request.path.starts_with?("/signin") ? "active" : ""
      li class="nav-item #{active}"
        a.nav-link.login href="/signin" == t "authentication.sign_in"
