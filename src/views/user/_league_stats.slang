.card.text-white.bg-dark.w-100.mb-3
  .card-header.flex-spread
    span.icon-card-header
      .icon
        img.glyph style="background-color: #{league.accent_color};" src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
      = league.name
    span.text-right = "Rated #{player.rating_for(league)}"

  .card-body
    p.card-text Some info about the league. Maybe just get rid of it?
    canvas.league-graph data-league-stats-url="/leagues/#{league.id}/stats"

  .list-group.list-group-flush
    li.list-group-item Has won 9 games of 16
    li.list-group-item Has won 2 tournaments
    - membership_time = player.membership_for(league).try(&.created_at)
    li.list-group-item = "Has been a member since #{membership_time ? Time::Format.new("%-d %b %Y").format(membership_time) : "ages ago"}"

  .card-body
    a.card-link href="/leagues/#{league.id}" View League
    a.card-link href="/leagues/#{league.id}/games/new?against=#{player.tag}" Log Game
