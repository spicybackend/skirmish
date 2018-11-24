.notifications
  - tournament.matches_query.order(level: :asc, created_at: :asc).each do |match|
    .notification
      span.content = match.id
      - player_a = match.player_a
      - player_b = match.player_b

      - if player_a
        img.icon.gravatar src="#{gravatar_src_for(player_a)}"
        = player_a.tag
      - if player_a && player_b
        span.content style="margin-left: 12px;" vs
      - if player_b
        img.icon.gravatar src="#{gravatar_src_for(player_b)}"
        = player_b.tag
      - if winner = match.winner
        - if match.next_match_id
          span.time = "#{winner.tag} preceeded to match #{match.next_match_id}"
        - else
          span.time = "#{winner.tag} has taken out the tournament"
      - else
        span.time To be played
