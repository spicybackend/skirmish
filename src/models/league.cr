class League < Granite::Base
  adapter mysql
  table_name leagues

  has_many :memberships
  has_many :players, through: :memberships

  field name : String
  field description : String

  timestamps
end
