class LeagueController < ApplicationController
  before_action do
    only [:new, :create, :edit, :update, :destroy] { redirect_signed_out_user }
  end

  def index
    leagues = League.all
    render("index.slang")
  end

  def show
    if league = League.find(params["id"])
      player = current_user.try(&.player)
      membership = Membership.find_by(
        player_id: player.try(&.id),
        league_id: league.id
      ) || Membership.new

      render("show.slang")
    else
      flash["warning"] = "Can't find league"
      redirect_to "/leagues"
    end
  end

  def new
    league = League.new
    render("new.slang")
  end

  def create
    league = League.new(league_params.validate!)

    if league.valid? && league.save
      flash["success"] = "Created League successfully."
      redirect_to "/leagues"
    else
      flash["danger"] = "Could not create League!"
      render("new.slang")
    end
  end

  def edit
    if league = League.find params["id"]
      render("edit.slang")
    else
      flash["warning"] = "League with ID #{params["id"]} Not Found"
      redirect_to "/leagues"
    end
  end

  def update
    if league = League.find(params["id"])
      league.set_attributes(league_params.validate!)
      if league.valid? && league.save
        flash["success"] = "Updated League successfully."
        redirect_to "/leagues"
      else
        flash["danger"] = "Could not update League!"
        render("edit.slang")
      end
    else
      flash["warning"] = "League with ID #{params["id"]} Not Found"
      redirect_to "/leagues"
    end
  end

  def destroy
    if league = League.find params["id"]
      league.destroy
    else
      flash["warning"] = "League with ID #{params["id"]} Not Found"
    end
    redirect_to "/leagues"
  end

  def league_params
    params.validation do
      required(:name) { |f| !f.nil? }
      required(:description) { |f| !f.nil? }
      required(:start_rating) { |f| !f.nil? }
      required(:k_factor) { |f| !f.nil? }
    end
  end
end
