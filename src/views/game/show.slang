h1 | Game
p
  == link_to("Back", "/leagues/#{game.league_id}", class: "btn btn-light btn-sm")
p | The winner was...
  == game.winner.try(&.tag)

== render(partial: "_confirmation_form.slang")
