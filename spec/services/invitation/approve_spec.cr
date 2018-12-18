require "../spec_helper"

describe Invitation::Approve do
  league = create_league
  player = create_player_with_mock_user
  approver = create_player_with_mock_user
  Administrator.create!(league_id: league.id, player_id: approver.id)

  create_and_accept_invite_service = -> do
    player.memberships_query.destroy

    invite = Invitation::Create.new(
      league: league,
      player: player
    ).call.not_nil!

    Invitation::Approve.new(
      invitation: invite,
      approver: approver
    ).call

    invite
  end

  it "approves the invite" do
    invite = create_and_accept_invite_service.call

    invite.approved?.should eq true
  end

  it "creates a membership" do
    initial_membership_count = Membership.all.count
    invite = create_and_accept_invite_service.call

    Membership.all.count.should eq initial_membership_count.succ
  end

  describe "the created membership" do
    it "is associated to the player and league" do
      invite = create_and_accept_invite_service.call

      membership = Membership.all.last!
      membership.league_id.should eq league.id
      membership.player_id.should eq player.id
    end
  end

  context "when the invite has already been approved" do
    it "raises an error" do
      invite = create_and_accept_invite_service.call

      expect_raises(Invitation::Approve::ApproveError, "Invite has already been approved") do
        Invitation::Approve.new(
          invitation: invite,
          approver: approver
        ).call
      end
    end
  end

  context "when the player is already in the league" do
    it "raises an error" do
      invite = Invitation::Create.new(
        league: league,
        player: player
      ).call.not_nil!

      Membership.create!(player_id: player.id, league_id: league.id)

      expect_raises(Invitation::Approve::ApproveError, "#{player.tag} is already a member of #{league.name}") do
        Invitation::Approve.new(invitation: invite, approver: approver).call
      end
    end
  end

  context "when the approver isn't an admin" do
    approver = create_player_with_mock_user

    it "raises an error" do
      expect_raises(Invitation::Approve::ApproveError, "#{approver.tag} must be an admin of #{league.name} to approve invites") do
        create_and_accept_invite_service.call
      end
    end
  end
end
