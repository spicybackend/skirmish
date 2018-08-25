class Membership < Granite::Base
  adapter postgres
  table_name memberships

  belongs_to :player
  belongs_to :league

  primary id : Int64
  field joined_at : Time
  field left_at : Time

  timestamps

  def self.active
    self.all("WHERE joined_at IS NOT NULL AND left_at IS NULL")
  end

  def active?
    !joined_at.nil? && left_at.nil?
  end
end
