require "./spec_helper"
require "../../src/models/player.cr"

describe Player do
  Spec.before_each do
    Player.clear
    User.clear
  end

  describe "validations" do
    describe "user" do
      it "must be a associated to an existing user" do
        player = create_player_with_mock_user

        player.user_id = nil
        player.valid?.should eq false

        player.errors.clear
        player.user_id = User.first.not_nil!.id
        player.valid?.should eq true
      end
    end

    describe "tag" do
      it "must be present" do
        player = create_player_with_mock_user

        player.tag = nil
        player.valid?.should eq false

        player.errors.clear
        player.tag = ""
        player.valid?.should eq false

        player.errors.clear
        player.tag = "Some tag"
        player.valid?.should eq true
      end
    end
  end
end
