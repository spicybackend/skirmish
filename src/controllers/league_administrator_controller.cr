class LeagueAdministratorController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
    # TODO Pull out league fetching and admin checking
  end

  def create
    if league = League.find(params[:league_id])
      if current_player.not_nil!.admin_of?(league)
        if player = Player.find(params[:player_id]?)
          Administrator.create!(league_id: league.id, player_id: player.id)

          flash[:success] = "#{player.tag} is now an admin of #{league.name}"
          redirect_to "/leagues/#{league.id}/management"
        else
          flash[:warning] = "Unable to find player"
          redirect_to "/leagues/#{league.id}/management"
        end
      else
        flash[:danger] = "Must be an admin of #{league.name} to manage it"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end

  def destroy
    if league = League.find(params[:league_id])
      if current_player.not_nil!.admin_of?(league)
        if player = Player.find(params[:id]?)
          if player.id != current_player.not_nil!.id
            if admin = Administrator.where { (_player_id == player.id) & (_league_id == league.id) }.first
              admin.destroy

              flash[:warning] = "#{player.tag} is no longer an admin of #{league.name}"
              redirect_to "/leagues/#{league.id}/management"
            else
              flash[:warning] = "#{player.tag} is not an admin of #{league.name}"
              redirect_to "/leagues/#{league.id}/management"
            end
          else
            flash[:warning] = "Can't remove yourself as an admin"
            redirect_to "/leagues/#{league.id}/management"
          end
        else
          flash[:warning] = "Unable to find player"
          redirect_to "/leagues/#{league.id}/management"
        end
      else
        flash[:danger] = "Must be an admin of #{league.name} to manage it"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end
end
