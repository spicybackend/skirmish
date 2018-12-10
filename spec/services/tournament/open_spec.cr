require "../spec_helper"

describe Tournament::Open do
  league = create_league

  create_tournament = -> do
    Tournament::Open.new(
      league: league
    ).call
  end

  describe "#call" do
    it "creates a tournament" do
      tournaments = Tournament.all.count
      create_tournament.call

      Tournament.all.count.should eq tournaments + 1
    end

    describe "the created tournament" do
      it "belongs to the given league" do
        tournament = create_tournament.call.not_nil!

        tournament.league!.id.should eq league.id
      end
    end

    context "when a tournament has already been created" do
      it "raises an error" do
        create_tournament.call

        expect_raises(Tournament::Open::OpenError, "A tournament for this league is already in progress") do
          create_tournament.call
        end
      end

      context "for a different league" do
        another_league = create_league
        Tournament::Open.new(
          league: another_league
        ).call

        it "creates a tournament" do
          tournaments = Tournament.all.count
          create_tournament.call

          Tournament.all.count.should eq tournaments + 1
        end

        describe "the created tournament" do
          it "belongs to the given league" do
            tournament = create_tournament.call.not_nil!

            tournament.league!.id.should eq league.id
          end
        end
      end
    end

    context "when a tournament for the league has already been started" do
      started_tournament = create_tournament.call.not_nil!
      player_a = create_player_with_mock_user
      player_b = create_player_with_mock_user

      [player_a, player_b].each do |player|
        Membership.create!(player_id: player.id, league_id: league.id)
      end

      [player_a, player_b].each do |player|
        Tournament::Enter.new(player: player, tournament: started_tournament).call
      end

      Tournament::Start.new(tournament: started_tournament).call

      it "raises an error" do
        expect_raises(Tournament::Open::OpenError, "A tournament for this league is already in progress") do
          create_tournament.call
        end
      end
    end
  end
end
