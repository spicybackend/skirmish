class League::LogGame
  getter winner, loser, league, logger

  property game : Game, errors : Array(String)

  def initialize(@league : League, @winner : Player, @loser : Player, @logger : Player)
    @game = Game.new
    @errors = [] of String
  end

  def call
    players.each do |player|
      unless league_members.includes?(player)
        @errors << "#{player} is not a member of #{league}"
        return false
      end
    end

    game.logged_by_id = logger.id
    game.league = league

    if game.valid? && game.save
      # TODO these should be validated and saved along with the game
      create_participations!

      return true
    else
      @errors += game.errors.map(&.to_s).compact
      return false
    end
  end

  private def players
    [winner, loser]
  end

  private def league_members
    league.active_players
  end

  private def create_participations!
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

    winner_participation = Participation.create!(
      game_id: game.id,
      player_id: winner.id,
      won: true,
      rating: new_winner_rating
    )

    loser_participation = Participation.create!(
      game_id: game.id,
      player_id: loser.id,
      won: false,
      rating: new_loser_rating
    )

    [winner_participation, loser_participation]
  end
end
