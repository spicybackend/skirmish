- if MultiAuth.configuration["google"]?
  - if google_provider = auth_providers.google.first
    - cant_remove_auth = user.password_digest.nil? || user.password_digest.blank?
    a class="btn btn-google-signin #{cant_remove_auth ? "disabled" : ""}" href="/multi_auth/unlink/#{google_provider.id}?_csrf=#{csrf_token}" data-method="delete" data-confirm="Are you sure you want to unlink you Google account?"
      span.logo
      span.text = I18n.translate("authentication.google.unlink_account")
  - else
    a.btn.btn-google-signin href="/multi_auth/google"
      span.logo
      span.text = I18n.translate("authentication.google.sign_in")

  br
