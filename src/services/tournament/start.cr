class Tournament::Start
  getter :tournament, :double_elimination

  class StartError < Exception; end

  def initialize(tournament : Tournament, double_elimination = false)
    @tournament = tournament
    # TODO: Determine double elim or other type of tournament from the tournament itself
    @double_elimination = double_elimination
  end

  def call
    if tournament_already_started?
      raise StartError.new("The tournament is already in progress")
    end

    if not_enough_players?
      raise StartError.new("There are not enough entrants to start the tournaments")
    end

    Jennifer::Adapter.adapter.transaction do
      # TODO break out these out into sub-services?
      player_ids = prepare_player_arrangement
      initial_matches = create_initial_matches(player_ids)
      create_subsequent_matches(initial_matches)
      process_byes(initial_matches)

      Match.all.each do |match|
        puts match.debug_output
      end
    end
  end

  private def tournament_already_started?
    tournament.in_progress?
  end

  private def not_enough_players?
    tournament.players_query.count < 2
  end

  private def prepare_player_arrangement
    players_query = tournament.players_query  # just an optimisation

    players_query.pluck(:id).tap do |player_ids|
      player_count = players_query.count
      filled_tournament_count = (2 ** Math.sqrt(player_count).ceil).to_i32

      # sprinkle the byes into the player ids
      num_byes = filled_tournament_count - player_count
      num_byes.times do |bye_i|
        player_ids.insert(bye_i * 2 + 1, nil)
      end
    end
  end

  private def create_initial_matches(player_ids)
    ([] of Match).tap do |initial_matches|
      # each player will lose two matches expect for the winner
      # the winner will either lose only one game, or no games at all
      # this means we can create 2 losing games for everyone, with the exception
      # of the winner, who may only lose, at most, one game.
      # matches_to_create = 2 * filled_tournament_count - 1

      player_ids.each_slice(2) do |(player_a_id, player_b_id)|
        initial_matches << Match.create!(
          level: 0,
          tournament_id: tournament.id,
          player_a_id: player_a_id,
          player_b_id: player_b_id
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

  private def process_byes(initial_matches : Array(Match))
    # TODO: split out player checking to method on the model?
    initial_matches.select { |match| !match.player_a_id || !match.player_b_id }.each do |match|
      process_byes(match)
    end
  end

  private def process_byes(match : Match)
    return if match.player_a_id && match.player_b_id

    default_winner_id = match.player_a_id || match.player_b_id
    match.update!(winner_id: default_winner_id)

    if next_match = Match.find(match.next_match_id)
      if !next_match.player_a_id
        next_match.update!(player_a_id: default_winner_id)
      elsif !next_match.player_b_id
        next_match.update!(player_b_id: default_winner_id)
      else
        raise "trying to process bye up to next match, but no spaces available"
      end
    end
  end
end
