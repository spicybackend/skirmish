h1 Welcome to Skirmish
p Hey #{player.tag}, sweet to see you sign up!

p Just to confirm you're really who you say you are, please follow the link to confirm your email address.
== link_to(I18n.translate("mailer.welcome.verify"), "#{ENV["BASE_URL"]}/profile", class: "btn btn-primary btn-sm")
