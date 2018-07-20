class MembershipController < ApplicationController
  def create
    if league_id = params["league_id"]
      if player = Player.find_by(user_id: session[:user_id])
        membership = Membership.new(membership_params.validate!)
        membership.player = player
        membership.joined_at = Time.now

        if membership.valid? && membership.save
          flash["success"] = "Created membership successfully."
          redirect_to "/leagues/#{league_id}"
        else
          flash["danger"] = "Could not create membership! #{membership.errors}"
          redirect_to "/leagues/#{league_id}"
        end
      else
        flash["danger"] = "Must be logged in to join leagues"
        redirect_to "/leagues/#{league_id}"
      end
    else
      flash["danger"] = "League doesn't exist"
      redirect_to "/leagues"
    end
  end

  def update
    if league = League.find(params["league_id"])
      if player = current_user.try(&.player)
        if membership = Membership.find_by(player_id: player.id, league_id: league.id)
          if membership.update(left_at: leaving? ? Time.now : nil)
            flash["success"] = "Membership updated"
          else
            flash["danger"] = "Couldn't update membership. #{membership.errors.map(&.message)}"
          end

          redirect_to "/leagues/#{league.id}"
        else
          flash["danger"] = "Couldn't find your membership"
          redirect_to "leagues/#{league.id}"
        end
      else
        flash["danger"] = "Must be logged in"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash["danger"] = "League doesn't exist"
      redirect_to "/leagues"
    end
  end

  def membership_params
    params.validation do
      required(:league_id) { |f| !f.nil? }
    end
  end

  private def leaving?
    params["leave_or_join"] == "leave"
  end

  private def rejoining?
    params["leave_or_join"] == "join"
  end
end
