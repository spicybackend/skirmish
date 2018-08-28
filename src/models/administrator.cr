class Administrator < Granite::Base
  adapter postgres
  table_name administrators

  belongs_to :user
  belongs_to :player
  belongs_to :league

  timestamps

  validate :player, "is required", ->(admin : Administrator) do
    (player = Player.find(admin.player_id)) ? !player.nil? : false
  end

  validate :league, "is required", ->(admin : Administrator) do
    (league = League.find(admin.league_id)) ? !league.nil? : false
  end
end
