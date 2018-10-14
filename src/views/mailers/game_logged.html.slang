table.container
  tr.header
    td.content
      h1.title Game Logged
      h2.subtitle #{logger.tag} has logged a game against you!
  tr.section
    td.content
      p Follow the link below to confirm the game.

      table.button.radius
        tr
          td
            table
              tr
                td == link_to(I18n.translate("game.actions.confirm"), "#{ENV["BASE_URL"]}/leagues/#{game.league_id}/games/#{game.id}", class: "btn btn-primary")
