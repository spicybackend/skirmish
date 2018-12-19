class MultiAuthController < ApplicationController
  def google
    scopes = [
      "https://www.googleapis.com/auth/userinfo.profile",
      "https://www.googleapis.com/auth/userinfo.email"
    ].join(" ")

    redirect_to(google_auth.get_authorize_uri(scopes))
  end

  def callback
    api_response = google_auth.get("/oauth2/v2/userinfo", auth_code: params[:code])

    data = JSON.parse(api_response.body)
    # {
    #   "id" => "113153016673667482625",
    #   "email" => "some.one@gmail.com",
    #   "verified_email" => true,
    #   "name" => "Some One",
    #   "given_name" => "Some",
    #   "family_name" => "One",
    #   "link" => "https://plus.google.com/113153016673667482625",
    #   "picture" => "https://lh5.googleusercontent.com/-2xS4_k7Wjvw/AAAAAAAAAAI/AAAAAAAAABU/5BmPG3e6pJz/photo.jpg",
    #   "locale" => "en-GB",
    #   "hd" => "gmail.com"
    # }

    unless user = User.where { _email == data["email"].to_s }.first
      Jennifer::Adapter.adapter.transaction do
        # create another model for signing in and use "id" from data to auth against
        # then link to the user

        # also handle a case where the user (id) already exists, and link it to the user

        user = User.create(
          email: data["email"].to_s,
          name: data["name"].to_s,
          receive_email_notifications: true,
          verification_code: Random::Secure.hex(8),
          hashed_password: "$2a$04$gCUzhaAZExsPDdAfQV7ZW.K7PMUFQg9N57uKINeMQ2GuQp4wf6kc6"  # "password"
        )

        player = Player.build(tag: data["given_name"].to_s)
        player.add_user(user.not_nil!)
        player.save!
      end
    end

    session[:user_id] = user.not_nil!.id
    session[:player_id] = user.not_nil!.player!.id

    redirect_to("/profile")
  end

  private def google_auth
    GoogleAuth.new(
      "accounts.google.com",
      ENV["GOOGLE_ID"],
      ENV["GOOGLE_SECRET"],
      authorize_uri: "/o/oauth2/v2/auth",
      token_uri: "https://www.googleapis.com/oauth2/v4/token",
      redirect_uri: "http://localhost:3000/multi_auth/callback"
    )
  end
end
