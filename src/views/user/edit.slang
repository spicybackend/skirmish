== form(action: "/profile", method: :patch, class: "main") do
  == csrf_tag

  h2 Account Details

  p Note that we don't currently handle profile avatars directly, and instead use
    a href="https://en.gravatar.com/" Gravatar.
    | Find out
    a href="https://en.gravatar.com/support/what-is-gravatar/" more information
    | or
    a href="https://en.gravatar.com/connect/?source=_signup" create your own.

  - if user.errors || player.errors
    ul.errors
    - (user.errors.full_messages + player.errors.full_messages).each do |error|
      li = error

  .form-group
    label Player Tag
    input.form-control type="tag" name="tag" placeholder="Player Tag" value="#{player.tag}"
  .form-group
    label Name
    input.form-control type="name" name="name" placeholder="Name" value="#{user.name}"
  .form-group
    label Email
    input.form-control type="email" name="email" placeholder="Email" value="#{user.email}"

  hr

  .form-group
    == link_to("Reset password", new_password_reset_path, class: "btn btn-warning")

  hr

  == render(partial: "_add_google_auth_button.slang")

  == submit("Update", class: "btn btn-primary")
  == link_to("Cancel", "/profile", class: "btn btn-dark")
