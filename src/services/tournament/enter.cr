class Tournament::Enter
  class EntryError < Exception; end

  getter :player, :tournament

  def initialize(player : Player, tournament : Tournament)
    @player = player
    @tournament = tournament
  end

  def call
    league = tournament.league.not_nil!

    if player.member_of?(league: league)
      Entrant.create!(player_id: player.id, tournament_id: tournament.id)
    else
      raise EntryError.new("Must be a member of #{league.name} to join it's tournaments")
    end
  end
end
