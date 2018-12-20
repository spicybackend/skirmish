class RegistrationController < ApplicationController
  def new
    auth_provider_details = fetch_provider_details || {} of String => String

    user = User.build(
      name: auth_provider_details["name"]?.to_s,
      email: auth_provider_details["email"]?.to_s,
      verification_code: ""
    )

    player = Player.build(
      tag: auth_provider_details["tag"]?.to_s
    )

    render("new.slang")
  end

  def create
    Jennifer::Adapter.adapter.transaction do
      user = create_user_from_params
      player = create_player_from_params(user)

      if auth_provider_details = fetch_provider_details
        AuthProvider.create!(
          provider: auth_provider_details["provider"].to_s,
          token: auth_provider_details["token"].to_s,
          user_id: user.id
        )

        session.delete("auth_provider_details")
      end

      WelcomeMailer.new(player).send

      redirect_to "/verification/#{user.email}"
    end
  rescue ex : Jennifer::RecordInvalid
    user = build_user_from_params.tap(&.valid?)
    player = build_player_from_params.tap(&.valid?)

    flash["danger"] = "Could not complete registration!"
    render("new.slang")
  end

  private def build_user_from_params
    User.build(name: "", email: "", verification_code: "").tap do |user|
      user.name = params[:name]
      user.email = params[:email]
      user.receive_email_notifications = true
      user.verification_code = Random::Secure.hex(8)
      user.password = params["password"].to_s
    end
  end

  private def build_player_from_params
    Player.build(tag: params["tag"])
  end

  private def create_user_from_params
    build_user_from_params.tap(&.save!)
  end

  private def create_player_from_params(user : User)
    build_player_from_params.tap do |player|
      player.add_user(user.not_nil!)
      player.save!
    end
  end

  private def registration_params
    params.validation do
      required(:tag) { |f| !f.nil? }
      required(:name) { |f| !f.nil? }
      required(:email) { |f| !f.nil? }
      required(:password) { |f| !f.nil? }
    end
  end

  private def fetch_provider_details
    if auth_provider_details = session[:auth_provider_details]
      JSON.parse(auth_provider_details)
    end
  end
end
