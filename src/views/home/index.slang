.home.row
  #logo
  .col-sm-12.col-md-6.animated.fadeInRight.fast
    h1 = t("home.heading")
    p = t("home.subtext")
    - if current_user.nil?
      == link_to(t("authentication.sign_up"), "/signup", class: "btn btn-primary")

    hr

    h3 = t("home.sections.leagues.heading")
    p = t("home.sections.leagues.subtext")
    == link_to(t("home.sections.leagues.action"), "/leagues", class: "btn btn-primary")

    hr

    h3 = t("home.sections.tournaments.heading")
    p = t("home.sections.tournaments.subtext")
