- if MultiAuth.configuration["google"]?
  - if google_provider = auth_providers.google.first
    a.btn.btn-google-signin.disabled disabled="true"
      span.logo
      span.text Unlink from Google
  - else
    a.btn.btn-google-signin href="/multi_auth/google"
      span.logo
      span.text Sign in with Google

  br
