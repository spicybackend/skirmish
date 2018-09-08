require "./spec_helper"
require "../../src/models/notification.cr"

describe Notification do
  Spec.before_each do
    Notification.clear
    Player.clear

    create_player_with_mock_user
  end

  describe "validations" do
    describe "player" do
      it "must be a associated to an existing player" do
        notification = create_notification(player: Player.first.not_nil!)
        notification.player_id = nil

        notification.valid?.should eq false
      end
    end

    describe "event type" do
      it "must be present" do
        notification = create_notification(player: Player.first.not_nil!)

        notification.event_type = nil
        notification.valid?.should eq false
      end

      it "must be a specified event type" do
        notification = create_notification(player: Player.first.not_nil!)

        notification.errors.clear
        notification.event_type = "some-made-up-event-type"
        notification.valid?.should eq false

        notification.errors.clear
        notification.event_type = Notification::EVENT_TYPES.first
        notification.valid?.should eq true
      end
    end

    describe "title" do
      it "must be present" do
        notification = create_notification(player: Player.first.not_nil!)

        notification.title = nil
        notification.valid?.should eq false

        notification.errors.clear
        notification.title = ""
        notification.valid?.should eq false

        notification.errors.clear
        notification.title = "Some Title"
        notification.valid?.should eq true
      end
    end

    describe "content" do
      it "is invalid" do
        notification = create_notification(player: Player.first.not_nil!)

        notification.content = nil
        notification.valid?.should eq false

        notification.errors.clear
        notification.content = ""
        notification.valid?.should eq false

        notification.errors.clear
        notification.content = "Some Content"
        notification.valid?.should eq true
      end
    end
  end

  describe "#read?" do
    context "when the notification has no date of reading" do
      it "is false" do
        notification = create_notification(player: Player.first.not_nil!)

        notification.read?.should eq false
      end
    end

    context "when the notification has a date of reading" do
      it "is true" do
        notification = create_notification(player: Player.first.not_nil!)
        notification.read_at = Time.now

        notification.read?.should eq true
      end
    end
  end
end
