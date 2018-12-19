- if Amber.env.development?
  h1 404 - Not Found
  h6.section-header = "#{request.method} - #{request.path}"
- else
  h1 Page not found
  h6.section-header You stumbled across the unknown! Sorry about that.
