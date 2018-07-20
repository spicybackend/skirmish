class League < Granite::Base
  adapter mysql
  table_name leagues

  has_many :memberships
  has_many :players, through: :memberships

  field name : String
  field description : String

  timestamps

  def active_players
    Player.all("JOIN memberships WHERE players.id = memberships.player_id
      AND league_id = ?
      AND left_at IS NULL", id)
  end
end
