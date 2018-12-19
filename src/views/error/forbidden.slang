- if Amber.env.development?
  h1 403 - Forbidden
  h6.section-header RIP, bad auth?
- else
  h1 Access Denied
  h6.section-header Sorry, it looks like you don't have the permissions needed to access this page.
