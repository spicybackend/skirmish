require "../spec_helper"

describe Invitation::Accept do
  league = create_league
  player = create_player_with_mock_user
  approver = create_player_with_mock_user
  Administrator.create!(league_id: league.id, player_id: approver.id)

  create_and_accept_invite_service = -> do
    player.memberships_query.destroy

    invite = Invitation::Create.new(
      league: league,
      player: player,
      approver: approver
    ).call

    Invitation::Accept.new(
      invitation: invite,
      player: player
    ).call

    invite
  end

  it "accepts the invite" do
    invite = create_and_accept_invite_service.call

    invite.accepted?.should eq true
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

  context "when the invite has already been accepted" do
    it "raises an error" do
      invite = create_and_accept_invite_service.call

      expect_raises(Invitation::Accept::AcceptError, "Invite has already been accepted") do
        Invitation::Accept.new(
          invitation: invite,
          player: player
        ).call
      end
    end
  end

  context "when the player is already in the league" do
    it "raises an error" do
      invite = Invitation::Create.new(
        league: league,
        player: player,
        approver: approver
      ).call

      Membership.create!(player_id: player.id, league_id: league.id)

      expect_raises(Invitation::Accept::AcceptError, "#{player.tag} is already a member of #{league.name}") do
        Invitation::Accept.new(invitation: invite, player: player).call
      end
    end
  end
end
