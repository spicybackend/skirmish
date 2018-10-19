require "./spec_helper"
require "../../src/models/user.cr"

describe User do
  describe "#activated?" do
    context "when the user has not yet been activated" do
      it "is false" do
        user = create_player_with_mock_user.user!

        user.activated?.should eq false
      end
    end

    context "when the user has been activated" do
      it "is true" do
        user = create_player_with_mock_user.user!
        user.activated_at = Time.now

        user.activated?.should eq true
      end
    end
  end

  pending do
    it "has specs"
  end
end
