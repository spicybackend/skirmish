class MembershipController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def create
    player = current_player.not_nil!

    if Membership.find_by(player_id: player.id, league_id: params[:league_id])
      flash["danger"] = "Membership already exists."
      redirect_to "/leagues/#{params[:league_id]}"; return
    end

    membership = Membership.new(membership_params.validate!)
    membership.player = player
    membership.joined_at = Time.now

    if membership.valid? && membership.save
      flash["success"] = "Created membership successfully."
      redirect_to "/leagues/#{membership.league_id}"
    else
      flash["danger"] = "Could not create membership! #{membership.errors}"
      redirect_to "/leagues/#{membership.league_id}"
    end
  end

  def update
    player = current_player.not_nil!
    league_id = params[:league_id]

    if membership = Membership.find_by(player_id: player.id, league_id: league_id)
      if membership.update(left_at: leaving? ? Time.now : nil)
        flash["success"] = "Membership updated"
      else
        flash["danger"] = "Couldn't update membership. #{membership.errors.map(&.message)}"
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
