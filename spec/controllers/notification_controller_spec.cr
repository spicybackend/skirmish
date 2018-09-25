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

  it "renders notifications index template" do
    response = subject.get "/notifications", headers: basic_authenticated_headers

    response.status_code.should eq(200)
    response.body.should contain("notifications")
  end

  describe "opening notifications" do
    context "a notification without an action" do
      it "marks the notification as read" do
        player = create_player_with_mock_user
        user = player.user.not_nil!
        notification = create_notification(player: player)

        notification.read?.should eq false
        response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

        notification = Notification.find(notification.id).not_nil!
        notification.read?.should eq true
      end

      it "redirects to the notifications listing" do
        player = create_player_with_mock_user
        user = player.user.not_nil!
        notification = create_notification(player: player)

        response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

        response.headers["Location"].should eq "/notifications"
        response.status_code.should eq(302)
      end
    end

    context "a notification with an action" do
      it "marks the notification as read" do
        player = create_player_with_mock_user
        user = player.user.not_nil!

        # TODO clean up later
        # create models for the sake of matching with a notification type
        league = create_league
        another_player = create_player_with_mock_user
        Membership.create!(player_id: player.id, league_id: league.id, joined_at: Time.now)
        Membership.create!(player_id: another_player.id, league_id: league.id, joined_at: Time.now)
        game_logger = League::LogGame.new(league: league, winner: player, loser: another_player, logger: player)
        game_logger.call
        game = game_logger.game

        notification = create_notification(player: player, event_type: Notification::GAME_LOGGED, source: game)

        notification.read?.should eq false
        response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

        notification = Notification.find(notification.id).not_nil!
        notification.read?.should eq true
      end

      it "redirects to the notification action url" do
        player = create_player_with_mock_user
        user = player.user.not_nil!

        # TODO clean up later
        # create models for the sake of matching with a notification type
        league = create_league
        another_player = create_player_with_mock_user
        Membership.create!(player_id: player.id, league_id: league.id, joined_at: Time.now)
        Membership.create!(player_id: another_player.id, league_id: league.id, joined_at: Time.now)
        game_logger = League::LogGame.new(league: league, winner: player, loser: another_player, logger: player)
        game_logger.call
        game = game_logger.game

        notification = create_notification(player: player, event_type: Notification::GAME_LOGGED, source: game)

        notification.read?.should eq false
        response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

        response.headers["Location"].should eq "/leagues/#{league.id}/games/#{game.id}"
        response.status_code.should eq(302)
      end
    end

    context "trying to open somebody else's notification" do
      it "does not mark the notification as read" do
        player = create_player_with_mock_user
        user = player.user.not_nil!

        another_player = create_player_with_mock_user
        notification = create_notification(player: another_player)

        notification.read?.should eq false
        response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

        notification = Notification.find(notification.id).not_nil!
        notification.read?.should eq false
      end

      it "redirects to the notifications listing" do
        player = create_player_with_mock_user
        user = player.user.not_nil!

        another_player = create_player_with_mock_user
        notification = create_notification(player: another_player)

        response = subject.get "/notifications/#{notification.id}", headers: authenticated_headers_for(user)

        response.headers["Location"].should eq "/notifications"
        response.status_code.should eq(302)
      end
    end
  end

  describe "marking notifications as read" do
    it "marks the notification as read" do
      player = create_player_with_mock_user
      user = player.user.not_nil!
      notification = create_notification(player: player)
      notification.read?.should eq false

      response = subject.patch "/notifications/#{notification.id}/read", headers: authenticated_headers_for(user)

      notification = Notification.find(notification.id).not_nil!
      notification.read?.should eq true
    end

    it "redirects to the notifications listing" do
      player = create_player_with_mock_user
      user = player.user.not_nil!
      notification = create_notification(player: player)

      response = subject.patch "/notifications/#{notification.id}/read", headers: authenticated_headers_for(user)

      response.headers["Location"].should eq "/notifications"
      response.status_code.should eq(302)
    end
  end

  describe "marking all notifications as read" do
    it "marks all the player's notifications as read" do
      player = create_player_with_mock_user
      user = player.user.not_nil!
      notification = create_notification(player: player)
      notification.read?.should eq false
      another_notification = create_notification(player: player)
      another_notification.read?.should eq false

      response = subject.patch "/notifications/read_all", headers: authenticated_headers_for(user)

      notification = Notification.find(notification.id).not_nil!
      another_notification = Notification.find(another_notification.id).not_nil!

      notification.read?.should eq true
      another_notification.read?.should eq true
    end

    it "redirects to the notifications listing" do
      player = create_player_with_mock_user
      user = player.user.not_nil!
      create_notification(player: player)
      create_notification(player: player)

      response = subject.patch "/notifications/read_all", headers: authenticated_headers_for(user)

      response.headers["Location"].should eq "/notifications"
      response.status_code.should eq(302)
    end
  end
end
