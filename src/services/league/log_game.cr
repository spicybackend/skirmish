class League::LogGame
  getter winner, loser, league, logger

  property game : Game, errors : Array(String)

  def initialize(@league : League, @winner : Player, @loser : Player, @logger : Player)
    @game = Game.new
    @errors = [] of String
  end

  def call
    players.each do |player|
      unless league_members.includes?(player)
        @errors << "#{player} is not a member of #{league}"
        return false
      end
    end

    game.logged_by_id = logger.id
    game.league = league

    if game.valid? && game.save
      # TODO these should be validated and saved along with the game
      create_participations!
      notify_other_player!

      return true
    else
      @errors += game.errors.map(&.to_s).compact
      return false
    end
  end

  private def players
    [winner, loser]
  end

  private def league_members
    league.active_players
  end

  private def create_participations!
    winner_participation = Participation.create!(
      game_id: game.id,
      player_id: winner.id,
      won: true,
      rating: nil
    )

    loser_participation = Participation.create!(
      game_id: game.id,
      player_id: loser.id,
      won: false,
      rating: nil
    )

    [winner_participation, loser_participation]
  end

  private def other_player
    players.find { |player| player != logger }.not_nil!
  end

  private def notify_other_player!
    NotifyPlayer.new(
      player: other_player,
      won: other_player.id == winner.id,
      game: game,
      logger: logger
    ).call!

    GameLoggedMailer.new(other_player, game).send
  end
end
