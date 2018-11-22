class League::LogGame
  getter winner, loser, league, logger

  property game : Game, errors : Array(String)

  def initialize(@league : League, @winner : Player, @loser : Player, @logger : Player)
    @game = Game.build
    @errors = [] of String
  end

  def call
    players.each do |player|
      unless league_members.to_a.includes?(player)
        @errors << "#{player} is not a member of #{league}"
        return false
      end
    end

    game.logged_by_id = logger.id.not_nil!
    game.league_id = league.id.not_nil!

    if game.valid? && game.save
      # TODO these should be validated and saved along with the game
      create_participations!
      update_tournament_matches!
      notify_other_player!

      return true
    else
      @errors += game.errors.full_messages.compact
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
      rating: nil,
      confirmation_code: Random::Secure.hex(8)
    )

    loser_participation = Participation.create!(
      game_id: game.id,
      player_id: loser.id,
      won: false,
      rating: nil,
      confirmation_code: Random::Secure.hex(8)
    )

    [winner_participation, loser_participation]
  end

  private def update_tournament_matches!
    # TODO find a better way to match this independent of being player_a or player_b
    Match.where { (_player_a_id == winner.id && _player_b_id == loser.id) || (_player_a_id == loser.id && _player_b_id == winner.id) }.each do |match|
      match.update!(game_id: game.id)
    end
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
  end
end
