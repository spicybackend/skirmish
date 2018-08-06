h1 | Game
p
  == link_to("Back", "/leagues/#{game.league.id}", class: "btn btn-light btn-sm")
p | The winner was...
  == game.winner.try(&.tag)
