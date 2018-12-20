- if MultiAuth.configuration["google"]?
  - if google_provider = auth_providers.google.first
    a.btn.btn-google-signin.disabled disabled="true"
      span.logo
      span.text = I18n.translate("authentication.google.unlink_account")
  - else
    a.btn.btn-google-signin href="/multi_auth/google"
      span.logo
      span.text = I18n.translate("authentication.google.sign_in")

  br
