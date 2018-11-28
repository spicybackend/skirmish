class TournamentController < ApplicationController
  include ProfileHelper  # TODO Move this and tournament json methods outta here

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
          json json_tournament(tournament)
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
        tournament = Tournament::Open.new(league: league).call.not_nil!

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

  private def json_tournament(tournament : Tournament)
    {
      matches: tournament.matches.map { |match| hashed(match, tournament) },
      players: tournament.players.map { |player| hashed(player) }
    }.to_json
  end

  private def hashed(match : Match, tournament : Tournament)
    {
      id: match.id,
      level: match.level,
      player_a_id: match.player_a_id,
      player_b_id: match.player_b_id,
      winner_id: match.winner_id,
      next_match_id: match.next_match_id,
      url: match.game_id ? "/leagues/#{tournament.league_id}/games/#{match.game_id}" : "/leagues/#{match.tournament.not_nil!.league_id}/games/new"
    }
  end

  private def hashed(player : Player)
    {
      id: player.id,
      tag: player.tag,
      image_url: gravatar_src_for(player)
    }
  end
end
