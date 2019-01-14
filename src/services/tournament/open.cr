class Tournament::Open
  getter :league, :invite_content

  class OpenError < Exception; end

  def initialize(@league : League, @invite_content : String? = nil)
  end

  def call
    if tournament_in_progress?
      raise OpenError.new("A tournament for this league is already in progress")
    end

    Jennifer::Adapter.adapter.transaction do
      Tournament.create!(league_id: league.id).tap do |tournament|
        notify_players(tournament)
      end
    end
  end

  private def tournament_in_progress?
    Tournament.unfinished.for_league(league).exists?
  end

  private def notify_players(tournament)
    league.players.each do |player|
      OpenTournamentMailer.new(player, tournament, invite_content).send
    end
  end
end
