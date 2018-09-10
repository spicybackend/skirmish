class Leaderboard::Base
  getter league

  def initialize(@league : League)
  end

  def rankings
    raise NotImplementedError.new("must be overridden in subclass")
  end

  def ranking_for(player : Player)
    raise NotImplementedError.new("must be overridden in subclass")
  end
end
