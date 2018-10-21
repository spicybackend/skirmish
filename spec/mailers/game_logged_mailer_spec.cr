require "./spec_helper"

describe GameLoggedMailer do
  describe "recipient" do
    it "is addressed to the user's email" do
      league = create_league
      _, _, loser_and_confirmer = create_and_pit_players(league)

      player = loser_and_confirmer
      user = player.user!
      game = league.games.first

      mailer = GameLoggedMailer.new(player, game)

      recipient = mailer.to.first
      recipient.email.should eq user.email
    end

    it "is addressed to the player's tag" do
      league = create_league
      _, _, loser_and_confirmer = create_and_pit_players(league)

      player = loser_and_confirmer
      game = league.games.first

      mailer = GameLoggedMailer.new(player, game)

      recipient = mailer.to.first
      recipient.name.should eq player.tag
    end
  end

  describe "sender" do
    it "is from the support address" do
      league = create_league
      _, _, loser_and_confirmer = create_and_pit_players(league)

      player = loser_and_confirmer
      game = league.games.first

      mailer = GameLoggedMailer.new(player, game)

      sender = mailer.from
      sender.should eq ApplicationMailer::FROM_GAMES
    end
  end

  describe "subject" do
    it "is a nice welcome message" do
      league = create_league
      winner_and_logger, _, loser_and_confirmer = create_and_pit_players(league)

      player = loser_and_confirmer
      game = league.games.first

      mailer = GameLoggedMailer.new(player, game)

      mailer.subject.should eq I18n.translate("mailer.game_logged.subject", { logger: winner_and_logger.tag })
    end
  end

  describe "content" do
    it "contains the mailer title" do
      league = create_league
      _, _, loser_and_confirmer = create_and_pit_players(league)

      player = loser_and_confirmer
      game = league.games.first

      mailer = GameLoggedMailer.new(player, game)

      mailer.html.should contain HTML.escape(I18n.translate("mailer.game_logged.title"))
      mailer.text.should contain I18n.translate("mailer.game_logged.title")
    end

    it "asks the user to confirm the game" do
      league = create_league
      _, _, loser_and_confirmer = create_and_pit_players(league)

      player = loser_and_confirmer
      game = league.games.first

      mailer = GameLoggedMailer.new(player, game)

      mailer.html.should contain HTML.escape(I18n.translate("mailer.game_logged.confirmation.content"))
      mailer.text.should contain I18n.translate("mailer.game_logged.confirmation.content")
    end

    it "contains a link to confirm the game" do
      league = create_league
      _, _, loser_and_confirmer = create_and_pit_players(league)

      player = loser_and_confirmer
      game = league.games.first

      mailer = GameLoggedMailer.new(player, game)

      verification_link = "#{ENV["BASE_URL"]}/leagues/#{league.id}/games/#{game.id}"

      mailer.html.should contain verification_link
      mailer.text.should contain verification_link
    end
  end
end
