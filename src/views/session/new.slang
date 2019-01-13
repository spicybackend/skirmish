.authentication
  .background.animated.fadeIn.slow
  form.main.account-box.animated.fadeInUp.faster action="/session" method="post"
    == csrf_tag

    - if redirect_url
      == hidden_field name: "redirect", value: redirect_url

    h2 Welcome back!
    p.subheading Login to get back into the action

    - if user.errors
      ul.errors
      - user.errors.each do |error|
        li = error.to_s

    .form-group
      label Email
      input.form-control autofocus="true" type="email" name="email" required="true"
    .form-group
      label Password
      input.form-control type="password" name="password" required="true"
    button.btn.btn-primary type="submit" Login

    hr

    == render(partial: "_google_auth_button.slang")

    small
      == link_to("Forgot your password?", new_password_reset_path)

    br

    small
      == link_to("Don't have an account yet?", "/signup")
