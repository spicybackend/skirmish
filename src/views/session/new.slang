.authentication
  .background.animated.fadeIn.slow
  .account-box.animated.fadeInUp.faster
    h2.text-center Welcome back!
    p.text-center Login to get back into the action

    - if user.errors
      ul.errors
      - user.errors.each do |error|
        li = error.to_s

    form action="/session" method="post"
      == csrf_tag
      .form-group
        label Email
        input.form-control autofocus="true" type="email" name="email"
      .form-group
        label Password
        input.form-control type="password" name="password"
      button.btn.btn-primary type="submit" Login

    hr

    small
      == link_to("Don't have an account yet?", "/signup")
