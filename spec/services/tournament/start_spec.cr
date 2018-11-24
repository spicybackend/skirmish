require "../spec_helper"

describe Tournament::Start do
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

  start_tournament = -> do
    Tournament::Start.new(
      tournament: tournament
    ).call
  end

  describe "#call" do
    context "a single elimination tournament" do
      context "when the tournament is full (has no byes)" do
        it "creates a match for each player elimination" do
          initial_match_count = Match.all.count
          start_tournament.call

          expected_matches_created = tournament.players.size - 1
          Match.all.count.should eq initial_match_count + expected_matches_created
        end
      end

      context "when the tournament has byes" do
        Entrant.where { _player_id == player_d.id }.destroy

        it "creates defaulted matches without players" do
          start_tournament.call

          tournament.matches_query.where { _player_a_id == nil || _player_b_id == nil }.exists?.should eq true
        end
      end
    end

    it "marks the tournament as in progress" do
      start_tournament.call

      tournament.in_progress?.should eq true
    end

    it "marks the tournament as no longer being open" do
      start_tournament.call

      tournament.open?.should eq false
    end

    context "when the tournament has already been started" do
      it "raises an error" do
        start_tournament.call

        expect_raises(Tournament::Start::StartError, "The tournament has already been started") do
          start_tournament.call
        end
      end
    end

    context "when there aren't enough players to start" do
      it "raises an error" do
        Entrant.where { _player_id.in([player_a.id, player_b.id, player_c.id]) }.where { _tournament_id == tournament.id }.destroy

        expect_raises(Tournament::Start::StartError, "Not enough players entered to start the tournament") do
          start_tournament.call
        end
      end
    end
  end
end
