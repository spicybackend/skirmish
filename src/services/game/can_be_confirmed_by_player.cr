class Game::CanBeConfirmedByPlayer
  getter :game, :player, :include_admin

  def initialize(@game : Game, @player : Player, @include_admin : Bool = true)
  end

  def call
    game_not_confirmed? && (player_opposes_game_logger? || admin_confirmation?)
  end

  private def admin_confirmation?
    include_admin && player.admin_of?(game.league!)
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
