class Player < Granite::Base
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
end
