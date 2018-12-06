class HTTP::Server::Context
  property current_user : User?
end

class FakeId < Amber::Pipe::Base
  def call(context)
    context.session["user_id"] = context.request.headers["fake_user_id"]? || context.params["fake_user_id"]?
    context.session["player_id"] = context.request.headers["fake_player_id"]? || context.params["fake_player_id"]?

    call_next(context)
  end
end

def authenticated_headers_for(user : User)
  headers = HTTP::Headers.new
  headers.add("fake_user_id", user.id.to_s)
  headers.add("fake_player_id", user.player!.id.to_s)
end

def authenticated_headers_for(player : Player)
  authenticated_headers_for(player.user!)
end

def basic_authenticated_headers
  player = create_player_with_mock_user

  authenticated_headers_for(player.user!)
end

def admin_authenticated_headers(league : League)
  # find an admin for the league
  if admin = league.administrators.first?
    player = admin.player.not_nil!
    user = player.user.not_nil!
  else
    # failing that, create one
    user = User.new({
      name: "#{league.name} Admin",
      email: "#{league.name}.admin@example.com",
      receive_email_notifications: false,
      verification_code: Random::Secure.hex(8)
    })
    user.password = "password"
    user.save!

    player = Player.create!(
      tag: "admin_#{league.name}"[0, 16],
      user_id: user.id
    )

    Administrator.create!(
      player_id: player.id,
      league_id: league.id
    )
  end

  authenticated_headers_for(user)
end
