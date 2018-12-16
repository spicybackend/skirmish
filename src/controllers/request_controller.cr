class RequestController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  # request an invite to the league
  def create
    if league = League.find(params[:league_id])
      if current_player.not_nil!.admin_of?(league)
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
        flash["danger"] = "Must be an admin to manage invites"
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
        Jennifer::Adapter.adapter.transaction do
          Invitation::Approve.new(invitation: invite, approver: current_player.not_nil!).call

          flash["success"] = "Invite approved"
          redirect_to "/leagues/#{invite.league_id}"
        rescue ex : Invitation::Approve::ApproveError
          flash["danger"] = ex.message.to_s
          redirect_to "/leagues/#{invite.league_id}"
        end
      else
        flash["danger"] = "Must be an admin to manage invites"
        redirect_to "/leagues/#{invite.league_id}"
      end
    else
      flash["danger"] = "Couldn't find league"
      redirect_to "/leagues"
    end
  end

  def destroy
    if invite = Invitation.find(params[:id])
      if current_player.not_nil!.admin_of?(invite.league!)
        Jennifer::Adapter.adapter.transaction do
          invite.destroy

          flash["success"] = "Invite deleted"
          redirect_to "/leagues/#{invite.league_id}/management"
        end
      else
        flash["danger"] = "Must be an admin to manage invites"
        redirect_to "/leagues/#{invite.league_id}"
      end
    else
      flash["danger"] = "Couldn't find league"
      redirect_to "/leagues"
    end
  end
end
