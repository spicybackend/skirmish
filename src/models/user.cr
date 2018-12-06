require "crypto/bcrypt/password"

class User < Jennifer::Model::Base
  include Crypto

  with_timestamps

  mapping(
    id: Primary64,
    email: String,
    name: String,
    hashed_password: String?,
    receive_email_notifications: { type: Bool, default: true },

    verification_code: String,
    activated_at: Time?,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  scope :unverified { where { _activated_at == nil } }

  has_one :player, Player

  validates_presence :email
  validates_uniqueness :email
  validates_format :email, /^[a-zA-Z0-9.!#$%&’*+\/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$/

  validates_presence :verification_code
  validates_format :verification_code, /^[0-9a-z]{16}$/

  # validates_length :password, greater_than_or_equal_to: 8
  # validate :password, "is too short", ->(user : User) do
  #   user.password_changed? ? user.valid_password_size? : true
  # end

  def activate!
    update!(activated_at: Time.now) unless activated?
  end

  def activated?
    !!activated_at
  end

  def unverified?
    !activated?
  end

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
