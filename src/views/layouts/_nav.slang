a.navbar-brand href="/" Skirmish

ul.navbar-nav
  - active = context.request.path == "/" ? "active" : ""
  li class="nav-item nav-item-home #{active}"
    a.nav-link.home href="/" Home

  - active = context.request.path.starts_with?("/leagues") ? "active" : ""
  li class="nav-item #{active}"
    a.nav-link.leagues href="/leagues" Leagues

  - if player = current_player
    - active = context.request.path.starts_with?("/notifications") ? "active" : ""
    li class="nav-item #{active}"
      a.nav-link.notifications href="/notifications" Notifications
        - notification_count = notification_count_for(player)
        - if notification_count > 0
          span.notification-count == notification_count

    span.nav-profile

      - active = context.request.path.starts_with?("/profile") ? "active" : ""
      li class="nav-item #{active} dropdown"
        a.nav-link.dropdown-toggle.profile data-toggle="dropdown" href="#" role="button" aria-haspopup="true" aria-expanded="false" = player.tag
        span.dropdown-menu-wrapper
          .dropdown-menu.dropdown-menu-right
            a class="dropdown-item #{active}" href="/profile" Profile
            .dropdown-divider
            a.dropdown-item href="/signout" == t "authentication.sign_out"
      img.gravatar src="#{gravatar_src_for(player)}"

  - else
    span.nav-auth
      - active = context.request.path.starts_with?("/signup") ? "active" : ""
      li class="nav-item #{active} signup"
        a.nav-link href="/signup" == t "authentication.sign_up"

      - active = context.request.path.starts_with?("/signin") ? "active" : ""
      li class="nav-item #{active}"
        a.nav-link.login href="/signin" == t "authentication.sign_in"
