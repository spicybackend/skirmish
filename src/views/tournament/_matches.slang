h3 Matches

.matches.tiles
  - tournament.matches_query.without_byes.order(level: :asc, created_at: :asc).each do |match|
    - game_url = match.game_id ? "/leagues/#{tournament.league_id}/games/#{match.game_id}" : "#"
    a.tile href="#{game_url}"
      - player_a = match.player_a
      - player_b = match.player_b

      - if player_a
        .icon
          img src="#{player_a ? gravatar_src_for(player_a) : "#"}"

      - if player_b
        .icon
          img src="#{player_b ? gravatar_src_for(player_b) : "#"}"

      .content
        = player_a.try(&.tag) || "undetermined"
        | vs
        = player_b.try(&.tag) || "undetermined"

      .secondary
        - if winner = match.winner
          - if match.next_match_id
            = "#{winner.tag} won"
          - else
            = "#{winner.tag} is the champion"
        - else
          | To be played
