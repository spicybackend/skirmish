- if Amber.env.development?
  h1 404 - Not Found
  h6.section-header = "#{request.method} - #{request.path}"
- else
  h1 = I18n.translate("error.title.not_found")
  h6.section-header = I18n.translate("error.message.not_found")
