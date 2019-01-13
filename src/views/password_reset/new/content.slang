- build_form :password_reset, password_reset_path, { "class" => "main" } do |f|
  h2 Forgot password

  == csrf_tag

  .form-group
    == f.label_for :email, "Email"
    == f.text_field :email, "", { "class" => "form-control" }

  button.btn.btn-primary Submit
