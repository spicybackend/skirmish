class League < Granite::Base
  adapter mysql
  table_name leagues

  field name : String
  field description : String
  timestamps
end
