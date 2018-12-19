- if Amber.env.development?
  h1 403 - Forbidden
  h6.section-header RIP, bad auth?
- else
  h1 = I18n.translate("error.title.forbidden")
  h6.section-header = I18n.translate("error.message.forbidden")
