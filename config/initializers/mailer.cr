require "mailer"

ENV["SUPPRESS_EMAILS"] ||= "true"

if ENV["MAILGUN_KEY"]? && ENV["MAILGUN_DOMAIN"]?
  mailgun_provider = Mailer::Mailgun.new(
    key: ENV["MAILGUN_KEY"],
    domain: ENV["MAILGUN_DOMAIN"]
  )

  Mailer.config(provider: mailgun_provider)
end
