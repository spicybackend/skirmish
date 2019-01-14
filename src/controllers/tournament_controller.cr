class TournamentController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def index
    if league = League.find(params[:league_id])
      tournaments = league.tournaments_query.order(created_at: :desc).to_a
      render("index.slang")
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end

  def show
    if league = League.find(params[:league_id])
      # strip the format from the id
      tournament_id = params[:id].gsub(/\..*/, "")

      if tournament = Tournament.find(tournament_id)
        current_entrant = tournament.entrants_query.where { _player_id == current_player.try(&.id) }.first

        respond_with do
          html render("show.slang")
          json tournament.to_h.to_json
        end
      else
        flash[:danger] = "Unable to find tournament"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end

  def new
    if league = League.find(params[:league_id])
      tournament = Tournament.build

      render("new.slang")
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end

  def create
    if league = League.find(params[:league_id])
      begin
        tournament = Tournament::Open.new(
          league: league,
          invite_content: sanitize_invite_content(params["invite"]?)
        ).call.not_nil!

        flash[:success] = "The new tournament is open for entry"
        redirect_to "/leagues/#{league.id}/tournaments/#{tournament.id}"
      rescue ex : Tournament::Open::OpenError
        tournament = Tournament.build(league_id: league.id)

        flash[:danger] = ex.message.to_s
        render("new.slang")
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end

  def start
    if league = League.find(params[:league_id])
      if tournament = Tournament.find(params[:id])
        begin
          Tournament::Start.new(tournament: tournament).call

          flash[:success] = "The tournament has been started!"
          redirect_to "/leagues/#{league.id}/tournaments/#{tournament.id}"
        rescue ex : Tournament::Start::StartError
          flash[:danger] = ex.message.to_s
          redirect_to "/leagues/#{league.id}/tournaments/#{tournament.id}"
        end
      else
        flash[:danger] = "Unable to find tournament"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end

  def destroy
    if league = League.find(params[:league_id])
      if tournament = Tournament.find(params[:id])
        Jennifer::Adapter.adapter.transaction do
          tournament.matches_query.destroy
          tournament.entrants_query.destroy
          tournament.destroy
        end

        flash[:success] = "The tournament was destroyed"
        redirect_to "/leagues/#{league.id}"
      else
        flash[:danger] = "Unable to find tournament"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash[:danger] = "Unable to find league"
      redirect_to "/leagues"
    end
  end

  private def sanitize_invite_content(content)
    return unless content

    content.blank? ? nil : content
  end
end
