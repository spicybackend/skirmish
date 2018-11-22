class EntrantController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def create
    if league = League.find(params[:league_id])
      if tournament = Tournament.find(params[:tournament_id])
        if current_player.try(&.in_league?(league: league))
          Entrant.create!(player_id: current_player.not_nil!.id, tournament_id: tournament.id)

          flash[:success] = "Entered the #{league.name} tournament"
          redirect_to "/leagues/#{league.id}/tournaments/#{tournament.id}"
        else
          flash[:danger] = "Must be a member of #{league.name} to join it's tournament"
          redirect_to "/leagues/#{league.id}"
        end
      else
        flash[:danger] = "Unable to find tournament"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/"
    end
  end

  def destroy
    if tournament = Tournament.find(params[:tournament_id])
      if entrant = tournament.entrants_query.where { _player_id == current_player.not_nil!.try(&.id) }.first
        if tournament.open?
          entrant.destroy

          flash[:success] = "Left the tournament"
          redirect_to "/leagues/#{tournament.league_id}/tournaments/#{tournament.id}"
        else
          flash[:danger] = "Can't leave a tournament that has started"
          redirect_to "/leagues/#{tournament.league_id}/tournaments/#{tournament.id}"
        end
      else
        flash[:warning] = "You're not currently entered in the tournament"
        redirect_to "/leagues/#{tournament.league_id}/tournaments/#{tournament.id}"
      end
    else
      flash[:danger] = "Unable to find tournament"
      redirect_to "/"
    end
  end
end
