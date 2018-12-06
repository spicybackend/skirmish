h3 Entrants
.notifications
  - tournament.players.each do |player|
    a href="/profile/#{player.tag}"
      .notification
        img.icon.gravatar src="#{gravatar_src_for(player)}"
        span.content = player.tag
        span.time = player.rating_for(league)
