class Leaderboard::PureSkill < Leaderboard::Base
  setter players_by_ratings : Hash(Int32, Player) | Nil

  def rankings
    players_by_ratings
  end

  def ranking_for(player : Player)
    ranked_player_rating_for(player).try(&.first)
  end

  private def players_sorted_by_ratings
    # heckin' DB hammering
    # grab these in another hash beforehand
    # ie. player => int32
    league.active_players.to_a.sort do |player_1, player_2|
      # reversed for order ascension
      # a player with the highest rating has the lowest ranking
      player_2.rating_for(league) <=> player_1.rating_for(league)
    end
  end

  private def players_by_ratings
    @players_by_ratings ||= begin
      hashed_player_ratings = {} of Int32 => Player

      players_sorted_by_ratings.each_with_index do |player, index|
        hashed_player_ratings[index + 1] = player
      end

      hashed_player_ratings
    end
  end

  private def ranked_player_rating_for(player : Player)
    players_by_ratings.find { |_, ranked_player| ranked_player.id == player.id }
  end
end
