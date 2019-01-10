a.navbar-brand href="/"
  img.brand-logo src="/dist/images/logo-transparent.svg"
  span.brand-text Skirmish

ul.navbar-nav
  - if player = current_player
    == render(partial: "layouts/nav/_logged_in.slang")
  - else
    == render(partial: "layouts/nav/_public.slang")
