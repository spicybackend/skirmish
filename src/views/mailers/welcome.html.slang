table.container
  tr.header
    td.content
      h1.title Welcome to Skirmish
      h2.subtitle Hey #{player.tag}, sweet to see you sign up!
  tr.section
    td.content
      p Just to confirm you're really who you say you are, please follow the link to confirm your email address.

      table.button.radius
        tr
          td
            table
              tr
                td
                  == link_to(I18n.translate("mailer.welcome.verify"), "#{ENV["BASE_URL"]}/profile", class: "btn btn-primary")
