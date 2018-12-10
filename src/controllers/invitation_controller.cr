class InvitationController < ApplicationController
  before_action do
    all { redirect_signed_out_user }
  end

  def new
    if league = League.find(params[:league_id])
      players = Player.all.where { sql("id != all (#{league.players_query.pluck(:id).join(",")})") }
    else
      flash["danger"] = "Couldn't find league"
      redirect_to "/leagues"
    end
  end

  # sent an invite to join the league to another player
  def create
    if league = League.find(params[:league_id])
      if player = Player.where { _tag == params[:tag] }.first
        Jennifer::Adapter.adapter.transaction do
          Invitation::Create.new(
            league: league,
            player: player,
            approver: current_player.not_nil!
          ).call
        rescue ex : Invitation::Create::InviteError
          flash["danger"] = ex.message.to_s
          redirect_to "/leagues/#{league.id}"
        end
      else
        flash["danger"] = "Couldn't find a player called '#{params[:tag]}'"
        redirect_to "/leagues/#{league.id}"
      end
    else
      flash["danger"] = "Couldn't find league"
      redirect_to "/leagues"
    end
  end

  # player confirming an invitation
  def update
    if invite = Invitation.find(params[:id])
      if invite.player_id == current_player.not_nil!.id
        invite.update!(accepted_at: Time.now)

        # check not already confirmed

        # check not already in the league

        # pull into service. Shared with request controller and some option for invite/request?

        flash["success"] = "Invite accepted"
        redirect_to "/leagues/#{invite.league_id}"
      else
        flash["danger"] = "Invite belongs to someone else"
        redirect_to "/leagues/#{invite.league_id}"
      end
    else
      flash["danger"] = "Couldn't find league"
      redirect_to "/leagues"
    end
  end
end
