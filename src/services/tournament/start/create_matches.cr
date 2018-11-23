class Tournament::Start::CreateMatches
  getter :tournament, :players

  def initialize(tournament : Tournament, players : Array(Player | Nil))
    @tournament = tournament
    @players = players
  end

  def call
    create_initial_matches(players).tap do |initial_matches|
      create_subsequent_matches(initial_matches)
    end
  end

  private def create_initial_matches(players)
    ([] of Match).tap do |initial_matches|
      # each player will lose two matches expect for the winner
      # the winner will either lose only one game, or no games at all
      # this means we can create 2 losing games for everyone, with the exception
      # of the winner, who may only lose, at most, one game.
      # matches_to_create = 2 * filled_tournament_count - 1

      players.each_slice(2) do |(player_a, player_b)|
        initial_matches << Match.create!(
          level: 0,
          tournament_id: tournament.id,
          player_a_id: player_a.try(&.id),
          player_b_id: player_b.try(&.id)
        )
      end
    end
  end

  private def create_subsequent_matches(matches, level = 0)
    return unless matches.size >= 2

    ([] of Match).tap do |new_matches|
      matches.each_slice(2) do |(match_a, match_b)|
        new_match = Match.create!(
          level: level + 1,
          tournament_id: tournament.id,
          player_a_id: nil,
          player_b_id: nil
        )

        match_a.update!(next_match_id: new_match.id)
        match_b.update!(next_match_id: new_match.id)

        new_matches << new_match
      end

      create_subsequent_matches(new_matches, level + 1)
    end
  end
end
