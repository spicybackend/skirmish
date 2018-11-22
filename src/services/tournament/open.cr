class Tournament::Open
  getter :league

  class OpenError < Exception; end

  def initialize(league : League)
    @league = league
  end

  def call
    if tournament_in_progress?
      raise OpenError.new("A tournament for this league is already in progress")
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
