class Tournament::DetermineUpcomingMatch
  getter :player, :tournament

  def initialize(@player : Player, @tournament : Tournament)
  end

  def call
    return nil unless tournament.in_progress?

    tournament.matches_query.
      where { (_player_a_id == player.id) | (_player_b_id == player.id) }.
      order({ :level => :desc }).
      first
  end
end
