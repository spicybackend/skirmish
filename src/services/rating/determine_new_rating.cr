class Rating::DetermineNewRating
  # For more information visit
  # {Wikipedia}[http://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details]

  FALLBACK_K_FACTOR = 32.to_f64

  getter :old_rating, :other_rating, :won, :league

  def initialize(@old_rating : Int32, @other_rating : Int32, @won : Bool, @league : League)
  end

  def call
    new_rating
  end

  private def new_rating
    (old_rating + change).to_i
  end

  private def result_mark
    won ? 1.0 : 0.0
  end

  # The expected score is the probably outcome of the match, depending
  # on the difference in rating between the two players.
  private def expected_score
    Rating::WinProbability.new(old_rating, other_rating).call
  end

  private def k_factor
    league.try(&.k_factor) || FALLBACK_K_FACTOR
  end

  # The change is the points you earn or lose.
  private def change
    k_factor * (result_mark - expected_score)
  end
end
