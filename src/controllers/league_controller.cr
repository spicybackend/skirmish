class LeagueController < ApplicationController
  include PlayerContextHelper

  before_action do
    only [:show, :new, :create, :edit, :update, :destroy] { redirect_signed_out_user }
  end

  def index
    leagues = League.all.left_join(Membership) { League._id == _league_id }
      .select("leagues.*, COUNT(memberships.league_id) as membership_count")
      .where { Membership._left_at == nil }
      .group("leagues.id")
      .order { { "membership_count" => :desc } }

    render("index.slang")
  end

  def show
    if league = League.find(params[:id])
      player = current_player.not_nil!

      membership = player.memberships_query.where { _league_id == league.id }.to_a.first? || Membership.build
      tournament = Tournament.for_league(league).order(created_at: :desc).first

      render("show.slang")
    else
      flash["warning"] = "Can't find league"
      redirect_to "/leagues"
    end
  end

  def new
    league = League.build({
      name: ""
    })

    render("new.slang")
  end

  def create
    league = League.new({
      name: params[:name],
      description: params[:description],
      accent_color: params[:accent_color],
      start_rating: params[:start_rating].to_i,
      k_factor: params[:k_factor].to_f,
    })

    if league.valid? && league.save
      Administrator.create!(
        player_id: current_player.not_nil!.id,
        league_id: league.id
      )

      flash["success"] = "Created League successfully."
      redirect_to "/leagues/#{league.id}"
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
      league.update_attributes({
        name: params[:name],
        description: params[:description],
        accent_color: params[:accent_color],
        start_rating: params[:start_rating].to_i,
        k_factor: params[:k_factor].to_f,
      })

      if league.valid? && league.save
        flash["success"] = "Updated League successfully."
        redirect_to "/leagues/#{league.id}"
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
    Jennifer::Adapter.adapter.transaction do
      if league = League.find params["id"]
        league.administrators_query.destroy
        league.destroy
      else
        flash["warning"] = "League with ID #{params["id"]} Not Found"
      end
    end

    redirect_to "/leagues"
  end
end
