require "../spec_helper"

describe Invitation::Create do
  league = create_league
  player = create_player_with_mock_user
  approver = create_player_with_mock_user
  Administrator.create!(league_id: league.id, player_id: approver.id)

  create_invite_service = -> do
    Invitation::Create.new(
      league: league,
      player: player
    ).call
  end

  it "creates an invite" do
    existing_invite_count = Invitation.all.count
    create_invite_service.call

    Invitation.all.count.should eq existing_invite_count.succ
  end

  context "when the invite has already been created" do
    context "by an admin inviting a player" do
      create_invite_service = -> do
        Invitation::Create.new(
          league: league,
          player: player,
          approver: approver
        ).call
      end

      it "raises an error" do
        create_invite_service.call

        expect_raises(Invitation::Create::InviteError, "#{player.tag} has already been invited to join #{league.name}") do
          create_invite_service.call
        end
      end
    end

    context "by a player requesting the invite" do
      create_invite_service = -> do
        Invitation::Create.new(
          league: league,
          player: player
        ).call
      end

      it "raises an error" do
        create_invite_service.call

        expect_raises(Invitation::Create::InviteError, "#{player.tag} has already requested to join #{league.name}") do
          create_invite_service.call
        end
      end
    end
  end

  context "when the player is already in the league" do
    it "raises an error" do
      Membership.create!(player_id: player.id, league_id: league.id)

      expect_raises(Invitation::Create::InviteError, "#{player.tag} is already a member of #{league.name}") do
        create_invite_service.call
      end
    end
  end

  describe "the created invite" do
    it "is associated with the player and league" do
      invite = create_invite_service.call.not_nil!

      invite.player_id.should eq player.id
      invite.league_id.should eq league.id
    end

    it "is not approved" do
      invite = create_invite_service.call.not_nil!

      invite.approver.should eq nil
      invite.approved_at.should eq nil
    end

    it "is accepted" do
      invite = create_invite_service.call.not_nil!

      invite.accepted_at.should_not eq nil
    end
  end

  context "creating an invite with an approver" do
    create_invite_service = -> do
      Invitation::Create.new(
        league: league,
        player: player,
        approver: approver
      ).call
    end

    it "is associated with the player and league" do
      invite = create_invite_service.call.not_nil!

      invite.player_id.should eq player.id
      invite.league_id.should eq league.id
    end

    it "is approved by the approver" do
      invite = create_invite_service.call.not_nil!

      invite.approver.should eq approver
      invite.approved_at.should_not eq nil
    end

    it "is not accepted" do
      invite = create_invite_service.call.not_nil!

      invite.accepted_at.should eq nil
    end

    context "and the approver isn't an admin" do
      approver = create_player_with_mock_user

      it "raises an error" do
        expect_raises(Invitation::Create::InviteError, "#{approver.tag} must be an admin of #{league.name} to approve invites") do
          create_invite_service.call
        end
      end
    end
  end
end
