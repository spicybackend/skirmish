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

  def debug_output
    "
Match ##{self.id} (lv #{self.level}),
Player #{self.player_a_id} vs,,
Player #{self.player_b_id},
Winner #{self.winner_id},
Game #{self.game_id},
Next match #{self.next_match_id}
    "
  end
end
