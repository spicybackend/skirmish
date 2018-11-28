a.navbar-brand href="/" Skirmish

ul.navbar-nav
  - if player = current_player
    == render(partial: "layouts/nav/_logged_in.slang")
  - else
    == render(partial: "layouts/nav/_public.slang")
