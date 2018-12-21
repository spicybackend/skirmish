.notifications
  - leaderboard.rankings.not_nil!.each do |ranked_player|
    a href="/profile/#{ranked_player[:player].tag}"
      .notification
        span.content = ranked_player[:rank]
        img.icon.gravatar src="#{gravatar_src_for(ranked_player[:player])}"
        span.content = ranked_player[:player].tag
        span.time = ranked_player[:rating]
