h2 Edit Profile

- if user.errors || player.errors
  ul.errors
  - (user.errors.full_messages + player.errors.full_messages).each do |error|
    li = error

== form(action: "/profile", method: :patch) do
  == csrf_tag
  .form-group
    input.form-control type="username" name="username" placeholder="Display name" value="#{player.tag}"
  .form-group
    input.form-control type="email" name="email" placeholder="Email" value="#{user.email}"
  == submit("Update", class: "btn btn-primary")
  == link_to("Cancel", "/profile", class: "btn btn-light")
