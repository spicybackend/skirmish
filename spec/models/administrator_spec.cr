require "./spec_helper"
require "../../src/models/administrator.cr"

describe Administrator do
  player = create_player_with_mock_user
  league = create_league

  describe "validations" do
    context "player" do
      context "a valid player" do
        it "is valid" do
          admin = Administrator.build(player_id: player.id, league_id: league.id)

          admin.valid?.should be_true
          admin.errors.size.should eq 0
        end
      end

      context "when no player is given" do
        it "is invalid" do
          admin = Administrator.build(player_id: nil, league_id: league.id)

          admin.valid?.should be_false
          admin.errors.full_messages.join(", ").should match /Player can't be blank/
        end
      end

      context "when the player doesn't exist" do
        it "is invalid" do
          admin = Administrator.build(player_id: 9999.to_i64, league_id: league.id)

          admin.valid?.should be_false
          admin.errors.full_messages.join(", ").should match /Player must exist/
        end
      end
    end

    context "league" do
      context "a valid league" do
        it "is valid" do
          admin = Administrator.build(player_id: player.id, league_id: league.id)

          admin.valid?.should be_true
          admin.errors.size.should eq 0
        end
      end

      context "when no league is given" do
        it "is invalid" do
          admin = Administrator.build(player_id: player.id, league_id: nil)

          admin.valid?.should be_false
          admin.errors.full_messages.join(", ").should match /League can't be blank/
        end
      end

      context "when the league doesn't exist" do
        it "is invalid" do
          admin = Administrator.build(player_id: player.id, league_id: 9999.to_i64)

          admin.valid?.should be_false
          admin.errors.full_messages.join(", ").should match /League must exist/
        end
      end
    end
  end
end
