class WelcomeMailer < ApplicationMailer
  def initialize(player : Player)
    super()

    user = player.user!
    to(user.email!, player.tag.to_s)

    self.subject = I18n.translate("mailer.welcome.subject")
    self.text = render("mailers/welcome.text.ecr")
    self.html = render("mailers/welcome.html.slang", "mailer_layout.html.slang")
  end
end
