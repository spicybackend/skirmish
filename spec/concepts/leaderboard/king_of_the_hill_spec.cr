require "./spec_helper"
# require "../../../src/concepts/leaderboard/pure_skill.cr"

describe Leaderboard::KingOfTheHill do
  redis = Leaderboard::KingOfTheHill.redis

  describe "#rankings" do
    context "when no games have been played" do
      it "has no rankings" do
        league = create_league
        redis.del(Leaderboard::KingOfTheHill.redis_lookup_key(league))
        leaderboard = Leaderboard::KingOfTheHill.new(league)

        leaderboard.rankings.size.should eq 0
      end
    end

    context "when some games have been played" do
      it "rates players based on the order of won games" do
        league = create_league
        redis.del(Leaderboard::KingOfTheHill.redis_lookup_key(league))
        player_one, player_two, player_three = create_and_pit_players(league)

        leaderboard = Leaderboard::KingOfTheHill.new(league)

        # results based on #create_and_pit_players
        leaderboard.rankings.size.should eq 2
        leaderboard.rankings[0][:player].id.should eq player_one.id
        leaderboard.rankings[1][:player].id.should eq player_two.id

        game_logger = League::LogGame.new(league: league, winner: player_three, loser: player_one, logger: player_one)
        game_logger.call
        game = game_logger.game
        Game::Confirm.new(game: game, confirming_player: player_three).call

        updated_leaderboard = Leaderboard::KingOfTheHill.new(league)

        updated_leaderboard.rankings.size.should eq 3
        updated_leaderboard.rankings[0][:player].id.should eq player_three.id
        updated_leaderboard.rankings[1][:player].id.should eq player_one.id
        updated_leaderboard.rankings[2][:player].id.should eq player_two.id
      end
    end

    context "when a player on the leaderboard leaves the league" do
      it "ignores the inactive player and ranks based on only the active players" do
        league = create_league
        redis.del(Leaderboard::KingOfTheHill.redis_lookup_key(league))
        player_one, player_two, player_three = create_and_pit_players(league)


        game_logger = League::LogGame.new(league: league, winner: player_three, loser: player_one, logger: player_one)
        game_logger.call
        game = game_logger.game
        Game::Confirm.new(game: game, confirming_player: player_three).call

        leaderboard = Leaderboard::KingOfTheHill.new(league)
        # results based on #create_and_pit_players
        leaderboard.rankings.size.should eq 3
        leaderboard.rankings[0][:player].id.should eq player_three.id
        leaderboard.rankings[1][:player].id.should eq player_one.id
        leaderboard.rankings[2][:player].id.should eq player_two.id

        player_three.memberships_query.destroy

        updated_leaderboard = Leaderboard::KingOfTheHill.new(league)
        updated_leaderboard.rankings.size.should eq 2
        updated_leaderboard.rankings[0][:player].id.should eq player_one.id
        updated_leaderboard.rankings[1][:player].id.should eq player_two.id
      end
    end
  end

  describe "#ranking_for" do
    it "looks up players based on the order of won games" do
      league = create_league
      redis.del(Leaderboard::KingOfTheHill.redis_lookup_key(league))
      player_one, player_two, player_three = create_and_pit_players(league)

      leaderboard = Leaderboard::KingOfTheHill.new(league)
      leaderboard.ranking_for(player_one).should eq 1
      leaderboard.ranking_for(player_two).should eq 2
      leaderboard.ranking_for(player_three).should eq nil

      game_logger = League::LogGame.new(league: league, winner: player_three, loser: player_one, logger: player_one)
      game_logger.call
      game = game_logger.game
      Game::Confirm.new(game: game, confirming_player: player_three).call

      updated_leaderboard = Leaderboard::KingOfTheHill.new(league)

      updated_leaderboard.ranking_for(player_one).should eq 2
      updated_leaderboard.ranking_for(player_two).should eq 3
      updated_leaderboard.ranking_for(player_three).should eq 1
    end
  end
end
