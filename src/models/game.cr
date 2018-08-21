class Game < Granite::Base
  adapter mysql
  table_name games

  belongs_to :league
  has_many :participations
  has_many :players, through: :participations

  field logged_by_id : Int64
  field confirmed_by_id : Int64
  field confirmed_at : Time

  timestamps

  def winner
    players.all("AND participations.won = 1 LIMIT 1").first
  end

  def loser
    players.all("AND participations.won = 0 LIMIT 1").first
  end

  def confirmed?
    !!confirmed_at
  end

  def logged_by
    Player.find(logged_by_id)
  end

  def confirmed?
    !!confirmed_at
  end

  def confirmed_by
    Player.find(confirmed_by_id)
  end
end
