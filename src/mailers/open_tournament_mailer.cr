class OpenTournamentMailer < ApplicationMailer
  def initialize(player : Player, tournament : Tournament, content : String? = nil)
    super()

    user = player.user!
    to(user.email!, player.tag.to_s)
    self.from = ApplicationMailer::FROM_GAMES
    content ||= I18n.translate("mailer.open_tournament.content")

    self.subject = I18n.translate("mailer.open_tournament.subject", { league_name: tournament.league!.name })
    self.text = render("mailers/open_tournament.text.ecr")
    self.html = render("mailers/open_tournament.html.slang", "mailer_layout.html.slang")
  end
end
