class TournamentMatchMailer < ApplicationMailer
  def initialize(player : Player, match : Match)
    super()

    user = player.user!
    to(user.email!, player.tag.to_s)
    self.from = ApplicationMailer::FROM_GAMES

    opponent = match.opponent(player).not_nil!
    tournament = match.tournament!
    league = tournament.league!

    player_rating = player.rating_for(league)
    opponent_rating = opponent.rating_for(league)
    win_chance = (Rating::WinProbability.new(player_rating, opponent_rating).call * 100).round

    self.subject = I18n.translate("mailer.tournament_match.subject", { opponent: opponent.tag })
    self.text = render("mailers/tournament_match.text.ecr")
    self.html = render("mailers/tournament_match.html.slang", "mailer_layout.html.slang")
  end
end
