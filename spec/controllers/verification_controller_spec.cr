require "./spec_helper"

class VerificationControllerTest < GarnetSpec::Controller::Test
  getter handler : Amber::Pipe::Pipeline

  def initialize
    @handler = Amber::Pipe::Pipeline.new

    @handler.build :web do
      plug Amber::Pipe::Error.new
      plug Amber::Pipe::Session.new
      plug Amber::Pipe::Flash.new
      plug FakeId.new
      plug Authenticate.new
    end

    @handler.prepare_pipelines
  end
end

describe VerificationControllerTest do
  subject = VerificationControllerTest.new

  describe "#show" do
    context "when the user for the email is already activated" do
      it "redirects to the sign in page" do
        user = create_player_with_mock_user.user!

        response = subject.get "/verification/#{user.email}"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end

    context "when a user for the email doesn't exist" do
      it "redirects to the landing page" do
        response = subject.get "/verification/non_existent_email"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/"
      end
    end

    context "when the user for the email is unverified" do
      it "sucessfully renders the page" do
        user = create_player_with_mock_user(verified: false).user!
        response = subject.get "/verification/#{user.email}"

        response.status_code.should eq(200)
      end

      it "contains the 'account created' message" do
        user = create_player_with_mock_user(verified: false).user!
        response = subject.get "/verification/#{user.email}"

        response.body.should contain "Account Created"
      end

      it "contains verification instructions" do
        user = create_player_with_mock_user(verified: false).user!
        response = subject.get "/verification/#{user.email}"

        response.body.should contain "An email has been sent"
      end
    end
  end

  describe "#verify" do
    context "when the user for the email is already activated" do
      it "redirects to the sign in page" do
        user = create_player_with_mock_user.user!

        response = subject.get "/verify/#{user.verification_code}"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end
    end

    context "when a user for the email doesn't exist" do
      it "redirects to the landing page" do
        response = subject.get "/verify/abc123"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/"
      end
    end

    context "when the user for the email is unverified" do
      it "redirects to the sign in page" do
        user = create_player_with_mock_user(verified: false).user!
        response = subject.get "/verify/#{user.verification_code}"

        response.status_code.should eq(302)
        response.headers["Location"].should eq "/signin"
      end

      it "successfully activates the user" do
        user = create_player_with_mock_user(verified: false).user!
        user.activated?.should be_false

        response = subject.get "/verify/#{user.verification_code}"
        user.reload

        user.activated?.should be_true
      end
    end
  end
end
