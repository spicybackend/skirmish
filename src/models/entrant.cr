class Entrant < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    tournament_id: Int64,
    league_id: Int64,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  validates_presence :tournament_id
  validates_presence :league_id

  belongs_to :tournament, Tournament
  belongs_to :player, Player
end
