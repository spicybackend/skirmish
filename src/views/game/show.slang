.row
  .col.justify-content-between.btn-toolbar
    h2 Game
    - if current_user
      .button-group
        == link_to(t("general.actions.back"), "/leagues/#{game.league_id}", class: "btn btn-light btn-sm")

.game-results
  .winning-result
    .player-result
      img.gravatar src="#{gravatar_src_for(game.winner)}"
      span.name = game.winner.tag
    - if game.confirmed?
      span.rating = winner_rating
    - else
      span.rating.delta = winner_delta
  span.versus VS
  .losing-result
    .player-result
      img.gravatar src="#{gravatar_src_for(game.loser)}"
      span.name = game.loser.tag
    - if game.confirmed?
      span.rating = loser_rating
    - else
      span.rating.delta = loser_delta

.centered
  h3 #{game.winner.tag} won against #{game.loser.tag}
  - if game.confirmed?
    .centered
      p Game confirmed #{time_units_since(game.confirmed_at).downcase}
  - else
    .centered
      - if show_game_confirmation
        p == render(partial: "_confirmation_form.slang")
      p Game not yet confirmed
