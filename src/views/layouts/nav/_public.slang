- active = context.request.path == "/" ? "active" : ""
li class="nav-item nav-item-home #{active}"
  a.nav-link.home href="/" Home

- active = context.request.path.starts_with?("/leagues") ? "active" : ""
li class="nav-item #{active}"
  a.nav-link.leagues href="/leagues" Leagues

span.navbar-split

span.nav-auth
  - active = context.request.path.starts_with?("/signup") ? "active" : ""
  li class="nav-item #{active} signup"
    a.nav-link href="/signup" == t "authentication.sign_up"

  - active = context.request.path.starts_with?("/signin") ? "active" : ""
  li class="nav-item #{active}"
    a.nav-link.login href="/signin" == t "authentication.sign_in"
