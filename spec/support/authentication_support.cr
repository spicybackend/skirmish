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

def authenticated_headers_for(user : User | Nil)
  if user
    headers = HTTP::Headers.new
    headers.add("fake_id", user.id.to_s)
  else
    raise "user not present"
  end
end

def basic_authenticated_headers
  # try and find a user without ANY administration
  user = User.first(
    "WHERE NOT EXISTS(
      SELECT 1
      FROM administrators
      WHERE administrators.user_id = users.id
    )"
  )

  # failing that, create one
  if user.nil?
    user = User.new
    user.email = "basic@user.com"
    user.password = "much-secure-wow"
    user.save!

    basic_player = Player.create!(
      tag: "basic",
      user_id: user.id
    )
  end

  authenticated_headers_for(user)
end

def admin_authenticated_headers(league : League)
  # find an admin for the league
  if admin = Administrator.first("WHERE league_id = ?", [league.id])
    authenticated_headers_for(admin.user)
  else
    # failing that, create one
    admin_user = User.new
    admin_user.email = "admin_user_#{league.name}@example.com"
    admin_user.password = "password"
    admin_user.save!

    admin_player = Player.create!(
      tag: "admin_#{league.name}",
      user_id: admin_user.id
    )

    Administrator.create!(
      user_id: admin_user.id,
      league_id: league.id
    )

    authenticated_headers_for(admin_user)
  end
end
