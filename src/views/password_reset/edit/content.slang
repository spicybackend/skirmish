- build_form :password_reset, password_reset_path(id), { "class" => "main" }, method: :patch do |f|
  h2 Password reset

  == csrf_tag

  - render_partial :error_messages, form.errors

  == f.hidden_field :email, form.email

  .form-group
    == f.label_for :password, "Password"
    == f.password_field :password, { "class" => "form-control" }

  .form-group
    == f.label_for :password_confirmation, "Password confirmation"
    == f.password_field :password_confirmation, { "class" => "form-control" }

  button.btn.btn-primary Update password
