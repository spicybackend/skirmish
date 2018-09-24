class HTTP::Server::Context
  property current_user : User?
end

class FakeId < Amber::Pipe::Base
  def call(context)
    if user_id = context.request.headers["fake_id"]? || context.params["fake_id"]?
      context.session["user_id"] = user_id
    end

    call_next(context)
  end
end

def authenticated_headers_for(user : User)
  if user
    headers = HTTP::Headers.new
    headers.add("fake_id", user.id.to_s)
  else
    raise "user not present"
  end
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
      email: "admin_user_#{league.name}@example.com",
      receive_email_notifications: false
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
