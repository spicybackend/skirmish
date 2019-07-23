require "./spec_helper"
require "../../../src/concepts/leaderboard/pure_skill.cr"

describe Leaderboard::PureSkill do
  describe "#rankings" do
    it "ranks all players equally if they have the same rating" do
      league = create_league
      player_one, player_two, player_three = create_and_pit_players(league)
      set_player_rating(league, player_one, 400)
      set_player_rating(league, player_two, 500)
      set_player_rating(league, player_three, 500)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.rankings.size.should eq 3

      leaderboard.rankings[0][:rank].should eq 1
      leaderboard.rankings[1][:rank].should eq 1
      leaderboard.rankings[2][:rank].should eq 3
      leaderboard.rankings[2][:player].id.should eq player_one.id
    end

    it "accurately determines player ranking based on their participation ratings" do
      league = create_league
      player_one, player_two, player_three = create_and_pit_players(league)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.rankings.size.should eq 3
      leaderboard.rankings[0][:player].id.should eq player_one.id
      leaderboard.rankings[1][:player].id.should eq player_two.id
      leaderboard.rankings[2][:player].id.should eq player_three.id

      rating_for_player_two = player_two.rating_for(league)
      set_player_rating(league, player_one, rating_for_player_two - 2)
      set_player_rating(league, player_three, rating_for_player_two - 1)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.rankings.size.should eq 3
      leaderboard.rankings[0][:player].should eq player_two
      leaderboard.rankings[1][:player].id.should eq player_three.id
      leaderboard.rankings[2][:player].id.should eq player_one.id
    end
  end

  describe "#ranking_for" do
    it "ranks all players equally if they have the same rating" do
      league = create_league
      player_one, player_two, player_three = create_and_pit_players(league)
      set_player_rating(league, player_one, 400)
      set_player_rating(league, player_two, 500)
      set_player_rating(league, player_three, 500)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.ranking_for(player_one).should eq 3
      leaderboard.ranking_for(player_two).should eq 1
      leaderboard.ranking_for(player_three).should eq 1
    end

    it "accurately fetches rankings for specific players based on their participation ratings" do
      league = create_league
      player_one, player_two, player_three = create_and_pit_players(league)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.ranking_for(player_one).should eq 1
      leaderboard.ranking_for(player_two).should eq 2
      leaderboard.ranking_for(player_three).should eq 3

      rating_for_player_two = player_two.rating_for(league)
      set_player_rating(league, player_one, rating_for_player_two - 20)
      set_player_rating(league, player_three, rating_for_player_two - 10)

      leaderboard = Leaderboard::PureSkill.new(league)
      leaderboard.ranking_for(player_one).should eq 3
      leaderboard.ranking_for(player_two).should eq 1
      leaderboard.ranking_for(player_three).should eq 2
    end
  end
end
