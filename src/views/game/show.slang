.row
  .col.justify-content-between.btn-toolbar
    h2 Game

p
  == link_to(t("general.actions.back"), "/leagues/#{game.league_id}", class: "btn btn-light btn-sm")
p | The winner was...
  == game.winner.try(&.tag)

- if show_game_confirmation
  == render(partial: "_confirmation_form.slang")
