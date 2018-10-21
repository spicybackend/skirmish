require "./spec_helper"
require "../../src/mailers/welcome_mailer.cr"

describe WelcomeMailer do
  describe "recipient" do
    it "is addressed to the user's email" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      recipient = mailer.to.first
      recipient.email.should eq user.email
    end

    it "is addressed to the player's tag" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      recipient = mailer.to.first
      recipient.name.should eq player.tag
    end
  end

  describe "sender" do
    it "is from the support address" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      sender = mailer.from
      sender.should eq ApplicationMailer::FROM_SUPPORT
    end
  end

  describe "subject" do
    it "is a nice welcome message" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      mailer.subject.should eq "Welcome to Skirmish"
    end
  end

  describe "content" do
    it "contains the mailer title" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      mailer.html.should contain HTML.escape(I18n.translate("mailer.welcome.title"))
      mailer.text.should contain I18n.translate("mailer.welcome.title")
    end

    it "contains the mailer text" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      mailer.html.should contain HTML.escape(I18n.translate("mailer.welcome.content"))
      mailer.text.should contain I18n.translate("mailer.welcome.content")
    end

    it "asks the user to verify their account" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      mailer.html.should contain HTML.escape(I18n.translate("mailer.welcome.verification.content"))
      mailer.text.should contain I18n.translate("mailer.welcome.verification.content")
    end

    it "contains a link to verify the user's account" do
      player = create_player_with_mock_user
      user = player.user!
      mailer = WelcomeMailer.new(player)

      verification_link = "#{ENV["BASE_URL"]}/verify/#{user.verification_code}"

      mailer.html.should contain verification_link
      mailer.text.should contain verification_link
    end
  end
end
