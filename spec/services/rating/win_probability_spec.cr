require "../spec_helper"

describe Rating::WinProbability do
  rating = 1000
  other_rating = 1000

  determine_win_probability = -> do
    Rating::WinProbability.new(
      rating: rating,
      other_rating: other_rating
    ).call
  end

  describe "probability" do
    context "when the ratings are equal" do
      it "is 0.5" do
        determine_win_probability.call.should eq 0.5
      end
    end

    context "when the other rating is lower" do
      other_rating = rating - 100

      it "is greater than 0.5" do
        determine_win_probability.call.should be > 0.5
      end
    end

    context "when the other rating is higher" do
      other_rating = rating + 100

      it "is less than 0.5" do
        determine_win_probability.call.should be < 0.5
      end
    end
  end
end
