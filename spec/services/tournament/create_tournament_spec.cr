require "../spec_helper"

describe Tournament::CreateTournament do
  league = create_league

  create_tournament = -> do
    Tournament::CreateTournament.new(
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

        expect_raises(Tournament::CreateTournament::TournamentCreationError, "A tournament for this league is already in progress") do
          create_tournament.call
        end
      end

      context "for a different league" do
        another_league = create_league
        Tournament::CreateTournament.new(
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

    pending "when a tournament has already been started" do
      it "raises an error" do
        create_tournament.call
        # started_tournament = create_tournament.call
        # Tournament::StartTournament.new(started_tournament).call

        expect_raises(Tournament::CreateTournament::TournamentCreationError, "A tournament for this league is already in progress") do
          create_tournament.call
        end
      end
    end
  end
end
