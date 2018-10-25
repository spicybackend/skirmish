class GameController < ApplicationController
  CONFIRM_ACTION = "confirm"

  before_action do
    all { redirect_signed_out_user }
  end

  def show
    if game = Game.find(params[:id])
      show_game_confirmation = false

      if player = current_player
        show_game_confirmation = Game::CanBeConfirmedByPlayer.new(
          game: game,
          player: player
        ).call
      end

      league = game.league!
      winner_rating = game.winner.rating_for(league)
      loser_rating = game.loser.rating_for(league)

      if !game.confirmed?
        # calculate point increase for display
        new_winner_rating = Rating::DetermineNewRating.new(
          old_rating: winner_rating,
          other_rating: loser_rating,
          won: true,
          league: game.league!
        ).call

        new_loser_rating = Rating::DetermineNewRating.new(
          old_rating: loser_rating,
          other_rating: winner_rating,
          won: false,
          league: game.league!
        ).call

        winner_delta = (new_winner_rating - winner_rating).abs
        loser_delta = (new_loser_rating - loser_rating).abs
      end

      render("show.slang")
    else
      flash["warning"] = "Can't find game"
      redirect_to "/leagues/#{params[:league_id]}"
    end
  end

  def new
    game = Game.build
    league = League.find(params[:league_id])

    if league
      other_players = league.active_players.to_a.reject { |player| player == current_player }

      if other_players.empty?
        flash["warning"] = "There are no other players to log against"
        redirect_to "/leagues/#{league.id}"
      else
        render("new.slang")
      end
    else
      flash["danger"] = "Can't find league"
      redirect_to "/leagues"
    end
  end

  def create
    player = current_player.not_nil!
    league = League.find(params[:league_id])
    other_player = Player.find(params["opponent-id"])

    unless league
      flash["danger"] = "Can't find league"
      redirect_to("/leagues"); return
    end

    unless other_player
      flash["danger"] = "Can't find opponent"
      other_players = league.active_players.to_a.reject { |other| other == player }
      render("new.slang"); return
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
      other_players = league.active_players.to_a.reject { |other| other == player }

      render("new.slang")
    end
  end

  def update
    action = params[:action]
    game = Game.find(params[:game_id])

    unless game
      flash["danger"] = "Can't find game"

      if league = League.find(params[:league_id])
        redirect_to("/leagues/#{league.id}"); return
      else
        redirect_to("/leagues"); return
      end
    end

    case action
    when CONFIRM_ACTION
      confirming_player = current_player.not_nil!
      game_confirmation_service = Game::Confirm.new(
        game: game,
        confirming_player: confirming_player
      )

      if game_confirmation_service.call
        flash["success"] = "Confirmed game"
        redirect_to("/leagues/#{game.league_id}/games/#{game.id}"); return
      else
        flash["danger"] = game_confirmation_service.errors.join(", ")
        redirect_to("/leagues/#{game.league_id}/games/#{game.id}"); return
      end
    else
      flash["danger"] = "Unknown update action"
      redirect_to("/leagues/#{game.league_id}/games/#{game.id}"); return
    end
  end

  def destroy
    if game = Game.find params[:id]
      league = game.league!

      if game.unconfirmed?
        Jennifer::Adapter.adapter.transaction do
          game.participations.each { |participation| participation.destroy }
          Notification.where { _source_type == "Game" && _source_id == game.id }.destroy

          game.destroy

          flash["success"] = "Game deleted successfully"
          redirect_to "/leagues/#{league.id}"
        end
      else
        flash["warning"] = "Can't delete confirmed games"
        redirect_to "/leagues/#{league.id}/games/#{game.id}"
      end
    else
      flash["warning"] = "Can't find game"
      redirect_to "/"
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
