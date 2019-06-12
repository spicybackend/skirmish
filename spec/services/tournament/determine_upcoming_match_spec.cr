require "../spec_helper"

def create_tournament_and_enter_players
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

  tournament
end

describe Tournament::DetermineUpcomingMatch do
  describe "#call" do
    context "when the tournament hasn't started" do
      it "is nil" do
        tournament = create_tournament_and_enter_players
        player = tournament.players_query.first!

        match = Tournament::DetermineUpcomingMatch.new(player, tournament).call
        match.should eq nil
      end
    end

    context "when the tournament is in progress" do
      it "is a match" do
        tournament = create_tournament_and_enter_players
        player = tournament.players_query.first!

        Tournament::Start.new(tournament).call

        match = Tournament::DetermineUpcomingMatch.new(player, tournament).call
        match.should be_a Match
      end

      context "when the player is matched with another player" do
        it "is the match with the opposing player" do
          tournament = create_tournament_and_enter_players
          player = tournament.players_query.first!

          Tournament::Start.new(tournament).call
          expected_match = tournament.matches_query.where { (_player_a_id == player.id) | (_player_b_id == player.id) }.first!

          match = Tournament::DetermineUpcomingMatch.new(player, tournament).call.not_nil!
          match.id.should eq expected_match.id
        end

        context "and the game has been logged and confirmed" do
          it "is the next upcoming match" do
            tournament = create_tournament_and_enter_players
            player = tournament.players_query.first!

            Tournament::Start.new(tournament).call
            match_to_play = tournament.matches_query.where { (_player_a_id == player.id) | (_player_b_id == player.id) }.first!
            another_player = match_to_play.opponent(player).not_nil!

            logging_service = League::LogGame.new(tournament.league!, player, another_player, player)
            logging_service.call
            game = logging_service.game
            Game::Confirm.new(game, another_player).call

            expected_match = match_to_play.next_match.not_nil!

            match = Tournament::DetermineUpcomingMatch.new(player, tournament).call.not_nil!
            match.id.should eq expected_match.id
          end
        end
      end
    end

    context "when the tournament has finished" do
      it "is nil" do
        tournament = create_tournament_and_enter_players
        player = tournament.players_query.first!

        Tournament::Start.new(tournament).call
        # Having all matches won by a player will 'finish' the tournament
        tournament.matches_query.update(winner_id: player.id)

        match = Tournament::DetermineUpcomingMatch.new(player, tournament).call
        match.should be nil
      end
    end
  end
end
