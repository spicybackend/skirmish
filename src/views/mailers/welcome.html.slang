table.container
  tr.header
    td.content
      h1.title = I18n.translate("mailer.welcome.title")
      h2.subtitle = I18n.translate("mailer.welcome.subtitle", { name: player.tag })
  tr.section
    td.content
      p = I18n.translate("mailer.welcome.content")

      p = I18n.translate("mailer.welcome.verification.content")
      table.button.radius
        tr
          td
            table
              tr
                td == link_to(I18n.translate("mailer.welcome.verification.action"), "#{ENV["BASE_URL"]}/profile", class: "btn btn-primary")
