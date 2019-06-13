require "./spec_helper"

def tournament_with_confirmed_game
  league = create_league
  tournament = Tournament::Open.new(league: league).call.not_nil!

  player_a = create_player_with_mock_user
  player_b = create_player_with_mock_user
  player_c = create_player_with_mock_user
  player_d = create_player_with_mock_user

  [player_a, player_b, player_c, player_d].each do |player|
    Membership.create!(player_id: player.id, league_id: league.id)
  end

  [player_a, player_b, player_c, player_d].each do |player|
    Tournament::Enter.new(player: player, tournament: tournament).call
  end

  Tournament::Start.new(tournament).call

  player = player_a
  match_to_play = tournament.matches_query.where { (_player_a_id == player.id) | (_player_b_id == player.id) }.first!
  another_player = match_to_play.opponent(player).not_nil!

  logging_service = League::LogGame.new(tournament.league!, player, another_player, player)
  logging_service.call
  game = logging_service.game
  Game::Confirm.new(game, another_player).call

  tournament
end

describe TournamentMatchMailer do
  describe "recipient" do
    it "is addressed to the user's email" do
      tournament = tournament_with_confirmed_game
      match = tournament.matches_query.where { _game_id != nil }.first!
      player = match.game!.players_query.first!
      user = player.user!

      mailer = TournamentMatchMailer.new(player, match)

      recipient = mailer.to.first
      recipient.email.should eq user.email
    end

    it "is addressed to the player's tag" do
      tournament = tournament_with_confirmed_game
      match = tournament.matches_query.where { _game_id != nil }.first!
      player = match.game!.players_query.first!

      mailer = TournamentMatchMailer.new(player, match)

      recipient = mailer.to.first
      recipient.name.should eq player.tag
    end
  end

  describe "sender" do
    it "is from the games address" do
      league = create_league
      tournament = tournament_with_confirmed_game
      match = tournament.matches_query.where { _game_id != nil }.first!
      player = match.game!.players_query.first!

      mailer = TournamentMatchMailer.new(player, match)

      sender = mailer.from
      sender.should eq ApplicationMailer::FROM_GAMES
    end
  end

  describe "subject" do
    it "informs player of their opponent" do
      tournament = tournament_with_confirmed_game
      match = tournament.matches_query.where { _game_id != nil }.first!
      player = match.game!.players_query.first!
      opponent = match.opponent(player).not_nil!

      mailer = TournamentMatchMailer.new(player, match)

      mailer.subject.should eq I18n.translate("mailer.tournament_match.subject", { opponent: opponent.tag })
    end
  end

  describe "content" do
    it "includes the chance of winning against the opponent" do
      tournament = tournament_with_confirmed_game
      match = tournament.matches_query.where { _game_id != nil }.first!
      player = match.game!.players_query.first!
      opponent = match.opponent(player).not_nil!

      mailer = TournamentMatchMailer.new(player, match)

      mailer.html.should contain "% chance of winning against #{opponent.tag}"
      mailer.text.should contain "% chance of winning against #{opponent.tag}"
    end

    it "contains a link to confirm the game" do
      tournament = tournament_with_confirmed_game
      match = tournament.matches_query.where { _game_id != nil }.first!
      player = match.game!.players_query.first!

      mailer = TournamentMatchMailer.new(player, match)

      verification_link = "#{ENV["BASE_URL"]}/leagues/#{tournament.league_id}/tournaments/#{tournament.id}"

      mailer.html.should contain verification_link
      mailer.text.should contain verification_link
    end
  end
end
