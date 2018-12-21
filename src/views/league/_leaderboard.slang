.leaderboard.tiles
  - leaderboard.rankings.not_nil!.each do |ranked_player|
    a.tile href="/profile/#{ranked_player[:player].tag}"
      .pre-content = ranked_player[:rank]
      .icon
        img src="#{gravatar_src_for(ranked_player[:player])}"
      .content = ranked_player[:player].tag
      .secondary = ranked_player[:rating]
