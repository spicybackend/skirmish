require "digest/md5"

module ProfileHelper
  GRAVATAR_BASE_URL = "https://www.gravatar.com"

  def gravatar_src_for(user : User)
    hashed_email = Digest::MD5.hexdigest(user.email.to_s)
    image_src = "#{GRAVATAR_BASE_URL}/avatar/#{hashed_email}?d=robohash&s=2000"
  end

  def gravatar_src_for(player : Player)
    gravatar_src_for(player.user.not_nil!)
  end

  def notification_count_for(player : Player)
    # TODO Optimise read_at by adding a where clause
    Notification.where { _player_id == player.id }.to_a.count { |notification| notification.read? }
  end
end
