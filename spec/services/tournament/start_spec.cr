require "../spec_helper"

describe Tournament::Start do
  league = create_league
  tournament = Tournament::Open.new(league: league).call.not_nil!

  player_a = create_player_with_mock_user
  player_b = create_player_with_mock_user
  player_c = create_player_with_mock_user
  player_d = create_player_with_mock_user

  [player_a, player_b, player_c, player_d].each do |player|
    Tournament::Enter.new(player: player, tournament: tournament).call
  end

  start_tournament = -> do
    Tournament::Start.new(
      tournament: tournament
    ).call
  end

  # TODO: Rewrite all copied spec contexts

  describe "#call" do
    pending "creates a tournament" do
      tournaments = Tournament.all.count
      start_tournament.call

      Tournament.all.count.should eq tournaments + 1
    end

    describe "the created tournament" do
      pending "belongs to the given league" do
        tournament = start_tournament.call.not_nil!

        tournament.league!.id.should eq league.id
      end
    end

    context "when a tournament has already been created" do
      pending "raises an error" do
        start_tournament.call

        expect_raises(Tournament::Start::StartError, "A tournament for this league is already in progress") do
          start_tournament.call
        end
      end
    end

    pending "when a tournament has already been started" do
      pending "raises an error" do
        start_tournament.call
        # started_tournament = start_tournament.call
        # Tournament::Start.new(started_tournament).call

        expect_raises(Tournament::Start::OpenError, "A tournament for this league is already in progress") do
          start_tournament.call
        end
      end
    end
  end
end
