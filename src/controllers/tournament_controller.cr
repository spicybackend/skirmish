class TournamentController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
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
    # TODO
  end
end
