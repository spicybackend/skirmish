class Administrator < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    player_id: Int64?,
    league_id: Int64?,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  belongs_to :player, Player
  belongs_to :league, League

  # validate :player, "is required", ->(admin : Administrator) do
  #   (player = Player.find(admin.player_id)) ? !player.nil? : false
  # end

  # validate :league, "is required", ->(admin : Administrator) do
  #   (league = League.find(admin.league_id)) ? !league.nil? : false
  # end
end
