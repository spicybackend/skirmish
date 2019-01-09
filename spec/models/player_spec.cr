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

      it "must only letters, numbers, or symbols" do
        player.tag = "a a a 1 2 3"
        player.valid?.should be_false
        player.errors.full_messages.join(",").should match /Tag must start with a letter and can only include letters, numbers, or symbols/

        player = player.reload
        player.tag = "_sexgod_"
        player.valid?.should be_false
        player.errors.full_messages.join(",").should match /Tag must start with a letter and can only include letters, numbers, or symbols/

        player = player.reload
        player.tag = "N-4_.n._D-4"
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

  describe "#member_of?" do
    context "when the player has a membership in the league" do
      context "that is active" do
        it "is true" do
          league = create_league

          Membership.create!(
            player_id: player.id,
            league_id: league.id
          )

          player.member_of?(league).should be_true
        end
      end

      context "that has ended" do
        it "is false" do
          league = create_league

          Membership.create!(
            player_id: player.id,
            league_id: league.id,
            left_at: Time.now
          )

          player.member_of?(league).should be_false
        end
      end
    end

    context "when the player has no membership in the league" do
      it "is false" do
        league = create_league

        player.member_of?(league).should be_false
      end
    end
  end

  pending do
    it "has specs"
  end
end
