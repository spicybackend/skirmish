class Notification::LoggedGamePresenter
  getter notification

  property game : Game

  delegate id, read?, read_at, to: notification

  def initialize(@notification : Notification)
    @game = notification.source.not_nil!
  end

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
    "leagues/#{game.league.id}/games/#{game.id}"
  end

  private def logger
    game.logged_by.not_nil!
  end

  private def won?
    game.winner.id == notification.player_id
  end
end
