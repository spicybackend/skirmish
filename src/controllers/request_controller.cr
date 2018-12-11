class RequestController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  # request an invite to the league
  def create
    if league = League.find(params[:league_id])
      Jennifer::Adapter.adapter.transaction do
        Invitation::Create.new(
          league: league,
          player: current_player.not_nil!
        ).call
      rescue ex : Invitation::Create::InviteError
        flash["danger"] = ex.message.to_s
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash["danger"] = "Couldn't find league"
      redirect_to "/leagues"
    end
  end

  # admin approving a request
  def update
    if invite = Invitation.find(params[:id])
      if current_player.not_nil!.admin_of?(invite.league!)

        # check it hasn't already been approved
        invite.update!(approved_at: Time.now)

        # check they aren't already a member
        Membership.create!(player_id: invite.player_id, league_id: invite.league_id)

        # pull all the above into a service?

        flash["success"] = "Invite approved"
        redirect_to "/leagues/#{invite.league_id}"
      else
        flash["danger"] = "Must be an admin to approve invites"
        redirect_to "/leagues/#{invite.league_id}"
      end
    else
      flash["danger"] = "Couldn't find league"
      redirect_to "/leagues"
    end
  end
end
