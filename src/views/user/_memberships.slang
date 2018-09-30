.leagues
  - leagues.each do |league|
    a href="/leagues/#{league.id}"
      .league
        img.icon style="background-color: #{league.accent_color};" src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
        span.title = league.name
        span.description = league.description
        span.membership-count = player.rating_for(league)
