class Player < Jennifer::Model::Base
  RECENT_GAMES_LIMIT = 3

  with_timestamps

  mapping(
    id: { type: Int64, primary: true },
    user_id: Int64?,

    tag: String,

    created_at: { type: Time, default: Time.now },
    updated_at: { type: Time, default: Time.now }
  )

  belongs_to :user, User

  has_many :memberships, Membership
  has_many :participations, Participation
  has_many :administrators, Administrator

  has_and_belongs_to_many :leagues, League, nil, nil, nil, "memberships", "league_id"
  has_and_belongs_to_many :games, Game, nil, nil, nil, "participations", "game_id"

  # validate :tag, "already in use", ->(player : Player) do
  #   existing = Player.find_by tag: player.tag
  #   !existing || existing.id == player.id
  # end

  def ==(other)
    !other.nil? && self.class == other.class && self.id == other.id
  end

  def admin_of?(league : League)
    true
    # administrators_query.where { _league_id == league.id }.exists?
  end

  def in_league?(league : League)
    # TODO Do this by lookup in db
    memberships_query.where { _league_id == league.id }.to_a.any? { |membership| membership.active? }
  end

  def rating_for(league : League)
    # latest_participation = Participation.all.join(Game) { Participation._game_id == _id }.where do
    #   (_player_id == id) & (Game._league_id == league.id)
    # end.order(created_at: :desc).to_a.reject { |participation| participation.rating.nil? }.first?

    latest_participation = participations_query.
      join(Game) { Participation._game_id == _id }.
      where { Game._league_id == league.id }.
      order(created_at: :desc).
      to_a.reject { |participation| participation.rating.nil? }.first?

    # latest_participation = Participation.first(
    #   "JOIN games ON participations.game_id = games.id
    #   WHERE participations.player_id = ?
    #   AND games.league_id = ?
    #   AND participations.rating IS NOT NULL
    #   ORDER BY participations.created_at DESC",
    #   [id, league.id]
    # )

    latest_participation.try(&.rating) || league.start_rating || League::DEFAULT_START_RATING
  end

  def recent_games
    games_query.order(confirmed_at: :desc, created_at: :desc).limit(RECENT_GAMES_LIMIT).to_a
  end
end
