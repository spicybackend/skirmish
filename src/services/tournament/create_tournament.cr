class Tournament::CreateTournament
  getter :league

  class TournamentCreationError < Exception; end

  def initialize(league : League)
    @league = league
  end

  def call
    if tournament_in_progress?
      raise TournamentCreationError.new("A tournament for this league is already in progress")
    end

    Jennifer::Adapter.adapter.transaction do
      Tournament.create!(
        league_id: league.id
      )
    end
  end

  private def tournament_in_progress?
    Tournament.unfinished.for_league(league).exists?
  end
end
