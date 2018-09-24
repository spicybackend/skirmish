h2 Sign Up

- if user.errors || player.errors
  ul.errors
  - (user.errors.full_messages + player.errors.full_messages).each do |error_message|
    li = error_message

form action="/registration" method="post"
  == csrf_tag
  .form-group
    input.form-control type="username" name="username" placeholder="Username" value="#{params[:username]?}"
  .form-group
    input.form-control type="email" name="email" placeholder="Email" value="#{user.email}"
  .form-group
    input.form-control type="password" name="password" placeholder="Password"
  button.btn.btn-primary.btn-sm type="submit"
    == t("authentication.register")
<hr/>
== link_to("Already have an account?", "/signin")
