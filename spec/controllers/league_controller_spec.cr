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
  params << "name=new_league"
  params << "description=some_description"
  params << "start_rating=#{League::DEFAULT_START_RATING}"
  params << "k_factor=#{League::DEFAULT_K_FACTOR}"
  params.join("&")
end

def create_league
  League.create!(league_hash)
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
      league = create_league
      response = subject.get "/leagues/#{league.id}"

      response.status_code.should eq(200)
      response.body.should contain("League")
    end

    context "when the league doesn't exist" do
      it "redirects back to the leagues listing" do
        response = subject.get "/leagues/99999"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/leagues"
      end
    end
  end

  describe "#new" do
    context "when logged in" do
      it "renders the new league template" do
        response = subject.get "/leagues/new", headers: admin_authenticated_headers

        response.status_code.should eq(200)
        response.body.should contain("New League")
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        response = subject.get "/leagues/new"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end
  end

  describe "#edit" do
    context "when logged in" do
      it "renders the new league template" do
        league = create_league
        response = subject.get "/leagues/#{league.id}/edit", headers: admin_authenticated_headers

        response.status_code.should eq(200)
        response.body.should contain("Edit League")
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        league = create_league
        response = subject.get "/leagues/#{league.id}/edit"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end
  end

  describe "#create" do
    context "when logged in" do
      it "creates a league" do
        response = subject.post "/leagues", headers: admin_authenticated_headers, body: league_params

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/leagues"
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        response = subject.get "/leagues/new"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end
  end

  describe "#update" do
    context "when logged in" do
      it "updates a league" do
        league = create_league
        response = subject.patch "/leagues/#{league.id}", headers: admin_authenticated_headers, body: league_params

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/leagues"
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        response = subject.get "/leagues/new"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end
  end

  describe "#delete" do
    context "when logged in" do
      league = create_league

      it "deletes the league" do
        response = subject.delete "/leagues/#{league.id}", headers: admin_authenticated_headers

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/leagues"
      end

      context "when a game has been played" do
        game = Game.new(
          league_id: league.id
        )
        game.save
        game_id = game.id

        it "deletes the game as well" do
          subject.delete "/leagues/#{league.id}", headers: admin_authenticated_headers

          Game.find(game_id).should eq nil
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        response = subject.get "/leagues/new"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end
  end
end
