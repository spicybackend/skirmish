require "../spec_helper"

describe Rating::DetermineNewRating do
  old_rating = 1000
  other_rating = 1000
  won = true
  league = League.new

  determine_new_rating = -> do
    Rating::DetermineNewRating.new(
      old_rating: old_rating,
      other_rating: other_rating,
      won: won,
      league: league
    ).call
  end

  describe "the new rating" do
    context "when the player wins a game" do
      it "is higher than the old rating" do
        determine_new_rating.call.should be > old_rating
      end
    end

    context "when the player loses a game" do
      won = false

      it "is lower than the old rating" do
        determine_new_rating.call.should be < old_rating
      end
    end

    describe "k factor effect" do
      altered_k_factor_league = League.new

      determine_altered_rating = -> do
        Rating::DetermineNewRating.new(
          old_rating: old_rating,
          other_rating: other_rating,
          won: won,
          league: altered_k_factor_league
        ).call
      end

      context "for a league with a higher k factor" do
        altered_k_factor_league.k_factor = League::DEFAULT_K_FACTOR * 2

        it "alters scores more harshly" do
          base_rating_change = (determine_new_rating.call - old_rating).abs
          altered_rating_change = (determine_altered_rating.call - old_rating).abs

          altered_rating_change.should be > base_rating_change
        end
      end

      context "for a league with a lower k factor" do
        altered_k_factor_league.k_factor = League::DEFAULT_K_FACTOR / 2

        it "alters scores more harshly" do
          base_rating_change = (determine_new_rating.call - old_rating).abs
          altered_rating_change = (determine_altered_rating.call - old_rating).abs

          altered_rating_change.should be < base_rating_change
        end
      end
    end
  end
end
