class MembershipController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def create
    player = current_player.not_nil!
    league = League.find(params[:league_id])

    if !league
      flash["danger"] = "Can't find league."
      redirect_to "/leagues"; return
    end

    if league && player.in_league?(league)
      flash["danger"] = "Membership already exists."
      redirect_to "/leagues/#{params[:league_id]}"; return
    end

    membership = Membership.build(
      league_id: league.id,
      player_id: player.id,
      joined_at: Time.now
    )

    if membership.valid? && membership.save
      flash["success"] = "Created membership successfully."
      redirect_to "/leagues/#{membership.league_id}"
    else
      flash["danger"] = "Could not create membership! #{membership.errors.full_messages}"
      redirect_to "/leagues/#{membership.league_id}"
    end
  end

  def update
    player = current_player.not_nil!
    league_id = params[:league_id]

    if membership = player.memberships_query.where { _league_id == league_id }.to_a.first
      if membership.update(left_at: leaving? ? Time.now : nil)
        flash["success"] = "Membership updated"
      else
        flash["danger"] = "Couldn't update membership. #{membership.errors.full_messages}"
      end

      redirect_to "/leagues/#{league_id}"
    else
      flash["danger"] = "Couldn't find your membership"
      redirect_to "leagues/#{league_id}"
    end
  end

  private def membership_params
    params.validation do
      required(:league_id) { |f| !f.nil? }
    end
  end

  private def leaving?
    params[:leave_or_join] == "leave"
  end

  private def rejoining?
    params[:leave_or_join] == "join"
  end
end
