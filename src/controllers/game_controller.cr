class GameController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def show
    if game = Game.find(params["id"])
      render("show.slang")
    else
      flash["warning"] = "Can't find game"

      if league = League.find(params["league_id"])
        redirect_to "/leagues/#{league.id}"
      else
        redirect_to "/leagues"
      end
    end
  end

  def new
    game = Game.new
    league = League.find(params["league_id"])

    if league
      other_players = league.active_players.reject { |player| player == current_player }

      if other_players.empty?
        flash["warning"] = "There are no other players to log against"
        redirect_to(
          location: "/leagues/#{league.id}",
          status: 302
        ) && return
      end

      render("new.slang")
    else
      flash["danger"] = "Can't find league"
      redirect_to "/leagues"
    end
  end

  def create
    return unless player = current_player

    league = League.find(params[:league_id].to_i64)
    other_player = Player.find(params["opponent-id"].to_i64)

    unless league
      flash["danger"] = "Can't find league"
      redirect_to("/leagues"); return
    end

    unless other_player
      flash["danger"] = "Can't find opponent"
      other_players = league.active_players.reject { |other_player| other_player == player }
      render("new.slang")
      return
    end

    winner, loser = params[:status] == "won" ? [player, other_player] : [other_player, player]

    game_logger = League::LogGame.new(
      winner: winner,
      loser: loser,
      league: league,
      logger: player
    )

    if game_logger.call
      game = game_logger.game

      flash["success"] = "Game logged."
      redirect_to "/leagues/#{league.id}/games/#{game.id}"
    else
      flash["danger"] = game_logger.errors.to_s
      other_players = league.active_players.reject { |other_player| other_player == player }
      render("new.slang")
    end
  end

  def destroy
    if game = Game.find params["id"]
      game.destroy
    else
      flash["warning"] = "Can't find game"
    end

    if league = League.find(params["league_id"])
      redirect_to "/leagues/#{league.id}"
    else
      redirect_to "/leagues"
    end
  end

  def game_params
    params.validation do
      required(:league_id) { |f| !f.nil? }
      required("opponent-id") { |f| !f.blank? }
      required(:status) { |f| !f.blank? }
    end
  end
end
