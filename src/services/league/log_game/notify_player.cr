class League::LogGame::NotifyPlayer
  getter player, won, game, logger

  def initialize(@player : Player, @won : Bool, @game : Game, @logger : Player)
    @game = Game.new
    @errors = [] of String
  end

  def call!
    Notification.create!(
      player_id: player.id,
      event_type: Notification::GAME_LOGGED,
      title: title,
      content: content
    )
  end

  private def title
    "Game logged by #{logger.tag}"
  end

  private def content
    "Confirm your #{won ? "win" : "loss"} against #{logger.tag}."
  end
end
