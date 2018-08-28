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

def basic_authenticated_headers
  # try and find a player without ANY administration
  player = Player.first(
    "WHERE NOT EXISTS(
      SELECT 1
      FROM administrators
      WHERE administrators.player_id = players.id
    )"
  )

  if player
    user = player.user.not_nil!
  else
    # failing that, create one
    user = User.new
    user.email = "basic@user.com"
    user.password = "much-secure-wow"
    user.save!

    Player.create!(
      tag: "basic",
      user_id: user.id
    )
  end

  authenticated_headers_for(user)
end

def admin_authenticated_headers(league : League)
  # find an admin for the league
  if admin = Administrator.first("WHERE league_id = ?", [league.id])
    player = admin.player.not_nil!
    user = player.user.not_nil!
  else
    # failing that, create one
    user = User.new
    user.email = "admin_user_#{league.name}@example.com"
    user.password = "password"
    user.save!

    player = Player.create!(
      tag: "admin_#{league.name}",
      user_id: user.id
    )

    Administrator.create!(
      player_id: player.id,
      league_id: league.id
    )
  end

  authenticated_headers_for(user)
end
