class Game < Granite::Base
  adapter mysql
  table_name games

  belongs_to :league
  has_many :participations
  has_many :players, through: :participations

  field winner_id : Int64

  def winner
    Player.find(winner_id)
  end

  timestamps
end
