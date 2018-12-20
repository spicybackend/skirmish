- if MultiAuth.configuration["google"]?
  a.btn.btn-google-signin href="/multi_auth/google"
    span.logo
    span.text = I18n.translate("authentication.google.sign_in")

  br
