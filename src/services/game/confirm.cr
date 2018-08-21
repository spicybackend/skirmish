class Game::Confirm
  getter :game, :confirming_player, league : League, winner : Player, loser : Player, winner_participation : Participation, loser_participation : Participation
  property :errors

  def initialize(@game : Game, @confirming_player : Player)
    @league = game.league
    @winner = game.winner
    @loser = game.loser

    @winner_participation = game.participations.all("AND participations.won = 1 LIMIT 1").first
    @loser_participation = game.participations.all("AND participations.won = 0 LIMIT 1").first

    @errors = [] of String
  end

  def call
    if game.confirmed?
      @errors << "Game already confirmed"
      return false
    end

    if winner && loser
      if can_be_confirmed_by_player?
        update_game
        update_ratings

        if game_and_participations_valid?
          save_game_and_participations
          true
        else
          @errors += game_and_participation_errors.map(&.to_s).compact
          false
        end
      else
        @errors << "Game must be confirmed by an opposing player"
        false
      end
    else
      @errors << "Game must have a winner and a loser"
      return false
    end
  end

  private def can_be_confirmed_by_player?
    Game::CanBeConfirmedByPlayer.new(game: game, player: confirming_player).call
  end

  private def update_game
    game.confirmed_by_id = confirming_player.id
    game.confirmed_at = Time.now
  end

  private def update_ratings
    winner_rating, loser_rating = new_ratings

    winner_participation.rating = winner_rating
    loser_participation.rating = loser_rating
  end

  private def old_ratings
    [winner.rating_for(league), loser.rating_for(league)]
  end

  private def new_ratings
    old_winner_rating, old_loser_rating = old_ratings

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

    [new_winner_rating, new_loser_rating]
  end

  private def game_and_participations_valid?
    game.valid? && winner_participation.valid? && loser_participation.valid?
  end

  private def save_game_and_participations
    game.save && winner_participation.save && loser_participation.save
  end

  private def game_and_participation_errors
    game.errors + winner_participation.errors + loser_participation.errors
  end
end
