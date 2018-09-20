require "digest/md5"

module ProfileHelper
  GRAVATAR_BASE_URL = "https://www.gravatar.com"

  def gravatar_src_for(user : User)
    hashed_email = Digest::MD5.hexdigest(user.email.to_s)
    image_src = "#{GRAVATAR_BASE_URL}/avatar/#{hashed_email}?s=2000"
  end

  def gravatar_src_for(player : Player)
    gravatar_src_for(player.user.not_nil!)
  end

  def notification_count_for(player : Player)
    Notification.all("WHERE player_id = ? AND read_at IS NULL", [player.id]).size
  end
end