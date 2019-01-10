class PasswordResetMailer < ApplicationMailer
  def initialize(user : User)
    super()

    player = user.player!
    to(user.email!, player.tag.to_s)

    self.subject = "Password Reset" # I18n.translate("mailer.welcome.subject")
    self.text = "Reset Time!" # render("mailers/welcome.text.ecr")
    self.html = "Time to reset" # render("mailers/welcome.html.slang", "mailer_layout.html.slang")
  end
end
