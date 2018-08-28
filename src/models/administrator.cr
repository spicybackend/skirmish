class Administrator < Granite::Base
  adapter postgres
  table_name administrators

  belongs_to :user
  belongs_to :league

  timestamps
end
