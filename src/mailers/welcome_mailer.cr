class WelcomeMailer < ApplicationMailer
  getter user : User

  def initialize(player : Player)
    super()

    @user = player.user!

    to(user.email.not_nil!, player.tag.not_nil!)

    self.subject = "Welcome to Skirmish"
    self.text = render("mailers/welcome.text.ecr")
    self.html = render("mailers/welcome.html.slang", "mailer-layout.html.slang")
  end
end
