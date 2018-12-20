class MultiAuthController < ApplicationController
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

        redirect_to("/profile")
      else
        session[:auth_provider_details] = {
          auth_provider_id: auth_provider.id,
          email: data["email"]?,
          name: data["name"]?,
          tag: data["given_name"]?
        }.to_json

        redirect_to("/signup")
      end
    else
      auth_provider = AuthProvider.build(
        provider: AuthProvider::GOOGLE_PROVIDER,
        token: data["id"].to_s
      )

      if signed_in_user = current_user
        auth_provider.user_id = signed_in_user.id
        auth_provider.save!

        flash[:success] = "Successfully linked your account with Google"
        redirect_to("/profile/edit")
      else
        auth_provider.save!

        session[:auth_provider_details] = {
          auth_provider_id: auth_provider.id,
          email: data["email"]?,
          name: data["name"]?,
          tag: data["given_name"]?
        }.to_json

        redirect_to("/signup")
      end
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
