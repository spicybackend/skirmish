class Invitation::Create
  getter :league, :player, :approver

  class InviteError < Exception; end

  def initialize(league : League, player : Player, approver : Player | Nil = nil)
    @league = league
    @player = player
    @approver = approver
  end

  def call
    assert_player_not_already_in_league!
    assert_invite_not_already_created!
    assert_approver_is_an_admin!

    Invitation.create!(
      league_id: league.id,
      player_id: player.id,
      approver_id: approver.try(&.id),
      approved_at: approver ? Time.now : nil,
      accepted_at: approver ? nil : Time.now,
    )
  end

  private def assert_player_not_already_in_league!
    if player.in_league?(league)
      raise InviteError.new("#{player.tag} is already a member of #{league.name}")
    end
  end

  private def assert_invite_not_already_created!
    if invite = Invitation.where { (_league_id == league.id) & (_player_id == player.id) }.first
      if invite.approved?
        raise InviteError.new("#{player.tag} has already been invited to join #{league.name}")
      else
        raise InviteError.new("#{player.tag} has already requested to join #{league.name}")
      end
    end
  end

  private def assert_approver_is_an_admin!
    return unless approving_player = approver

    if !approving_player.admin_of?(league)
      raise InviteError.new("#{approving_player.tag} must be an admin of #{league.name} to approve invites")
    end
  end
end
