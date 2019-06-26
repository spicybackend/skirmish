class Leaderboard::KingOfTheHill < Leaderboard::Base
  setter ranked_players_with_ratings : Array(NamedTuple(rating: Int32, player: Player, rank: Int32)) | Nil
  property leaderboard_player_ids : Array(Redis::RedisValue) | Nil

  def initialize(@league : League)
    super(league: league)
  end

  def self.redis
    @@redis ||= if redis_url = ENV["REDIS_URL"]?
      Redis.new(url: redis_url)
    else
      Redis.new
    end
  end

  def self.redis_lookup_key(league : League)
    "#{ "test-" if Amber.env.test? }league-#{league.id}-leaderboard"
  end

  def rankings
    ranked_players_with_ratings
  end

  def ranking_for(player : Player)
    ratings = ranked_players_with_ratings

    return unless ratings

    if rating_for_player = ratings.find { |leaderboard_ranking| leaderboard_ranking[:player].id == player.id }
      rating_for_player[:rank]
    end
  end

  private def redis_lookup_key
    self.class.redis_lookup_key(league)
  end

  private def leaderboard_player_ids
    @leaderboard_player_ids ||= self.class.redis.lrange(redis_lookup_key, 0, -1)
  end

  private def ranked_players_with_ratings
    @ranked_players_with_ratings ||= leaderboard_player_ids.map_with_index do |player_id, index|
      player = Player.find(player_id.as(String).to_i64).not_nil!

      {
        rating: player.rating_for(league),
        player: player,
        rank: index + 1
      }
    end
  end
end
