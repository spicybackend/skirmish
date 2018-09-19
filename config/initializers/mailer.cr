require "mailer"

# development-only sandbox keys ;)
ENV["MAILGUN_KEY"] ||= "53bdf2a7ab13ec965933418a9b17252a-0e6e8cad-a37e4244"
ENV["MAILGUN_DOMAIN"] ||= "sandbox67e2f0abd2b342efbd1a2da180db66f9.mailgun.org"
ENV["SUPPRESS_EMAILS"] ||= "true"

mailgun_provider = Mailer::Mailgun.new(key: ENV["MAILGUN_KEY"], domain: ENV["MAILGUN_DOMAIN"])
Mailer.config(provider: mailgun_provider)
