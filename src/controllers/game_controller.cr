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
    game = Game.new(game_params.validate!)
    league = League.find(params["league_id"])

    if league
      if params[:status] == "won"
        winner_id = current_player.try(&.id)
        loser_id = params[:opponent_id].to_i64
      else
        loser_id = current_player.try(&.id)
        winner_id = params[:opponent_id].to_i64
      end

      game.winner_id = winner_id

      if game.valid? && game.save
        Participation.create!(
          game_id: game.id,
          player_id: winner_id,
          winner: true
        )

        Participation.create!(
          game_id: game.id,
          player_id: loser_id,
          winner: false
        )

        flash["success"] = "Created game successfully."
        redirect_to "/leagues/#{game.league_id}/games/#{game.id}"
      else
        other_players = league.active_players.reject { |player| player == current_player }

        flash["danger"] = "Could not create game! #{game.errors.to_s}"
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
    params[:opponent_id] = params["opponent-id"]

    params.validation do
      required(:league_id) { |f| !f.nil? }
      required(:opponent_id) { |f| !f.blank? }
      required(:status) { |f| !f.blank? }
    end
  end
end
