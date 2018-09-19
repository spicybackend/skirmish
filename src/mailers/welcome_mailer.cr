class WelcomeMailer < ApplicationMailer
  def initialize(player : Player)
    super()

    to(player.user.email.not_nil!, player.tag.not_nil!)

    self.from = "Skirmish <skirmish.online@gmail.com>"
    self.subject = "Welcome to Skirmish"

    self.text = render("mailers/welcome_mailer.text.ecr")
    self.html = render("mailers/welcome_mailer.html.slang", "mailer-layout.html.slang")
  end
end
