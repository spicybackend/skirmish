class Game::CanBeConfirmedByPlayer
  getter :game, :player

  def initialize(@game : Game, @player : Player)
  end

  def call
    game_not_confirmed? && player_opposes_game_logger?
  end

  private def game_not_confirmed?
    !game.confirmed?
  end

  private def player_opposes_game_logger?
    if game_logged_by_winner?
      game.loser.id == player.id
    else
      game.winner.id == player.id
    end
  end

  private def game_logged_by_winner?
    game.logged_by_id == game.winner.id
  end
end
