.card.text-white.bg-dark.w-100.mb-3
  .card-header.flex-spread
    span.icon-card-header
      .icon
        img.glyph style="background-color: #{league.accent_color};" src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
      = league.name
    span.text-right = "Rated #{player.rating_for(league)}"

  .card-body
    canvas.league-graph data-league-stats-url="/leagues/#{league.id}/stats"

  .card-footer
    a.card-link href="/leagues/#{league.id}" View League
    a.card-link href="/leagues/#{league.id}/games/new?against=#{player.tag}" Log Game
