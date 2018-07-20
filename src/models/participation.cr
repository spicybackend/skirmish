class Participation < Granite::Base
  adapter mysql
  table_name participations

  belongs_to :game
  belongs_to :player

  timestamps
end
