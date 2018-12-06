.authentication
  .background.animated.fadeIn.slow
  form.main.account-box.animated.fadeInUp.faster action="/registration" method="post"
    == csrf_tag

    h2 Sign Up
    p.subheading We'll just need some basic details

    - if user.errors || player.errors
      ul.errors
      - (user.errors.full_messages + player.errors.full_messages).each do |error_message|
        li = error_message

    .form-group
      label Player Tag
      input class="form-control #{"is-invalid" if player.errors[:tag].any?}" autofocus="true" type="username" name="username" value="#{params[:username]?}" required="true"
    .form-group
      label Name
      input class="form-control #{"is-invalid" if user.errors[:name].any?}" autofocus="true" type="name" name="name" value="#{params[:name]?}" required="true"
    .form-group
      label Email
      input class="form-control #{"is-invalid" if user.errors[:email].any?}" type="email" name="email" value="#{user.email}" required="true"
    .form-group
      label Password
      input class="form-control #{"is-invalid" if user.errors[:password].any?}" type="password" name="password" required="true"
    button.btn.btn-primary type="submit"
      == t("authentication.register")

    hr

    small
      == link_to("Already have an account?", "/signin")
