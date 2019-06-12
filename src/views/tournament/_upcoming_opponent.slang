h3 Upcoming Opponent

- opponent = upcoming_opponent

- if opponent
  - if game = upcoming_match.not_nil!.game
    - if winner = game.winner
      - if winner.id == opponent.id
        p = "You lost to #{winner.display_name}"
      - else
        p = "You won against #{opponent.display_name}"

    - if !game.confirmed?
      p Game to be confirmed
  - else
    p = "You're up against #{opponent.display_name}"
- else
  p Still waiting on other games
