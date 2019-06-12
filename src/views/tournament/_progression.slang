h3 Progression

- opponent = upcoming_opponent

- if opponent
  - if game = upcoming_match.not_nil!.game
    - if winner = game.winner
      - if winner.id == opponent.id
        p
          span You lost to
          a href="/profile/#{opponent.tag}" = opponent.display_name
      - else
        p
          span You won against
          a href="/profile/#{opponent.tag}" = opponent.display_name

    - if !game.confirmed?
      p Game to be confirmed
  - else
    p
      span You're up against
      a href="/profile/#{opponent.tag}" = opponent.display_name
- else
  p Still waiting on other games
