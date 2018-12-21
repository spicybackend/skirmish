h3 Entrants
.entrants.tiles
  - tournament.players.each do |player|
    a.tile href="/profile/#{player.tag}"
      .icon
        img src="#{gravatar_src_for(player)}"
      span.content = player.tag
      span.secondary = player.rating_for(league)
