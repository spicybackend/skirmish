class Administrator < Granite::Base
  adapter mysql
  table_name administrators

  belongs_to :user

  timestamps
end
