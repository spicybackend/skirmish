require "../spec_helper"

describe Rating::DetermineDelta do
  winner_rating = 1000
  loser_rating = 1000

  league = create_league

  determine_delta = -> do
    Rating::DetermineDelta.new(
      winner_rating: winner_rating,
      loser_rating: loser_rating,
      league: league
    ).call
  end

  describe "the delta" do
    it "is positive" do
      determine_delta.call.should be > 0.0
    end
  end

  describe "k factor effect" do
    altered_k_factor_league = create_league

    determine_altered_delta = -> do
      Rating::DetermineDelta.new(
        winner_rating: winner_rating,
        loser_rating: loser_rating,
        league: altered_k_factor_league
      ).call
    end

    context "for a league with a higher k factor" do
      altered_k_factor_league.k_factor = League::DEFAULT_K_FACTOR * 2

      it "alters scores more harshly" do
        base_delta = determine_delta.call
        altered_delta = determine_altered_delta.call

        altered_delta.should be > base_delta
      end
    end

    context "for a league with a lower k factor" do
      altered_k_factor_league.k_factor = League::DEFAULT_K_FACTOR / 2

      it "alters scores more harshly" do
        base_delta = determine_delta.call
        altered_delta = determine_altered_delta.call

        altered_delta.should be < base_delta
      end
    end
  end
end
