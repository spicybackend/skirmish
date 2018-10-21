class GameLoggedMailer < ApplicationMailer
  def initialize(player : Player, game : Game)
    super()

    user = player.user!
    to(user.email!, player.tag.to_s)
    self.from = ApplicationMailer::FROM_GAMES

    logger = game.logger!
    self.subject = "#{logger.tag} has logged a game with you"
    self.text = render("mailers/game_logged.text.ecr")
    self.html = render("mailers/game_logged.html.slang", "mailer_layout.html.slang")
  end
end
