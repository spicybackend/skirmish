class Tournament::Start::PreparePlayers
  getter :tournament

  def initialize(tournament : Tournament)
    @tournament = tournament
  end

  def call
    players = [] of (Player | Nil)

    players += tournament.players.shuffle
    add_byes(players)

    players
  end

  private def add_byes(players)
    entered_player_count = players.size
    filled_tournament_size = (2 ** Math.sqrt(entered_player_count).ceil).to_i32

    byes_count = filled_tournament_size - entered_player_count
    byes_count.times do |bye_i|
      players.insert(bye_i * 2 + 1, nil)
    end
  end
end
