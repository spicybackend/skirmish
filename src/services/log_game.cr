class LogGame
  getter winner : Player, loser : Player, league : League

  property game : Game | Nil, errors : Array(String)

  def initialize(@winner, @loser, @league)
    @errors = [] of String
  end

  def call
    unless league_players.includes?(winner)
      @errors << "#{winner} is not a member of #{league}"
      return false
    end

    unless league_players.includes?(loser)
      @errors << "#{loser} is not a member of #{league}"
      return false
    end

    game = Game.new
    game.winner_id = winner.id
    game.league = league

    if game.valid? && game.save
      Participation.create!(
        game_id: game.id,
        player_id: winner.id,
        won: true
      )

      Participation.create!(
        game_id: game.id,
        player_id: loser.id,
        won: false
      )

      @game = game
    else
      raise game.errors.to_s
      @errors += game.errors.map(&.to_s).compact

      return false
    end
  end

  private def league_players
    league.players
  end
end