require "./notification"

class GameLoggedNotification < Notification
  mapping(
    source_type: String,
    source_id: Int64
  )

  def title
    if won?
      "Nice job taking down #{logger.tag}!"
    else
      "Ouch, #{logger.tag} has logged your loss"
    end
  end

  def content
    if won?
      "Steal #{logger.tag}'s points by confirming your win."
    else
      "Don't be too salty, confirm your game against #{logger.tag} and plot your revenge."
    end
  end

  def action_url
    "/leagues/#{league.id}/games/#{game.id}"
  end

  def color
    league.accent_color
  end

  def icon_url
    league.icon_url
  end

  def custom_icon?
    league.custom_icon?
  end

  private def game
    Game.find(source_id).not_nil!
  end

  private def league
    game.league!
  end

  private def logger
    game.logger!
  end

  private def won?
    game.winner.id == player_id
  end
end
