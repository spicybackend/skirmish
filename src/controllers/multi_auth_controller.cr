class MultiAuthController < ApplicationController
  before_action do
    only [:unlink] { redirect_signed_out_user }
  end

  def google
    scopes = [
      "https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/userinfo.email"
    ].join(" ")

    redirect_to(google_auth.get_authorize_uri(scopes))
  end

  def callback  # google callback
    api_response = google_auth.get("/oauth2/v2/userinfo", auth_code: params[:code])

    data = JSON.parse(api_response.body)

    if auth_provider = AuthProvider.where { _token == data["id"].to_s }.first
      if user = User.find(auth_provider.user_id)
        session[:user_id] = user.id
        session[:player_id] = user.player!.id

        flash[:info] = I18n.translate("session.logged_in_successfully")
        redirect_to landing_url
      else
        session[:auth_provider_details] = {
          provider: AuthProvider::GOOGLE_PROVIDER,
          token: data["id"].to_s,
          email: data["email"]?,
          name: data["name"]?,
          tag: data["given_name"]?
        }.to_json

        redirect_to("/signup")
      end
    else
      if signed_in_user = current_user
        auth_provider = AuthProvider.build(
          provider: AuthProvider::GOOGLE_PROVIDER,
          token: data["id"].to_s
        )

        auth_provider.user_id = signed_in_user.id
        auth_provider.save!

        flash[:success] = "Successfully linked your account with Google"
        redirect_to("/profile/edit")
      else
        session[:auth_provider_details] = {
          provider: AuthProvider::GOOGLE_PROVIDER,
          token: data["id"].to_s,
          email: data["email"]?,
          name: data["name"]?,
          tag: data["given_name"]?
        }.to_json

        redirect_to("/signup")
      end
    end
  end

  def unlink
    if auth_provider = AuthProvider.find(params[:id])
      hashed_password =  auth_provider.user!.hashed_password

      if hashed_password.nil? || hashed_password.empty?
        flash[:danger] = "A password must be set on the account before removing other authentication providers"
        redirect_to "/profile/edit"
      else
        auth_provider.destroy

        flash[:success] = "Unlinked #{auth_provider.provider.capitalize} provider"
        redirect_to "/profile/edit"
      end
    else
      flash[:danger] = "Can't find linked authentication provider"
      redirect_to "/profile/edit"
    end
  end

  private def google_auth
    GoogleAuth.new(
      "accounts.google.com",
      ENV["GOOGLE_ID"],
      ENV["GOOGLE_SECRET"],
      authorize_uri: "/o/oauth2/v2/auth",
      token_uri: "https://www.googleapis.com/oauth2/v4/token",
      redirect_uri: "#{ENV["BASE_URL"]}/multi_auth/callback"
    )
  end
end
