class Participation < Granite::Base
  adapter mysql
  table_name participations

  belongs_to :game
  belongs_to :player

  field won : Bool, comment: "# Whether or not the player won the game"
  field rating : Int32, comment: "# The resulting rating of the player after the game"

  timestamps

  def won?
    !!won
  end
end
