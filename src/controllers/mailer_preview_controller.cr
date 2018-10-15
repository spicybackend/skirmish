class MailerPreviewController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def show
    if params[:mailer_name] == "welcome"
      player = current_player.not_nil!
      user = player.user!

      if params[:version] == "text"
        render("mailers/welcome.text.ecr")
      else
        render("mailers/welcome.html.slang", layout: "mailer_layout.html.slang")
      end
    elsif params[:mailer_name] == "game_logged"
      game = Game.all.last.not_nil!
      player = game.loser.not_nil!
      user = player.user!
      logger = game.winner.not_nil!

      if params[:version] == "text"
        render("mailers/game_logged.text.ecr")
      else
        render("mailers/game_logged.html.slang", layout: "mailer_layout.html.slang")
      end
    else
      flash["warning"] = "Can't find mailer"
      redirect_to "/"
    end
  end
end
