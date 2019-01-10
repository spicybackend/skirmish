module RouterHelper
  def root_path
    "/"
  end

  # session
  def logout_path
    "/signout"
  end

  def sign_in_path
    "/signin"
  end

  def sign_up_path
    "/signup"
end

  # password reset
  def new_password_reset_path
    password_reset_path + "/new"
  end

  def password_reset_path
    "/reset_password"
  end

  def password_reset_path(email)
    "/reset_password/#{email}"
  end
end
