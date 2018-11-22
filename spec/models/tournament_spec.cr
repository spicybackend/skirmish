require "./spec_helper"

describe Tournament do
  describe "scopes" do
    describe ".unfinished" do
      league = create_league
      another_league = create_league

      finished_tournament = Tournament::Open.new(league).call.not_nil!
      finished_tournament.update!(finished_at: Time.now)

      new_tournament = Tournament::Open.new(league).call.not_nil!

      tournament_in_progress = Tournament::Open.new(another_league).call.not_nil!
      player = create_player_with_mock_user
      Entrant.create!(
        player_id: player.id,
        tournament_id: tournament_in_progress.id
      )
      another_player = create_player_with_mock_user
      Entrant.create!(
        player_id: another_player.id,
        tournament_id: tournament_in_progress.id
      )
      Tournament::Start.new(tournament_in_progress).call

      it "includes tournaments that haven't been started" do
        Tournament.unfinished.pluck(:id).should contain new_tournament.id
      end

      it "includes tournaments that are in progress" do
        Tournament.unfinished.pluck(:id).should contain tournament_in_progress.id
      end

      it "excludes tournaments that are finished" do
        Tournament.unfinished.pluck(:id).should_not contain finished_tournament.id
      end
    end

    describe ".for_league" do
      league = create_league
      another_league = create_league

      tournament = Tournament::Open.new(league).call.not_nil!
      another_tournament = Tournament::Open.new(another_league).call.not_nil!

      it "includes tournaments that belong to the given league" do
        Tournament.for_league(league).pluck(:id).should contain tournament.id
        Tournament.for_league(another_league).pluck(:id).should contain another_tournament.id
      end

      it "excludes tournaments that don't belong to the given league" do
        Tournament.for_league(league).pluck(:id).should_not contain another_tournament.id
        Tournament.for_league(another_league).pluck(:id).should_not contain tournament.id
      end
    end
  end

  pending "#in_progress?" do
  end
end
