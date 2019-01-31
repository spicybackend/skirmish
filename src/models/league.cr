class League < Jennifer::Model::Base
  DEFAULT_START_RATING = 1000.to_i
  DEFAULT_K_FACTOR = 32.to_f64
  RECENT_GAMES_LIMIT = 3  # TODO Move to a presenter...

  OPEN = "open"
  CLOSED = "closed"
  SECRET = "secret"

  VISIBILITY_OPTIONS = [
    OPEN,
    CLOSED,
    SECRET
  ]

  with_timestamps

  mapping(
    id: Primary64,

    name: String,
    description: String?,
    accent_color: { type: String, default: "#fd971f" },

    visibility: { type: String, default: OPEN },
    start_rating: { type: Int32, default: DEFAULT_START_RATING },
    k_factor: { type: Float64, default: DEFAULT_K_FACTOR },

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  has_many :games, Game
  has_many :memberships, Membership
  has_many :administrators, Administrator
  has_many :tournaments, Tournament
  has_many :invites, Invitation

  has_and_belongs_to_many :players, Player, nil, nil, nil, "memberships", "player_id"

  validates_presence :name
  validates_uniqueness :name

  validates_inclusion :visibility, in: VISIBILITY_OPTIONS

  validates_presence :description
  validates_presence :accent_color
  validates_presence :start_rating
  validates_presence :k_factor

  validates_numericality :start_rating, greater_than_or_equal_to: 100, less_than_or_equal_to: 3000
  # TODO: Re-enable once Jennifer Numericality is fixed. Float64#even? and #odd? removed in 0.27.0.
  # validates_numericality :k_factor, greater_than_or_equal_to: 1, less_than_or_equal_to: 100
  validates_format :accent_color, /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/

  scope :open { where { _visibility == OPEN } }
  scope :closed { where { _visibility == CLOSED } }
  scope :secret { where { _visibility == SECRET } }
  scope :publicly_visible { where { _visibility != SECRET } }

  def active_players_query
    players_query.where { Membership._left_at == nil }
  end

  def active_players
    active_players_query.to_a
  end

  def recent_games
    games_query.order(created_at: :desc).limit(RECENT_GAMES_LIMIT)
  end

  def active_memberships_query
    memberships_query.where { Membership._left_at == nil }
  end

  def open?
    visibility == OPEN
  end

  def closed?
    visibility == CLOSED
  end

  def secret?
    visibility == SECRET
  end

  def self.visible_to(player : Player)
    League.all
      .left_join(Membership) { League._id == _league_id }
      .left_join(Invitation) { League._id == _league_id }
      .where { (Membership._left_at == nil) }
      .where { (_visibility != League::SECRET) | (Invitation._player_id == player.id) | (Membership._player_id == player.id) }
      .group("leagues.id")
  end
end
