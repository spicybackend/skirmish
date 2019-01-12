class PasswordResetMailer < ApplicationMailer
  def initialize(user : User, reset_token : String)
    super()

    player = user.player!
    to(user.email!, player.tag.to_s)

    self.subject = I18n.translate("mailer.password_reset.subject")
    self.text = render("mailers/password_reset.text.ecr")
    self.html = render("mailers/password_reset.html.slang", "mailer_layout.html.slang")
  end
end
