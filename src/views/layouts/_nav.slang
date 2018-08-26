
a.navbar-brand href="/" Skirmish

button.navbar-toggler type="button" data-toggle="collapse" data-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation"
  span.navbar-toggler-icon

.collapse.navbar-collapse id="navbarSupportedContent"
  ul.navbar-nav.mr-auto
    - active = context.request.path == "/" ? "active" : ""
    li class="nav-item #{active}"
      a.nav-link href="/" Home

    - active = context.request.path == "/leagues" ? "active" : ""
    li class="nav-item #{active}"
      a.nav-link href="/leagues" Leagues

  ul.navbar-nav
    - if player = current_player
      span.nav-profile
        li.nav-item.dropdown.profile
          - active = context.request.path == "/profile" ? "active" : ""
          a class="nav-link dropdown-toggle #{active}" href="#" id="navbarDropdown" role="button" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
            == "#{player.tag}"

          .dropdown-menu aria-labelledby="navbarDropdown"
            a.dropdown-item href="/profile" Profile
            a.dropdown-item href="/signout" Sign Out

        img.gravatar src="#{gravatar_src_for(player)}?s=40"
    - else
      - active = context.request.path == "/signup" ? "active" : ""
      li class="nav-item #{active} auth"
        a.nav-link href="/signup" Sign Up

      - active = context.request.path == "/signin" ? "active" : ""
      li class="nav-item #{active}"
        a.nav-link href="/signin" Sign In
