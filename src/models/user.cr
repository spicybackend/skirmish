require "crypto/bcrypt/password"

class User < Granite::Base
  include Crypto
  adapter mysql

  primary id : Int64
  field username : String
  field email : String
  field hashed_password : String

  timestamps

  after_create :associate_new_player

  def player
    Player.find_by(user_id: id)
  end

  validate :email, "is required", ->(user : User) do
    (email = user.email) ? !email.empty? : false
  end

  validate :email, "already in use", ->(user : User) do
    existing = User.find_by email: user.email
    !existing || existing.id == user.id
  end

  validate :username, "already in use", ->(user : User) do
    existing = User.find_by username: user.username
    !existing || existing.id == user.id
  end

  validate :password, "is too short", ->(user : User) do
    user.password_changed? ? user.valid_password_size? : true
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

  private def associate_new_player
    Player.create(
      user_id: id
    )
  end
end
