class Game::Confirm
  getter :game, :confirming_player, league : League, winner : Player, loser : Player, winner_participation : Participation, loser_participation : Participation
  property :errors

  def initialize(@game : Game, @confirming_player : Player)
    @league = game.league!
    @winner = game.winner
    @loser = game.loser

    @winner_participation = game.participations_query.where { _won == true }.to_a.first
    @loser_participation = game.participations_query.where { _won == false }.to_a.first

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
        update_tournament_matches

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

  private def update_tournament_matches
    # TODO find a better way to match this independent of being player_a or player_b
    league.tournaments_query.unfinished.each do |tournament|
      tournament.matches_query.where { _winner_id == nil && ((_player_a_id == winner.id && _player_b_id == loser.id) || (_player_a_id == loser.id && _player_b_id == winner.id)) }.each do |match|
        match.update!(winner_id: winner.id)
        if next_match = Match.find(match.next_match_id)
          if next_match.player_a_id
            next_match.update!(player_b_id: winner.id)
          else
            next_match.update!(player_a_id: winner.id)
          end
        end

        # also update the lower bracket for double-elim (should this be stored as next_loser_match_id?)

        tournament = match.tournament.not_nil!
        if tournament.finished?
          tournament.update!(finished_at: Time.now)
        end
      end
    end
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
    game.errors.full_messages + winner_participation.errors.full_messages + loser_participation.errors.full_messages
  end
end
