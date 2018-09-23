require "./spec_helper"

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

  Spec.before_each do
    League.all.destroy
    Administrator.all.destroy
    Player.all.destroy
    User.all.destroy
  end

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
        response = subject.get "/leagues/new", headers: basic_authenticated_headers

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
        response = subject.get "/leagues/#{league.id}/edit", headers: admin_authenticated_headers(league)

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
    league_props = {
      name: "new league",
      description: "some description",
      start_rating: League::DEFAULT_START_RATING,
      k_factor: League::DEFAULT_K_FACTOR
    }.to_h

    body = params_from_hash(league_props)

    context "when logged in" do
      it "creates a league" do
        leagues_before = League.count
        subject.post "/leagues", headers: basic_authenticated_headers, body: body

        League.count.should eq(leagues_before + 1)
      end

      it "creates an administrator" do
        administrators_before = League.count
        subject.post "/leagues", headers: basic_authenticated_headers, body: body

        Administrator.count.should eq(administrators_before + 1)
      end

      it "redirects to the new league" do
        response = subject.post "/leagues", headers: basic_authenticated_headers, body: body

        league = League.all.last

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/leagues/#{league.id}"
      end

      describe "the created league" do
        it "has the properties specified in the params" do
          subject.post "/leagues", headers: basic_authenticated_headers, body: body

          league = League.all.last

          league.name.should eq league_props[:name]
          league.description.should eq league_props[:description]
          league.start_rating.should eq league_props[:start_rating]
          league.k_factor.should eq league_props[:k_factor]
        end
      end

      describe "the created admin role" do
        it "is granted to the logged in player and created league" do
          player = create_player_with_mock_user
          subject.post "/leagues", headers: authenticated_headers_for(player.user.not_nil!), body: body

          admin = Administrator.all.last
          league = League.all.last

          admin.player.id.should eq player.id
          admin.league.id.should eq league.id
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        response = subject.post "/leagues", body: body

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end
  end

  describe "#update" do
    league_props = {
      name: "new league",
      description: "some description",
      start_rating: League::DEFAULT_START_RATING,
      k_factor: League::DEFAULT_K_FACTOR
    }.to_h

    body = params_from_hash(league_props)

    context "when logged in" do
      it "redirects to the league" do
        league = create_league
        response = subject.patch "/leagues/#{league.id}", headers: admin_authenticated_headers(league), body: body

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/leagues/#{league.id}"
      end

      describe "the updated league" do
        it "has the properties specified in the params" do
          league = create_league
          subject.patch "/leagues/#{league.id}", headers: admin_authenticated_headers(league), body: body

          # reload the league
          league = League.find!(league.id)

          league.name.should eq league_props[:name]
          league.description.should eq league_props[:description]
          league.start_rating.should eq league_props[:start_rating]
          league.k_factor.should eq league_props[:k_factor]
        end
      end
    end

    context "when logged out" do
      it "redirects to the login page" do
        league = create_league
        response = subject.patch "/leagues/#{league.id}", body: body

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end
  end

  describe "#delete" do
    context "when logged in" do
      it "deletes the league" do
        league = create_league
        response = subject.delete "/leagues/#{league.id}", headers: admin_authenticated_headers(league)

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/leagues"
      end

      context "when a game has been played" do
        it "deletes the game as well" do
          league = create_league

          game = Game.new(
            league_id: league.id
          )
          game.save
          game_id = game.id

          subject.delete "/leagues/#{league.id}", headers: admin_authenticated_headers(league)

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
