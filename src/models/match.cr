class Match < Jennifer::Model::Base
  table_name :matches

  with_timestamps

  mapping(
    id: Primary64,

    level: Int32,
    tournament_id: Int64,
    player_a_id: Int64?,
    player_b_id: Int64?,
    game_id: Int64?,
    winner_id: Int64?,
    next_match_id: Int64?,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  belongs_to :tournament, Tournament

  validates_presence :tournament_id
  validates_presence :level

  scope :without_byes { where { (_level != 0) | g((_player_a_id != nil) & (_player_b_id != nil)) } }

  def player_a
    Player.find(player_a_id)
  end

  def player_b
    Player.find(player_b_id)
  end

  def winner
    Player.find(winner_id)
  end
end
