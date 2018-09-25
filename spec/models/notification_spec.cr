require "./spec_helper"
require "../../src/models/notification.cr"

describe Notification do
  Spec.before_each do
    create_player_with_mock_user
  end

  describe "validations" do
    describe "player" do
      it "must be a associated to an existing player" do
        notification = create_notification(player: Player.all.first!)
        notification.player_id = nil

        notification.valid?.should eq false
      end
    end

    describe "event type" do
      it "must be a specified event type" do
        notification = create_notification(player: Player.all.first!)

        notification.event_type = "some-made-up-event-type"
        notification.valid?.should eq false

        notification.event_type = Notification::EVENT_TYPES.first
        notification.valid?.should eq true
      end
    end

    describe "source" do
      it "must match the event type" do
        player = Player.all.first!

        # TODO clean up later
        # create models for the sake of matching with a notification type
        league = create_league
        another_player = create_player_with_mock_user
        Membership.create!(player_id: player.id, league_id: league.id, joined_at: Time.now)
        Membership.create!(player_id: another_player.id, league_id: league.id, joined_at: Time.now)
        game_logger = League::LogGame.new(league: league, winner: player, loser: another_player, logger: player)
        game_logger.call
        game = game_logger.game

        notification = create_notification(player: player)

        notification.event_type = Notification::GENERAL
        notification.source_type = nil
        notification.source_id = nil
        notification.valid?.should eq true

        notification.event_type = Notification::GAME_LOGGED
        notification.valid?.should eq false

        notification.source_type = game.class.name
        notification.source_id = game.id
        notification.valid?.should eq true

        notification.event_type = Notification::GENERAL
        notification.valid?.should eq false
      end

      it "must be persisted if specified" do
        player = Player.all.first!

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
        notification.source_id = nil
        notification.valid?.should eq false
      end
    end

    describe "title" do
      it "must be present" do
        notification = create_notification(player: Player.all.first!)

        notification.title = ""
        notification.valid?.should eq false

        notification.title = "Some Title"
        notification.valid?.should eq true
      end
    end

    describe "content" do
      it "must be present" do
        notification = create_notification(player: Player.all.first!)

        notification.content = ""
        notification.valid?.should eq false

        notification.content = "Some Content"
        notification.valid?.should eq true
      end
    end
  end

  describe "#read?" do
    context "when the notification has no date of reading" do
      it "is false" do
        notification = create_notification(player: Player.all.first!)

        notification.read?.should eq false
      end
    end

    context "when the notification has a date of reading" do
      it "is true" do
        notification = create_notification(player: Player.all.first!)
        notification.read_at = Time.now

        notification.read?.should eq true
      end
    end
  end

  describe "#source" do
    context "a general notification without a source" do
      it "is nil" do
        player = Player.all.first!
        notification = create_notification(player: player)

        notification.source.should eq nil
      end
    end

    context "a game logged notification" do
      it "is the logged game" do
        player = Player.all.first!

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

        notification.source.class.should eq Game
        notification.source.not_nil!.id.should eq game.id
      end
    end
  end
end
