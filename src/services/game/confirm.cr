class Game::Confirm
  getter :game, :confirming_player
  property :errors

  def initialize(@game : Game, @confirming_player : Player)
    @errors = [] of String
  end

  def call
    if game.confirmed?
      @errors << "Game already confirmed"
      return false
    end

    if confirming_player_opposes_logger?
      game.confirmed_by_id = confirming_player.id
      game.confirmed_at = Time.now

      if game.save
        true
      else
        @errors += game.errors.map(&.to_s).compact
        false
      end
    else
      @errors << "Game must be confirmed by an opposing player"
      false
    end
  end

  private def confirming_player_opposes_logger?
    if winner_confirmed_game?
      game.losers.includes?(confirming_player)
    else
      game.winner == confirming_player
    end
  end

  private def winner_confirmed_game?
    game.confirmed_by == game.winner
  end
end
