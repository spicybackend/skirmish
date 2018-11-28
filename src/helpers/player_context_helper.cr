module PlayerContextHelper
  def update_player_context(player : Player, league : League)
    context = player.player_context.not_nil!

    context.update!(league_id: league.id) unless context.league_id == league.id
  end
end
