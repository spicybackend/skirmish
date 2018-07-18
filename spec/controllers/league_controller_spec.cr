require "./spec_helper"

def league_hash
  {"name" => "Fake", "description" => "Fake"}
end

def league_params
  params = [] of String
  params << "name=#{league_hash["name"]}"
  params << "description=#{league_hash["description"]}"
  params.join("&")
end

def create_league
  model = League.new(league_hash)
  model.save
  model
end

class LeagueControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new
    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
    end
    @handler.prepare_pipelines
  end
end

describe LeagueControllerTest do
  subject = LeagueControllerTest.new

  it "renders league index template" do
    League.clear
    response = subject.get "/leagues"

    response.status_code.should eq(200)
    response.body.should contain("leagues")
  end

  it "renders league show template" do
    League.clear
    model = create_league
    location = "/leagues/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show League")
  end

  it "renders league new template" do
    League.clear
    location = "/leagues/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New League")
  end

  it "renders league edit template" do
    League.clear
    model = create_league
    location = "/leagues/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit League")
  end

  it "creates a league" do
    League.clear
    response = subject.post "/leagues", body: league_params

    response.headers["Location"].should eq "/leagues"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a league" do
    League.clear
    model = create_league
    response = subject.patch "/leagues/#{model.id}", body: league_params

    response.headers["Location"].should eq "/leagues"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a league" do
    League.clear
    model = create_league
    response = subject.delete "/leagues/#{model.id}"

    response.headers["Location"].should eq "/leagues"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
