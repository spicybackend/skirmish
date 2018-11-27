h3 Tournament Closed

.tournament-closure
  .party-popper
    .party-popper-emoji 🎉
    .party-popper-effects
  | #{tournament.winner.try(&.tag)} has won!

== render(partial: "_tournament_tree.slang")
== render(partial: "_matches.slang")
