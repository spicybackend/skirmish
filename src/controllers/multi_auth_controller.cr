class MultiAuthController < ApplicationController
  def google
    scopes = [
      "https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/userinfo.email"
    ].join(" ")

    auth = GoogleAuth.new(
      "accounts.google.com",
      ENV["GOOGLE_ID"],
      ENV["GOOGLE_SECRET"],
      authorize_uri: "/o/oauth2/v2/auth",
      token_uri: "https://www.googleapis.com/oauth2/v4/token",
      redirect_uri: "http://localhost:3000/multi_auth/callback"
    )

    redirect_to(
      location: auth.get_authorize_uri(scopes),
      status: 302
    )
  end

  def callback
    auth = GoogleAuth.new(
      "accounts.google.com",
      ENV["GOOGLE_ID"],
      ENV["GOOGLE_SECRET"],
      authorize_uri: "/o/oauth2/v2/auth",
      token_uri: "https://www.googleapis.com/oauth2/v4/token",
      redirect_uri: "http://localhost:3000/multi_auth/callback"
    )

    api_response = auth.get("/oauth2/v2/userinfo", auth_code: params[:code])

    data = JSON.parse(api_response.body)

    Jennifer::Adapter.adapter.transaction do
      user = User.create(
        email: data["email"].to_s,
        name: data["given_name"].to_s,
        receive_email_notifications: true,
        verification_code: Random::Secure.hex(8),
        hashed_password: "$2a$04$gCUzhaAZExsPDdAfQV7ZW.K7PMUFQg9N57uKINeMQ2GuQp4wf6kc6"  # "password"
      )

      player = Player.build(tag: data["given_name"].to_s)
      player.add_user(user.not_nil!)
      player.save!

      session[:user_id] = user.id
      session[:player_id] = player.id

      redirect_to("/profile")
    end
  end
end
