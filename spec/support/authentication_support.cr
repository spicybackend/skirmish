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
  user = User.first(
    "WHERE NOT EXISTS(
      SELECT 1
      FROM administrators
      WHERE administrators.user_id = users.id
    )"
  )

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

def admin_authenticated_headers
  if admin = Administrator.first
    authenticated_headers_for(admin.user)
  else
    admin_user = User.new
    admin_user.email = "admin_user@example.com"
    admin_user.password = "password"
    admin_user.save!

    admin_player = Player.create!(
      tag: "admin",
      user_id: admin_user.id
    )

    Administrator.create!(
      user_id: admin_user.id
    )

    authenticated_headers_for(admin_user)
  end
end
