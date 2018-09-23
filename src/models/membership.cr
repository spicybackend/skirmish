class Membership < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    player_id: Int64?,
    league_id: Int64?,

    joined_at: Time?,
    left_at: Time?,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  belongs_to :player, Player
  belongs_to :league, League

  def active?
    !joined_at.nil? && left_at.nil?
  end
end
