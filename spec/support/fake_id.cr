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
