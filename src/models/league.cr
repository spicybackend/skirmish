class League < Jennifer::Model::Base
  DEFAULT_START_RATING = 1000.to_i
  DEFAULT_K_FACTOR = 32.to_f64
  RECENT_GAMES_LIMIT = 3  # TODO Move to a presenter...

  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    name: String,
    description: String?,
    start_rating: { type: Int32, default: DEFAULT_START_RATING },
    k_factor: { type: Float64, default: DEFAULT_K_FACTOR },

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  has_many :games, Game
  has_many :memberships, Membership
  has_many :administrators, Administrator

  has_and_belongs_to_many :players, Player, nil, nil, nil, "memberships", "player_id"

  # validate :name, "is required", ->(league : League) do
  #   (name = league.name) ? !name.empty? : false
  # end

  # validate :name, "already taken", ->(league : League) do
  #   existing = League.find_by(name: league.name)
  #   !existing || existing.id == league.id
  # end

  # validate :description, "is required", ->(league : League) do
  #   (description = league.description) ? !description.empty? : false
  # end

  # validate :start_rating, "is required", ->(league : League) do
  #   !!league.start_rating
  # end

  # validate :start_rating, "is too low", ->(league : League) do
  #   (rating = league.start_rating) ? rating > 100 : true
  # end

  # validate :start_rating, "is too high", ->(league : League) do
  #   (rating = league.start_rating) ? rating < 3000 : true
  # end

  # validate :k_factor, "is required", ->(league : League) do
  #   !!league.k_factor
  # end

  # validate :k_factor, "is too low", ->(league : League) do
  #   (rating = league.k_factor) ? rating > 1 : true
  # end

  # validate :k_factor, "is too high", ->(league : League) do
  #   (rating = league.k_factor) ? rating < 100 : true
  # end

  def active_players
    players  # FIXME: where left_at is nil
  end

  def recent_games
    games_query.order(confirmed_at: :desc, created_at: :desc).limit(RECENT_GAMES_LIMIT)
  end
end
