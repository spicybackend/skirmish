class Player < Granite::Base
  adapter mysql
  table_name players

  belongs_to :user
  has_many :memberships
  has_many :leagues, through: :memberships

  timestamps
end
