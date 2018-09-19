require "kilt"

class WelcomeMailer < Mailer::Message
  def initialize(name : String, email : String)
    super()

    to(email, name)

    self.from = "Skirmish <skirmish.online@gmail.com>"
    self.subject = "Welcome to Skirmish"

    self.text = render("mailers/welcome_mailer.text.ecr")
    self.html = render("mailers/welcome_mailer.html.slang", "mailer-layout.html.slang")
  end

  def deliver
    send
  end

  macro render(filename, layout, *args)
    content = render("{{filename.id}}", {{*args}})
    render("layouts/{{layout.id}}")
  end

  macro render(filename, *args)
    Kilt.render("src/views/{{filename.id}}", {{*args}})
  end
end
