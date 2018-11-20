class Match < Jennifer::Model::Base
  table_name :matches

  with_timestamps

  mapping(
    id: { type: Int64, primary: true },

    level: Int32,
    tournament_id: Int64,
    player_a_id: Int64?,
    player_b_id: Int64?,
    winner_id: Int64?,
    next_match_id: Int64?,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  belongs_to :tournament, Tournament

  validates_presence :tournament_id
  validates_presence :level
end
