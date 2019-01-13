module SessionHelper
  abstract def context

  def current_user
    context.current_user
  end

  def current_player
    context.current_player
  end

  def current_player_context
    current_player.try(&.player_context)
  end

  def signed_in?
    current_user && current_player ? true : false
  end
end
