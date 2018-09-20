class League::LogGame::NotifyPlayer
  getter player, won, game, logger

  def initialize(@player : Player, @won : Bool, @game : Game, @logger : Player)
  end

  def call!
    Notification.new.tap do |notification|
      notification.player_id = player.id
      notification.event_type = Notification::GAME_LOGGED
      notification.title = title
      notification.content = content
      notification.source = game
      notification.save!
    end

    GameLoggedMailer.new(player, game).send if player.user.receive_email_notifications?
  end

  private def title
    I18n.translate("game.notifications.game_logged.title")
  end

  private def content
    I18n.translate("game.notifications.game_logged.content")
  end
end
