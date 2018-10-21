require "./spec_helper"
require "../../../src/concepts/leaderboard/pure_skill.cr"

describe Leaderboard::PureSkill do
  describe "#rankings" do
    it "accurately determines player ranking based on their participation ratings" do
      league = create_league
      player_one, player_two, player_three = create_and_pit_players(league)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.rankings.size.should eq 3
      leaderboard.rankings[1].id.should eq player_one.id
      leaderboard.rankings[2].id.should eq player_two.id
      leaderboard.rankings[3].id.should eq player_three.id

      rating_for_player_two = player_two.rating_for(league)
      participation_for_player_one = player_one.participations.last
      participation_for_player_three = player_three.participations.last
      participation_for_player_one.rating = rating_for_player_two - 2
      participation_for_player_three.rating = rating_for_player_two - 1
      participation_for_player_one.save && participation_for_player_three.save

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.rankings.size.should eq 3
      leaderboard.rankings[1].id.should eq player_two.id
      leaderboard.rankings[2].id.should eq player_three.id
      leaderboard.rankings[3].id.should eq player_one.id
    end
  end

  describe "#ranking_for" do
    it "accurately fetches rankings for specific players based on their participation ratings" do
      league = create_league
      player_one, player_two, player_three = create_and_pit_players(league)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.ranking_for(player_one).should eq 1
      leaderboard.ranking_for(player_two).should eq 2
      leaderboard.ranking_for(player_three).should eq 3

      rating_for_player_two = player_two.rating_for(league)
      participation_for_player_one = player_one.participations.last
      participation_for_player_three = player_three.participations.last
      participation_for_player_one.rating = rating_for_player_two - 2
      participation_for_player_three.rating = rating_for_player_two - 1
      participation_for_player_one.save && participation_for_player_three.save

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.ranking_for(player_one).should eq 3
      leaderboard.ranking_for(player_two).should eq 1
      leaderboard.ranking_for(player_three).should eq 2
    end
  end
end
