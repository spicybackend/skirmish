table.container
  tr.header
    td.content
      h1.title = I18n.translate("mailer.game_logged.title")
      h2.subtitle = I18n.translate("mailer.game_logged.subtitle", { logger: logger.tag })
  tr.section
    td.content
      p = I18n.translate("mailer.game_logged.content")

      table.button.radius
        tr
          td
            table
              tr
                td == link_to(I18n.translate("mailer.game_logged.action"), "#{ENV["BASE_URL"]}/leagues/#{game.league_id}/games/#{game.id}", class: "btn btn-primary")
