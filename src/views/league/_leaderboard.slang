.notifications
  - leaderboard.rankings.each do |ranking, player|
    a href="/profile/#{player.tag}"
      .notification
        span.content = ranking
        img.icon.gravatar src="#{gravatar_src_for(player)}"
        span.content = player.tag
        span.time = player.rating_for(league)
