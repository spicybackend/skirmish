nav.navbar.navbar-expand-lg.navbar-dark
  a.navbar-brand href="/"
    img.brand-logo src="/dist/images/logo-transparent.svg"
    span.brand-text Skirmish

  ul.navbar-nav
    - if player = current_player
      - render_partial :authenticated_nav
    - else
      - render_partial :public_nav

