require "./spec_helper"

describe AuthProvider do
  user = create_player_with_mock_user.user!

  describe "validations" do
    build_new_auth_provider = -> do
      AuthProvider.build(
        user_id: user.id,
        provider: AuthProvider::GOOGLE_PROVIDER,
        token: "abc123"
      )
    end

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
end
