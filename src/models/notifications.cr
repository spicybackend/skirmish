class Notifications < Granite::Base
  adapter postgres
  table_name notifications

  belongs_to :player

  # id : Int64 primary key is created for you
  field event_type : String
  field sent_at : Time
  field read_at : Time
  field title : String
  field content : String
  timestamps
end
