class Game::Confirm
  getter :game, :confirming_player

  def initialize(@game : Game, @confirming_player : Player)
  end

  def call
    game.confirmed_by_id = confirming_player.id
    game.confirmed_at = Time.now
    game.save
  end
end
