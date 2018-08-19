require "./spec_helper"

def league_hash
  {
    name: "Fake",
    description: "Fake",
    start_rating: League::DEFAULT_START_RATING,
    k_factor: League::DEFAULT_K_FACTOR
  }.to_h
end

def league_params
  params = [] of String
  params << "name=#{league_hash[:name]}"
  params << "description=#{league_hash[:description]}"
  params.join("&")
end

def create_league
  League.create!(league_hash)
end

# TODO split out user and auth into more helpers
def fake_auth_headers_for(user)
  headers = HTTP::Headers.new
  headers.add("fake_id", user.try(&.id).to_s)
end

class LeagueControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new

    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
      plug FakeId.new
      plug Authenticate.new
    end

    @handler.prepare_pipelines
  end
end

describe LeagueControllerTest do
  subject = LeagueControllerTest.new

  describe "#index" do
    context "with no leagues exist" do
      it "renders league index template" do
        response = subject.get "/leagues"

        response.status_code.should eq(200)
        response.body.should contain("leagues")
      end
    end

    context "when a league exists" do
      it "renders league index template" do
        response = subject.get "/leagues"

        response.status_code.should eq(200)
        response.body.should contain("leagues")
      end
    end
  end

  describe "#show" do
    it "renders league show template" do
      model = create_league
      location = "/leagues/#{model.id}"

      response = subject.get location

      response.status_code.should eq(200)
      response.body.should contain("League")
    end

    context "when the league doesn't exist" do
      it "redirects back to the leagues listing" do
        response = subject.get "/leagues/99999"

        response.headers["Location"].should eq "/leagues"
        response.status_code.should eq(302)
      end
    end
  end

  describe "#new" do
    context "when logged in" do
      user = User.first
      headers = fake_auth_headers_for(user)

      it "renders the new league template" do
        location = "/leagues/new"

        response = subject.get location, headers: headers

        response.status_code.should eq(200)
        response.body.should contain("New League")
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        location = "/leagues/new"

        response = subject.get location

        response.headers["Location"].should eq "/signin"
        response.status_code.should eq(302)
      end
    end
  end

  describe "#edit" do
    model = create_league
    location = "/leagues/#{model.id}/edit"

    context "when logged in" do
      user = User.first
      headers = fake_auth_headers_for(user)

      it "renders the new league template" do
        response = subject.get location, headers: headers

        response.status_code.should eq(200)
        response.body.should contain("Edit League")
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        response = subject.get location

        response.headers["Location"].should eq "/signin"
        response.status_code.should eq(302)
      end
    end
  end

  describe "#create" do
    context "when logged in" do
      user = User.first
      headers = fake_auth_headers_for(user)

      it "creates a league" do
        response = subject.post "/leagues", headers: headers, body: league_params

        response.headers["Location"].should eq "/leagues"
        response.status_code.should eq(302)
        response.body.should eq "302"
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        location = "/leagues/new"

        response = subject.get location

        response.headers["Location"].should eq "/signin"
        response.status_code.should eq(302)
      end
    end
  end

  describe "#update" do
    context "when logged in" do
      user = User.first
      headers = fake_auth_headers_for(user)

      it "updates a league" do
        model = create_league
        response = subject.patch "/leagues/#{model.id}", headers: headers, body: league_params

        response.headers["Location"].should eq "/leagues"
        response.status_code.should eq(302)
        response.body.should eq "302"
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        location = "/leagues/new"

        response = subject.get location

        response.headers["Location"].should eq "/signin"
        response.status_code.should eq(302)
      end
    end
  end

  describe "#delete" do
    context "when logged in" do
      user = User.first
      headers = fake_auth_headers_for(user)
      league = create_league

      it "deletes the league" do
        response = subject.delete "/leagues/#{league.id}", headers: headers

        response.headers["Location"].should eq "/leagues"
        response.status_code.should eq(302)
        response.body.should eq "302"
      end

      context "when a game has been played" do
        game = Game.new(
          league_id: league.id
        )
        game.save
        game_id = game.id

        it "deletes the game as well" do
          subject.delete "/leagues/#{league.id}", headers: headers

          Game.find(game_id).should eq nil
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        location = "/leagues/new"

        response = subject.get location

        response.headers["Location"].should eq "/signin"
        response.status_code.should eq(302)
      end
    end
  end
end
