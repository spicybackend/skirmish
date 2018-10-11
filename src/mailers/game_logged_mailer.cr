class GameLoggedMailer < ApplicationMailer
  def initialize(player : Player, game : Game)
    super()

    to(
      player.user!.email.not_nil!,
      player.tag.not_nil!
    )

    logger = game.logged_by!
    self.subject = "#{logger.tag} has logged a game with you"
    self.text = render("mailers/game_logged.text.ecr")
    self.html = render("mailers/game_logged.html.slang", "mailer_layout.html.slang")
  end
end
