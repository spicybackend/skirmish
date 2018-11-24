class Tournament::Start::ProcessByes
  getter :matches

  def initialize(matches : Array(Match))
    @matches = matches
  end

  def call
    matches_with_byes.each do |match|
      process_byes(match)
    end
  end

  private def matches_with_byes
    matches.select { |match| !match.player_a_id || !match.player_b_id }
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
