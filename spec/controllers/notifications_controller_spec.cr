require "./spec_helper"

def notification_props
  {
    player_id: 1,
    event_type: "Fake",
    sent_at: Time.now,
    read_at: nil,
    title: "Fake",
    content: "Fake"
  }
end

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

  it "renders notifications show template" do
    player = create_player_with_mock_user
    user = player.user.not_nil!
    notification = create_notification(player: player)

    response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

    response.status_code.should eq(302)
    # TODO check location redirects as appropriate to notification type
  end

  pending "reads a notifications" do
    model = create_notifications
    response = subject.delete "/notifications/#{model.id}", headers: basic_authenticated_headers

    response.headers["Location"].should eq "/notifications"
    response.status_code.should eq(302)
    response.body.should eq "302"
  end

  pending "reads all notifications" do
  end
end
