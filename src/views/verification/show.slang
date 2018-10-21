.image-content
  #email-verification-check.image
  .content
    h2 = t("registration.registered")

    p = t("registration.content")
    p = t("registration.verification", { email_address: user.email })
