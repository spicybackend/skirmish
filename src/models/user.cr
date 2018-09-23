require "crypto/bcrypt/password"

class User < Jennifer::Model::Base
  include Crypto

  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    email: String,
    hashed_password: String?,
    receive_email_notifications: { type: Bool, default: true },

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  has_one :player, Player


  # validate :email, "is required", ->(user : User) do
  #   (email = user.email) ? !email.empty? : false
  # end

  # validate :email, "already in use", ->(user : User) do
  #   existing = User.find_by email: user.email
  #   !existing || existing.id == user.id
  # end

  # validate :password, "is too short", ->(user : User) do
  #   user.password_changed? ? user.valid_password_size? : true
  # end

  # def player
  #   Player.find_by(user_id: id)
  # end

  def receive_email_notifications?
    receive_email_notifications
  end

  def password=(password)
    @new_password = password
    @hashed_password = Bcrypt::Password.create(password, cost: 10).to_s
  end

  def password
    (hash = hashed_password) ? Bcrypt::Password.new(hash) : nil
  end

  def password_changed?
    new_password ? true : false
  end

  def valid_password_size?
    (pass = new_password) ? pass.size >= 8 : false
  end

  def authenticate(password : String)
    (bcrypt_pass = self.password) ? bcrypt_pass == password : false
  end

  private getter new_password : String?
end
