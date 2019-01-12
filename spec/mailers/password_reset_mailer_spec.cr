require "./spec_helper"

describe PasswordResetMailer do
  describe "recipient" do
    it "is addressed to the user's email" do
      user = create_player_with_mock_user.user!
      token = "abc123"

      mailer = PasswordResetMailer.new(user, token)

      recipient = mailer.to.first
      recipient.email.should eq user.email
    end
  end

  describe "sender" do
    it "is from the support address" do
      user = create_player_with_mock_user.user!
      token = "abc123"

      mailer = PasswordResetMailer.new(user, token)

      sender = mailer.from
      sender.should eq ApplicationMailer::FROM_SUPPORT
    end
  end

  describe "subject" do
    it "is indicative of a password reset" do
      user = create_player_with_mock_user.user!
      token = "abc123"

      mailer = PasswordResetMailer.new(user, token)

      mailer.subject.should eq I18n.translate("mailer.password_reset.subject")
    end
  end

  describe "content" do
    it "contains the mailer title" do
      user = create_player_with_mock_user.user!
      token = "abc123"

      mailer = PasswordResetMailer.new(user, token)

      mailer.html.should contain HTML.escape(I18n.translate("mailer.password_reset.title"))
      mailer.text.should contain I18n.translate("mailer.password_reset.title")
    end

    it "asks the user to reset the user's password" do
      user = create_player_with_mock_user.user!
      token = "abc123"

      mailer = PasswordResetMailer.new(user, token)

      I18n.translate("mailer.password_reset.content").split("\n").each do |content_paragrah|
        mailer.html.should contain HTML.escape(content_paragrah)
        mailer.text.should contain content_paragrah
      end
    end

    it "contains a link to reset the the user's password" do
      user = create_player_with_mock_user.user!
      token = "abc123"

      mailer = PasswordResetMailer.new(user, token)

      verification_link = "#{ENV["BASE_URL"]}/reset_password/#{token}/edit?email=#{user.email}"

      mailer.html.should contain HTML.escape(verification_link)
      mailer.text.should contain verification_link
    end
  end
end
