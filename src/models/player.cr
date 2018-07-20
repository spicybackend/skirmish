class Player < Granite::Base
  adapter mysql
  table_name players

  belongs_to :user
  has_many :memberships
  has_many :leagues, through: :memberships

  timestamps

  def in_league?(league : League)
    !!Membership.find_by(
      player_id: id,
      league_id: league.id
    ).try(&.active?)
  end
end
