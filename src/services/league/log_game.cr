class League::LogGame
  getter winner, loser, league

  property game : Game, errors : Array(String)

  def initialize(@winner : Player, @loser : Player, @league : League)
    @game = Game.new
    @errors = [] of String
  end

  def call
    unless league_players.includes?(winner)
      @errors << "#{winner} is not a member of #{league}"
      return false
    end

    unless league_players.includes?(loser)
      @errors << "#{loser} is not a member of #{league}"
      return false
    end

    game.winner_id = winner.id
    game.league = league

    if game.valid? && game.save
      old_winner_rating = winner.rating_for(league)
      old_loser_rating = loser.rating_for(league)

      new_winner_rating = Rating::DetermineNewRating.new(
        old_rating: old_winner_rating,
        other_rating: old_loser_rating,
        won: true,
        league: league
      ).call

      new_loser_rating = Rating::DetermineNewRating.new(
        old_rating: old_loser_rating,
        other_rating: old_winner_rating,
        won: false,
        league: league
      ).call

      Participation.create!(
        game_id: game.id,
        player_id: winner.id,
        won: true,
        rating: new_winner_rating
      )

      Participation.create!(
        game_id: game.id,
        player_id: loser.id,
        won: false,
        rating: new_loser_rating
      )

      return true
    else
      @errors += game.errors.map(&.to_s).compact

      return false
    end
  end

  private def league_players
    league.players
  end
end
