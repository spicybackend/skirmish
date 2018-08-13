class Game < Granite::Base
  adapter mysql
  table_name games

  belongs_to :league
  has_many :participations
  has_many :players, through: :participations

  field winner_id : Int64
  field logged_by_id : Int64
  field confirmed_by_id : Int64
  field confirmed_at : Time

  timestamps

  def winner
    Player.find(winner_id)
  end

  def losers
    players.all("AND players.id != ?", [winner_id])
  end

  def loser
    losers.first
  end

  def confirmed?
    !!confirmed_at
  end

  def logged_by
    Player.find(logged_by_id)
  end

  def confirmed_by
    Player.find(confirmed_by_id)
  end
end
