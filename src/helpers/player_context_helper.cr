module PlayerContextHelper
  def update_player_context(player : Player, league : League)
    player_context = player.player_context.not_nil!

    player_context.update!(league_id: league.id) unless player_context.league_id == league.id
  end

  def update_player_context(player : Player, league_id : Int64)
    player_context = player.player_context.not_nil!

    player_context.update!(league_id: league_id) unless player_context.league_id == league_id
  end
end
