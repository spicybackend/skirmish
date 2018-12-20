class Rating::DetermineDelta
  # For more information visit
  # {Wikipedia}[http://en.wikipedia.org/wiki/Elo_rating_system#Mathematical_details]

  FALLBACK_K_FACTOR = 32.to_f64

  getter :winner_rating, :loser_rating, :league

  def initialize(@winner_rating : Int32, @loser_rating : Int32, @league : League)
  end

  def call
    delta.to_i
  end

  # The expected score is the probably outcome of the match, depending
  # on the difference in rating between the two players.
  private def expected_score
    Rating::WinProbability.new(loser_rating, winner_rating).call
  end

  private def k_factor
    league.try(&.k_factor) || FALLBACK_K_FACTOR
  end

  private def delta
    k_factor * expected_score
  end
end
