require "./spec_helper"

class NotificationControllerTest < GarnetSpec::Controller::Test
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

describe NotificationControllerTest do
  subject = NotificationControllerTest.new

  Spec.before_each do
    Notification.clear
  end

  it "renders notifications index template" do
    response = subject.get "/notifications", headers: basic_authenticated_headers

    response.status_code.should eq(200)
    response.body.should contain("notifications")
  end

  pending "redirects to the notification source" do
    player = create_player_with_mock_user
    user = player.user.not_nil!
    notification = create_notification(player: player)

    response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

    response.status_code.should eq(302)
    # TODO check location redirects as appropriate to notification type
  end

  it "reads a notifications" do
    player = create_player_with_mock_user
    user = player.user.not_nil!
    notification = create_notification(player: player)
    notification.read?.should eq false

    response = subject.patch "/notifications/#{notification.id}/read", headers: authenticated_headers_for(user)

    response.headers["Location"].should eq "/notifications"
    response.status_code.should eq(302)
    response.body.should eq "302"

    notification = Notification.find(notification.id).not_nil!
    notification.read?.should eq true
  end

  it "reads all notifications" do
    player = create_player_with_mock_user
    user = player.user.not_nil!
    notification = create_notification(player: player)
    notification.read?.should eq false

    response = subject.patch "/notifications/read_all", headers: authenticated_headers_for(user)

    response.headers["Location"].should eq "/notifications"
    response.status_code.should eq(302)
    response.body.should eq "302"

    notification = Notification.find(notification.id).not_nil!
    notification.read?.should eq true
  end
end
