class Membership < Granite::Base
  adapter mysql
  table_name memberships

  belongs_to :player
  belongs_to :league

  timestamps
end
