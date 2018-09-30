h1 Game Logged
p Hey #{player.tag}, #{logger.tag} has logged a game against you!

p Follow the link below to confirm the game.
== link_to(I18n.translate("game.actions.confirm"), "#{ENV["BASE_URL"]}/leagues/#{game.league_id}/games/#{game.id}", class: "btn btn-primary")
