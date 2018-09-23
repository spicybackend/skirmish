class Participation < Jennifer::Model::Base
  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    game_id: Int64,
    player_id: Int64,

    won: Bool,
    rating: Int32?,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  belongs_to :game, Game
  belongs_to :player, Player

  def won?
    !!won
  end

  def lost?
    !won
  end
end
