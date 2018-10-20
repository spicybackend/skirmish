class RegistrationController < ApplicationController
  def new
    user = User.build(email: "", verification_code: "")
    player = Player.build(tag: "")

    render("new.slang")
  end

  def create
    Jennifer::Adapter.adapter.transaction do
      user = create_user_from_params
      player = create_player_from_params(user)

      WelcomeMailer.new(player).send

      session[:user_id] = user.id
      session[:player_id] = player.id
    end

    flash["success"] = "Registered successfully."
    redirect_to "/"
  rescue ex : Jennifer::RecordInvalid
    user = build_user_from_params.tap(&.valid?)
    player = build_player_from_params.tap(&.valid?)

    flash["danger"] = "Could not complete registration!"
    render("new.slang")
  end

  private def build_user_from_params
    User.build(email: "", verification_code: "").tap do |user|
      user.email = params[:email]
      user.receive_email_notifications = true
      user.verification_code = Random::Secure.hex(8)
      user.password = params["password"].to_s
    end
  end

  private def build_player_from_params
    Player.build(tag: params["username"])
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
      required(:username) { |f| !f.nil? }
      required(:email) { |f| !f.nil? }
      required(:password) { |f| !f.nil? }
    end
  end

  private def valid_username?(user)
    username = params[:username]

    if username.empty?
      user.errors << Granite::Error.new(:username, "is required")
    else
      if Player.find_by(tag: username)
        user.errors << Granite::Error.new(:username, "is already taken")
      end
    end
  end
end
