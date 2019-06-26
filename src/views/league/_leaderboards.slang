h4 King of the Hill
- leaderboard = Leaderboard::KingOfTheHill.new(league: league)
== render(partial: "_leaderboard.slang")

h4 Elo Rating
- leaderboard = Leaderboard::PureSkill.new(league: league)
== render(partial: "_leaderboard.slang")
