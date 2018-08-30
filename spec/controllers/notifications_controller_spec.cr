require "./spec_helper"

def notifications_hash
  {"player_id" => "1", "event_type" => "Fake", "sent_at" => "2018-08-30 17:02:27 +12:00", "read_at" => "2018-08-30 17:02:27 +12:00", "title" => "Fake", "content" => "Fake"}
end

def notifications_params
  params = [] of String
  params << "player_id=#{notifications_hash["player_id"]}"
  params << "event_type=#{notifications_hash["event_type"]}"
  params << "sent_at=#{notifications_hash["sent_at"]}"
  params << "read_at=#{notifications_hash["read_at"]}"
  params << "title=#{notifications_hash["title"]}"
  params << "content=#{notifications_hash["content"]}"
  params.join("&")
end

def create_notifications
  model = Notifications.new(notifications_hash)
  model.save
  model
end

class NotificationsControllerTest < GarnetSpec::Controller::Test
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

describe NotificationsControllerTest do
  subject = NotificationsControllerTest.new

  it "renders notifications index template" do
    Notifications.clear
    response = subject.get "/notifications"

    response.status_code.should eq(200)
    response.body.should contain("notifications")
  end

  it "renders notifications show template" do
    Notifications.clear
    model = create_notifications
    location = "/notifications/#{model.id}"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Show Notifications")
  end

  it "renders notifications new template" do
    Notifications.clear
    location = "/notifications/new"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("New Notifications")
  end

  it "renders notifications edit template" do
    Notifications.clear
    model = create_notifications
    location = "/notifications/#{model.id}/edit"

    response = subject.get location

    response.status_code.should eq(200)
    response.body.should contain("Edit Notifications")
  end

  it "creates a notifications" do
    Notifications.clear
    response = subject.post "/notifications", body: notifications_params

    response.headers["Location"].should eq "/notifications"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "updates a notifications" do
    Notifications.clear
    model = create_notifications
    response = subject.patch "/notifications/#{model.id}", body: notifications_params

    response.headers["Location"].should eq "/notifications"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  it "deletes a notifications" do
    Notifications.clear
    model = create_notifications
    response = subject.delete "/notifications/#{model.id}"

    response.headers["Location"].should eq "/notifications"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end
end
