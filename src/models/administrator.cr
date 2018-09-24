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

  validates_presence :player_id
  validates_presence :league_id

  validates_with PlayerRelationValidator
  validates_with LeagueRelationValidator
end
