h3 Matches

.notifications
  - tournament.matches_query.without_byes.order(level: :asc, created_at: :asc).each do |match|
    - game_url = match.game_id ? "/leagues/#{tournament.league_id}/games/#{match.game_id}" : "#"
    a href="#{game_url}"
      .notification
        - player_a = match.player_a
        - player_b = match.player_b

        - if player_a
          img.icon.gravatar src="#{player_a ? gravatar_src_for(player_a) : "#"}"
        = player_a.try(&.tag) || "undetermined"

        span.vs vs

        - if player_b
          img.icon.gravatar src="#{player_b ? gravatar_src_for(player_b) : "#"}"
        = player_b.try(&.tag) || "undetermined"

        span.time
          - if winner = match.winner
            - if match.next_match_id
              = "#{winner.tag} won"
            - else
              = "#{winner.tag} is champion"
          - else
            | To be played
