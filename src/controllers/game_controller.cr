class GameController < ApplicationController
  before_action do
    all do
      redirect_to(
        location: "/signin",
        status: 302
      ) unless current_player
    end
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

      render("new.slang")
    else
      flash["danger"] = "Can't find league"
      redirect_to "/leagues"
    end
  end

  def create
    game = Game.new(game_params.validate!)
    league = League.find(params["league_id"])

    if league
      if game.valid? && game.save
        flash["success"] = "Created game successfully."
        redirect_to "/leauges/#{game.league_id}/games/#{game.id}"
      else
        other_players = league.active_players.reject { |player| player == current_player }

        flash["danger"] = "Could not create game!"
        render("new.slang")
      end
    else
      flash["danger"] = "Can't find league"
      redirect_to "/leagues"
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
      required(:winner_id) { |f| !f.nil? }
    end
  end
end
