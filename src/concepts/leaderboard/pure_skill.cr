class Leaderboard::PureSkill < Leaderboard::Base
  setter ranked_players_with_ratings : Array(NamedTuple(rating: Int32, player: Player, rank: Int32)) | Nil

  def rankings
    ranked_players_with_ratings
  end

  def ranking_for(player : Player)
    ranked_player_rating_for(player).try(&.[](:rank))
  end

  private def rating_and_player
    # heckin' DB hammering
    # grab these in another hash beforehand
    # ie. player => int32
    league.active_players.to_a.map do |player|
      {rating: player.rating_for(league), player: player}
    end.sort do |v1, v2|
      # reverse weight - highest rating => lowest ranked (numerically)
      v2[:rating] <=> v1[:rating]
    end
  end

  private def ranked_players_with_ratings
    rank = 1
    previous = 0
    @ranked_players_with_ratings ||= rating_and_player.map_with_index do |rated_player, index|

      rank = rated_player[:rating] == previous ? rank : index + 1
      previous = rated_player[:rating]

      rated_player.merge({rank: rank})
    end
  end

  private def ranked_player_rating_for(player : Player)
    ranked_players_with_ratings.find { |rated_player| rated_player[:player].id == player.id }
  end
end
