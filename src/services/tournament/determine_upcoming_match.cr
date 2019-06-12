class Tournament::DetermineUpcomingMatch
  getter :player, :tournament

  def initialize(player : Player, tournament : Tournament)
    @player = player
    @tournament = tournament
  end

  def call
    return nil if tournament.finished?

    tournament.matches_query.
      where { (_player_a_id == player.id) | (_player_b_id == player.id) }.
      order({ :level => :desc }).
      first
  end
end
