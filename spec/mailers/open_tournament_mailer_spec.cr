require "./spec_helper"

describe OpenTournamentMailer do
  league = create_league
  tournament = Tournament::Open.new(league).call.not_nil!
  player = create_player_with_mock_user
  user = player.user!

  describe "recipient" do
    it "is addressed to the user's email" do
      mailer = OpenTournamentMailer.new(player, tournament)

      recipient = mailer.to.first
      recipient.email.should eq user.email
    end

    it "is addressed to the player's tag" do
      mailer = OpenTournamentMailer.new(player, tournament)

      recipient = mailer.to.first
      recipient.name.should eq player.tag
    end
  end

  describe "sender" do
    it "is from the games address" do
      mailer = OpenTournamentMailer.new(player, tournament)

      sender = mailer.from
      sender.should eq ApplicationMailer::FROM_GAMES
    end
  end

  describe "subject" do
    it "is a nice open tournament message" do
      mailer = OpenTournamentMailer.new(player, tournament)

      mailer.subject.should eq I18n.translate("mailer.open_tournament.subject", { league_name: tournament.league!.name })
    end
  end

  describe "content" do
    it "contains the mailer title" do
      mailer = OpenTournamentMailer.new(player, tournament)

      mailer.html.should contain HTML.escape(I18n.translate("mailer.open_tournament.title"))
      mailer.text.should contain I18n.translate("mailer.open_tournament.title")
    end

    it "contains the mailer subtitle" do
      mailer = OpenTournamentMailer.new(player, tournament)

      mailer.subject.should eq I18n.translate("mailer.open_tournament.subtitle", { league_name: tournament.league!.name })
    end

    context "when no custom mailer content is given" do
      it "contains the mailer text" do
        mailer = OpenTournamentMailer.new(player, tournament)

        mailer.html.should contain HTML.escape(I18n.translate("mailer.open_tournament.content"))
        mailer.text.should contain I18n.translate("mailer.open_tournament.content")
      end
    end

    context "when custom mailer content is given" do
      it "uses the custom content instead of the default mailer text" do
        custom_content = <<-CONTENT
          Woohoo!

          A new tournament is open!"
        CONTENT

        mailer = OpenTournamentMailer.new(player, tournament, custom_content)

        custom_content.split("\n").each do |content_paragraph|
          p content_paragraph
          p (/\<p.*\>.*(#{content_paragraph.strip}).*\<\/p\>/.match(mailer.html))
          p (mailer.html.match(/\<p.*\>.*(#{content_paragraph.strip}).*\<\/p\>/))

          /\<p.*\>.*#{content_paragraph.strip}.*\<\/p\>/.match(mailer.html).should_not be_nil
        end

        mailer.text.should contain custom_content

        mailer.html.should_not contain HTML.escape(I18n.translate("mailer.open_tournament.content"))
        mailer.text.should_not contain I18n.translate("mailer.open_tournament.content")
      end
    end

    it "contains a link to the tournament" do
      mailer = OpenTournamentMailer.new(player, tournament)

      tournament_link = "#{ENV["BASE_URL"]}/leagues/#{league.id}/tournaments/#{tournament.id}"

      mailer.html.should contain tournament_link
      mailer.text.should contain tournament_link
    end
  end
end
