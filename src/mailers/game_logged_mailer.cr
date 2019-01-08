class GameLoggedMailer < ApplicationMailer
  def initialize(player : Player, game : Game)
    super()

    user = player.user!
    to(user.email!, player.tag.to_s)
    self.from = ApplicationMailer::FROM_GAMES

    logger = game.logger!
    confirmation_code = game.participations_query.where { _player_id == player.id }.pluck(:confirmation_code).first

    won = player == game.winner

    self.subject = I18n.translate("mailer.game_logged.subject", { logger: logger.tag })
    self.text = render("mailers/game_logged.text.ecr")
    self.html = render("mailers/game_logged.html.slang", "mailer_layout.html.slang")
  end
end
