class League < Granite::Base
  DEFAULT_START_RATING = 1000.to_i
  DEFAULT_K_FACTOR = 32.to_f64

  adapter mysql
  table_name leagues

  has_many :games
  has_many :memberships
  has_many :players, through: :memberships

  field name : String
  field description : String
  field start_rating : Int32, comment: "# The inital rating for a new player"
  field k_factor : Float64

  timestamps

  def active_players
    Player.all("JOIN memberships WHERE players.id = memberships.player_id
      AND league_id = ?
      AND left_at IS NULL", id)
  end
end
