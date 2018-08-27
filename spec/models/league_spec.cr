require "./spec_helper"
require "../../src/models/league.cr"

def create_league!
  League.create!(
    name: "new league",
    description: "some description",
    start_rating: League::DEFAULT_START_RATING,
    k_factor: League::DEFAULT_K_FACTOR
  )
end

def build_league
  League.new.tap do |league|
    league.name = "new league"
    league.description = "some description"
    league.start_rating = League::DEFAULT_START_RATING
    league.k_factor = League::DEFAULT_K_FACTOR
  end
end

describe League do
  Spec.before_each do
    League.clear
    Player.clear
    Membership.clear
  end

  describe "validations" do
    describe "name" do
      context "a valid name" do
        it "is valid" do
          league = build_league

          league.valid?.should eq true
          league.errors.size.should eq 0
        end
      end

      context "when no name is given" do
        it "is invalid" do
          league = build_league
          league.name = nil

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Name is required/
        end
      end

      context "when the name is blank" do
        it "is invalid" do
          league = build_league
          league.name = ""

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Name is required/
        end
      end

      context "when the name is already taken" do
        it "is invalid" do
          existing_league = create_league!
          league = build_league
          league.name = existing_league.name

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Name already taken/
        end
      end
    end

    describe "description" do
      context "a valid description" do
        it "is valid" do
          league = build_league

          league.valid?.should eq true
          league.errors.size.should eq 0
        end
      end

      context "when no description is given" do
        it "is invalid" do
          league = build_league
          league.description = nil

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Description is required/
        end
      end

      context "when the description is blank" do
        it "is invalid" do
          league = build_league
          league.description = ""

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Description is required/
        end
      end
    end

    context "start rating" do
      context "when the start rating is between 100 and 3000" do
        it "is valid" do
          league = build_league

          league.valid?.should eq true
          league.errors.size.should eq 0
        end
      end

      context "when the start rating is below 100" do
        it "is invalid" do
          league = build_league
          league.start_rating = 99

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Start_rating is too low/
        end
      end

      context "when the start rating is above 3000" do
        it "is invalid" do
          league = build_league
          league.start_rating = 3001

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Start_rating is too high/
        end
      end

      context "when the start rating isn't given" do
        it "is invalid" do
          league = build_league
          league.start_rating = nil

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /Start_rating is required/
        end
      end
    end

    context "k-factor" do
      context "when the k-factor is between 1 and 100" do
        it "is valid" do
          league = build_league

          league.valid?.should eq true
          league.errors.size.should eq 0
        end
      end

      context "when the k-factor is below 1" do
        it "is invalid" do
          league = build_league
          league.k_factor = 0.0

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /K_factor is too low/
        end
      end

      context "when the k-factor is above 100" do
        it "is invalid" do
          league = build_league
          league.k_factor = 101.0

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /K_factor is too high/
        end
      end

      context "when the k-factor isn't given" do
        it "is invalid" do
          league = build_league
          league.k_factor = nil

          league.valid?.should eq false
          league.errors.map(&.to_s).join(", ").should match /K_factor is required/
        end
      end
    end
  end

  describe "#active_players" do
    context "a brand new league" do
      it "has no active players" do
        league = create_league!

        league.active_players.size.should eq 0
      end
    end

    context "when there is a player with a membership in the league" do
      it "has an active player" do
        league = create_league!
        player = create_player_with_mock_user("player_one")
        membership = Membership.create!(
          league_id: league.id,
          player_id: player.id,
          joined_at: Time.now
        )

        league.active_players.size.should eq 1
      end

      context "but the membership is expired" do
        it "has no active players" do
          league = create_league!
          player = create_player_with_mock_user("player_one")
          membership = Membership.create!(
            league_id: league.id,
            player_id: player.id,
            joined_at: Time.now,
            left_at: Time.now
          )

          league.active_players.size.should eq 0
        end
      end
    end
  end
end
