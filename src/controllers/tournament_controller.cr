class TournamentController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def show
    if league = League.find(params[:league_id])
      if tournament = Tournament.find(params[:id])
        current_entrant = tournament.entrants_query.where { _player_id == current_player.try(&.id) }.first
        render("show.slang")
      else
        flash[:danger] = "Unable to find tournament"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/"
    end
  end

  def new
    if league = League.find(params[:league_id])
      tournament = Tournament.build

      render("new.slang")
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/"
    end
  end

  def create
    if league = League.find(params[:league_id])
      begin
        tournament = Tournament::CreateTournament.new(league: league).call.not_nil!

        redirect_to "/leagues/#{league.id}/tournaments/#{tournament.id}"
      rescue exception : Tournament::CreateTournament::TournamentCreationError
        tournament = Tournament.build(league_id: league.id)

        flash[:danger] = exception.message.to_s
        render("new.slang")
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/"
    end
  end
end
