class Player < Granite::Base
  RECENT_GAMES_LIMIT = 3

  adapter mysql
  table_name players

  belongs_to :user
  has_many :memberships
  has_many :leagues, through: :memberships
  has_many :participations
  has_many :games, through: :participations

  timestamps

  def ==(other)
    !other.nil? && self.class == other.class && self.id == other.id
  end

  def tag
    user.username
  end

  def in_league?(league : League)
    !!Membership.find_by(
      player_id: id,
      league_id: league.id
    ).try(&.active?)
  end

  def rating_for(league : League)
    latest_participation = Participation.first(
      "JOIN games on participations.game_id = games.id
      WHERE participations.player_id =?
      AND games.league_id = ?
      ORDER BY participations.created_at DESC",
      [id, league.id]
    )

    latest_participation.try(&.rating) || league.start_rating || League::DEFAULT_START_RATING
  end

  def recent_games
    # TODO add and use confirmed_at
    games.all("ORDER BY created_at DESC LIMIT ?", [RECENT_GAMES_LIMIT])
  end
end
