table.container
  tr.header
    td.content
      h1.title Welcome to Skirmish
      h2.subtitle Hey #{player.tag}, it's game on!
  tr.section
    td.content
      p
        | Once last thing before we get you all set up, we need to confirm you're really who you say you are.
      p
        | Please follow the link to confirm your email address.

      table.button.radius
        tr
          td
            table
              tr
                td == link_to(I18n.translate("mailer.welcome.verify"), "#{ENV["BASE_URL"]}/profile", class: "btn btn-primary")
