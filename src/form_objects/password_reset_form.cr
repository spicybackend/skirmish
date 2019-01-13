require "./concerns/user_authentication"

class PasswordResetForm < FormObject::Base(User)
  include UserAuthentication

  path "password_reset"

  delegate :email, :id, to: :resource

  def persist
    resource.password_digest = password_digest
    resource.save
  end

  # This method should be muted as attr :password has already added relevant validation
  private def validate_password_presence
  end
end
