class League < Granite::Base
  DEFAULT_START_RATING = 1000.to_i
  DEFAULT_K_FACTOR = 32.to_f64

  RECENT_GAMES_LIMIT = 3

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

  validate :name, "is required", ->(league : League) do
    (name = league.name) ? !name.empty? : false
  end

  validate :name, "already taken", ->(league : League) do
    existing = League.find_by(name: league.name)
    !existing || existing.id == league.id
  end

  validate :description, "is required", ->(league : League) do
    (description = league.description) ? !description.empty? : false
  end

  validate :start_rating, "is required", ->(league : League) do
    !!league.start_rating
  end

  validate :start_rating, "is too low", ->(league : League) do
    (rating = league.start_rating) ? rating > 100 : true
  end

  validate :start_rating, "is too high", ->(league : League) do
    (rating = league.start_rating) ? rating < 3000 : true
  end

  validate :k_factor, "is required", ->(league : League) do
    !!league.k_factor
  end

  validate :k_factor, "is too low", ->(league : League) do
    (rating = league.k_factor) ? rating > 1 : true
  end

  validate :k_factor, "is too high", ->(league : League) do
    (rating = league.k_factor) ? rating < 100 : true
  end

  def active_players
    Player.all("JOIN memberships WHERE players.id = memberships.player_id
      AND league_id = ?
      AND left_at IS NULL", id)
  end

  def recent_games
    # TODO add and use confirmed_at
    games.all("ORDER BY created_at DESC LIMIT ?", [RECENT_GAMES_LIMIT])
  end
end
