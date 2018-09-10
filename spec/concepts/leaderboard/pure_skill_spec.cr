require "../spec_helper"

def create_and_pit_players(league : League)
  player_one = create_player_with_mock_user
  player_two = create_player_with_mock_user
  player_three = create_player_with_mock_user

  Membership.create!(player_id: player_one.id, league_id: league.id, joined_at: Time.now)
  Membership.create!(player_id: player_two.id, league_id: league.id, joined_at: Time.now)
  Membership.create!(player_id: player_three.id, league_id: league.id, joined_at: Time.now)

  game_logger = League::LogGame.new(league: league, winner: player_one, loser: player_three, logger: player_one)
  game_logger.call
  game = game_logger.game
  Game::Confirm.new(game: game, confirming_player: player_three).call

  [player_one, player_two, player_three]
end

describe Leaderboard::PureSkill do
  Spec.before_each do
    League.clear
    Player.clear
    Membership.clear
  end

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
      participation_for_player_one = Participation.first("WHERE player_id = ?", [player_one.id]).not_nil!
      participation_for_player_three = Participation.first("WHERE player_id = ?", [player_three.id]).not_nil!
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
      participation_for_player_one = Participation.first("WHERE player_id = ?", [player_one.id]).not_nil!
      participation_for_player_three = Participation.first("WHERE player_id = ?", [player_three.id]).not_nil!
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
