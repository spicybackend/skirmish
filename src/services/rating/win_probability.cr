class Rating::WinProbability
  getter :rating, :other_rating

  def initialize(@rating : Int32, @other_rating : Int32)
  end

  def call
    expected_score
  end

  def as_percentage
    expected_score * 100
  end

  private def expected_score
    # The expected score is the probably outcome of the match, depending
    # on the difference in rating between the two players.
    1.0 / ( 1.0 + ( 10.0 ** ((other_rating - rating) / 400.0) ) )
  end
end
