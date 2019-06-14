.card.text-white.bg-dark.w-100.mb-3
  .card-header.flex-spread
    span.icon-card-header
      == render(partial: "league/_icon.slang")
      = league.name
    span.text-right = "Rated #{player.rating_for(league)}"

  .card-body
    canvas.league-graph data-league-stats-url="/leagues/#{league.id}/stats/#{player.tag}"

  .card-footer
    a.card-link href="/leagues/#{league.id}" View League
    a.card-link href="/leagues/#{league.id}/games/new?against=#{player.tag}" Log Game
