- if MultiAuth.configuration["google"]?
  a.btn.btn-google-signin href="/multi_auth/google"
    span.logo
    span.text = auth_provider_details ? I18n.translate("authentication.google.switch_account") : I18n.translate("authentication.google.sign_up")

  br
