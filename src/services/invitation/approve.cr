class Invitation::Approve
  getter :invitation, :approver

  class ApproveError < Exception; end

  def initialize(invitation : Invitation, approver : Player)
    @invitation = invitation
    @approver = approver

    @league = invitation.league!
    @player = invitation.player!
  end

  def call
    assert_invite_not_already_approved!
    assert_player_not_already_in_league!
    assert_approver_is_an_admin!

    Jennifer::Adapter.adapter.transaction do
      invitation.update!(approved_at: Time.now, approver_id: approver.id)

      GeneralNotification.create(
        player_id: player.id,
        title: "Invite request approved",
        content: "#{approver.tag} has approved your request to join #{league.name}",
        sent_at: Time.now
      )

      Membership.create!(league_id: invitation.league_id, player_id: invitation.player_id)
    end
  end

  private getter league : League, player : Player

  private def assert_invite_not_already_approved!
    if invitation.approved?
      raise ApproveError.new("Invite has already been approved")
    end
  end

  private def assert_player_not_already_in_league!
    if player.in_league?(league)
      raise ApproveError.new("#{player.tag} is already a member of #{league.name}")
    end
  end

  private def assert_approver_is_an_admin!
    return unless approving_player = approver

    if !approving_player.admin_of?(league)
      raise ApproveError.new("#{approving_player.tag} must be an admin of #{league.name} to approve invites")
    end
  end
end
