require "./spec_helper"
require "../../src/models/player.cr"

describe Player do
  player = create_player_with_mock_user

  describe "validations" do
    describe "user" do
      it "must exist" do
        player.user_id = 9999.to_i64
        player.valid?.should be_false
        player.errors.full_messages.join(",").should match /User must exist/
      end

      it "must be unique" do
        another_player = create_player_with_mock_user

        player.user_id = another_player.user!.id
        player.valid?.should be_false
        player.errors.full_messages.join(",").should match /User has already been taken/
      end
    end

    describe "tag" do
      it "must be between 3 and 16 characters in length" do
        player.tag = "a"
        player.valid?.should be_false
        player.errors.full_messages.join(",").should match /Tag is too short/

        player = player.reload
        player.tag = "a" * 17
        player.valid?.should be_false
        player.errors.full_messages.join(",").should match /Tag is too long/

        player = player.reload
        player.tag = "nametag"
        player.valid?.should be_true
      end
    end
  end

  describe "#rating" do
    context "when the player hasn't particpated in any games" do
      it "is the league's default rating" do
        league = create_league

        Membership.create!(
          player_id: player.id,
          league_id: league.id
        )

        player.rating_for(league).should eq league.start_rating

        new_start_rating = 1500
        league.update!(start_rating: new_start_rating)
        player.rating_for(league).should eq new_start_rating
      end
    end
  end

  pending do
    it "has specs"
  end
end
