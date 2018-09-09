require "./spec_helper"
require "../../src/models/notification.cr"

describe Notification do
  Spec.before_each do
    Notification.clear
    Game.clear
    Membership.clear
    League.clear
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

        notification.event_type = "some-made-up-event-type"
        notification.valid?.should eq false

        notification.errors.clear
        notification.event_type = Notification::EVENT_TYPES.first
        notification.valid?.should eq true
      end
    end

    describe "source" do
      it "must match the event type" do
        player = Player.first.not_nil!

        # TODO clean up later
        # create models for the sake of matching with a notification type
        league = create_league
        another_player = create_player_with_mock_user
        Membership.create!(player_id: player.id, league_id: league.id, joined_at: Time.now)
        Membership.create!(player_id: another_player.id, league_id: league.id, joined_at: Time.now)
        game_logger = League::LogGame.new(league: league, winner: player, loser: another_player, logger: player)
        game_logger.call || puts game_logger.errors.map(&.to_s)
        game = game_logger.game

        notification = create_notification(player: player)

        notification.event_type = Notification::GENERAL
        notification.source = nil
        notification.valid?.should eq true

        notification.errors.clear
        notification.event_type = Notification::GAME_LOGGED
        notification.valid?.should eq false

        notification.errors.clear
        notification.source = game
        notification.valid?.should eq true

        notification.errors.clear
        notification.event_type = Notification::GENERAL
        notification.valid?.should eq false
      end

      it "must be persisted if specified" do
        player = Player.first.not_nil!

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
        notification.source = Game.new
        notification.valid?.should eq false
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

  describe "#source" do
    context "a general notification without a source" do
      it "is nil" do
        player = Player.first.not_nil!
        notification = create_notification(player: player)

        notification.source.should eq nil
      end
    end

    context "a game logged notification" do
      it "is the logged game" do
        player = Player.first.not_nil!

        # TODO clean up later
        # create models for the sake of matching with a notification type
        league = create_league
        another_player = create_player_with_mock_user
        Membership.create!(player_id: player.id, league_id: league.id, joined_at: Time.now)
        Membership.create!(player_id: another_player.id, league_id: league.id, joined_at: Time.now)
        game_logger = League::LogGame.new(league: league, winner: player, loser: another_player, logger: player)
        game_logger.call || puts game_logger.errors.map(&.to_s)
        game = game_logger.game

        notification = create_notification(player: player, event_type: Notification::GAME_LOGGED, source: game)

        notification.source.class.should eq Game
        notification.source.not_nil!.id.should eq game.id
      end
    end
  end
end
