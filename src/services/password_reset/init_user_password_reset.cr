require "../base_service"
require "../generate_secure_token"

class PasswordReset::Init < BaseService
  @user : User

  def initialize(@user)
  end

  def call
    token = GenerateSecureToken.call

    @user.reset_digest = token[:digest]
    @user.reset_sent_at = Time.new
    @user.save!

    # , token[:plain]
    PasswordResetMailer.new(@user).send
  end
end
