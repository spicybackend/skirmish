class WelcomeMailer < Mailer::Message
  def initialize(name : String, email : String)
    super()

    to(email, name)

    self.from = "Skirmish <developer@mail.skirmish.online>"
    self.subject = "Welcome to Skirmish"

    self.text = "hi, welcome, hello." #render("mailers/welcome_mailer.text.ecr")
    self.html = "<h1>Welcome</h1><p>Hi, hello.</p>" #render("mailers/welcome_mailer.html.slang", "mailer-layout.html.slang")
  end

  def deliver
    send
  end
end
