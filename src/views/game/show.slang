.row
  .col.justify-content-between.btn-toolbar
    h2 Game
    - if current_user
      .button-group
        == link_to(t("general.actions.back"), "/leagues/#{game.league_id}", class: "btn btn-light btn-sm")
        - if show_game_confirmation
          == render(partial: "_confirmation_form.slang")

/ stuff here
.game-results
  .player-result
    img.gravatar src="#{gravatar_src_for(game.winner)}"
    span.name = game.winner.tag
  span.versus VS
  .player-result
    img.gravatar src="#{gravatar_src_for(game.loser)}"
    span.name = game.loser.tag

p | The winner was...
  == game.winner.try(&.tag)
