require "./spec_helper"
require "../../src/models/administrator.cr"

def build_admin
  player = create_player_with_mock_user
  league = create_league

  Administrator.build.tap do |admin|
    admin.player_id = player.id.not_nil!
    admin.league_id = league.id.not_nil!
  end
end

describe Administrator do
  Spec.before_each do
    Administrator.all.destroy
  end

  describe "validations" do
    context "player" do
      context "a valid player" do
        it "is valid" do
          admin = build_admin

          admin.valid?.should eq true
          admin.errors.size.should eq 0
        end
      end

      context "when no player is given" do
        it "is invalid" do
          admin = build_admin
          admin.update_attributes(player_id: nil)

          admin.valid?.should eq false
          admin.errors.full_messages.join(", ").should match /Player is required/
        end
      end

      context "when the player doesn't exist" do
        it "is invalid" do
          admin = build_admin
          admin.player_id = 9999

          admin.valid?.should eq false
          admin.errors.full_messages.join(", ").should match /Player is required/
        end
      end
    end

    context "league" do
      context "a valid league" do
        it "is valid" do
          admin = build_admin

          admin.valid?.should eq true
          admin.errors.size.should eq 0
        end
      end

      context "when no league is given" do
        it "is invalid" do
          admin = build_admin
          admin.update_attributes(league_id: nil)

          admin.valid?.should eq false
          admin.errors.full_messages.join(", ").should match /League is required/
        end
      end

      context "when the league doesn't exist" do
        it "is invalid" do
          admin = build_admin
          admin.update_attributes(league_id: 9999)

          admin.valid?.should eq false
          admin.errors.full_messages.join(", ").should match /League is required/
        end
      end
    end
  end
end
