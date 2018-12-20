require "./spec_helper"

describe AuthProvider do
  user = create_player_with_mock_user.user!

  build_new_auth_provider = -> do
    AuthProvider.build(
      provider: AuthProvider::GOOGLE_PROVIDER,
      token: "abc123"
    )
  end

  describe "validations" do
    describe "provider" do
      it "must be present" do
        auth_provider = build_new_auth_provider.call

        auth_provider.provider = ""
        auth_provider.valid?.should be_false

        auth_provider.provider = AuthProvider::GOOGLE_PROVIDER
        auth_provider.valid?.should be_true
      end

      it "must be an available provider" do
        auth_provider = build_new_auth_provider.call

        auth_provider.provider = "skirmish_auth"
        auth_provider.valid?.should be_false

        auth_provider.provider = "oauth"
        auth_provider.valid?.should be_false

        auth_provider.provider = AuthProvider::GOOGLE_PROVIDER
        auth_provider.valid?.should be_true
      end
    end

    describe "token" do
      it "must be present" do
        auth_provider = build_new_auth_provider.call

        auth_provider.token = ""
        auth_provider.valid?.should be_false

        auth_provider.token = "abc123"
        auth_provider.valid?.should be_true
      end
    end
  end

  describe "scopes" do
    linked_auth_provider = build_new_auth_provider.call
    linked_auth_provider.add_user(user)
    linked_auth_provider.save!

    unlinked_auth_provider = build_new_auth_provider.call
    unlinked_auth_provider.token = "somethingelse"
    unlinked_auth_provider.save!

    describe "linked" do
      it "only includes auth providers linked to users" do
        AuthProvider.linked.pluck(:id).should contain linked_auth_provider.id
        AuthProvider.linked.pluck(:id).should_not contain unlinked_auth_provider.id
      end
    end

    describe "unlinked" do
      it "only includes auth providers that aren't linked to users" do
        AuthProvider.unlinked.pluck(:id).should_not contain linked_auth_provider.id
        AuthProvider.unlinked.pluck(:id).should contain unlinked_auth_provider.id
      end
    end
  end
end
