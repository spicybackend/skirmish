require "./notification"

class LeagueInviteNotification < Notification
  mapping(
    source_type: String,
    source_id: Int64
  )

  def title
    "You've been invited to join #{league.name}"
  end

  def content
    "#{approver.display_name} has invited you to join #{league.name}"
  end

  def action_url
    "/leagues/#{league.id}"
  end

  def invitation
    Invitation.find(source_id).not_nil!
  end

  def color
    league.accent_color
  end

  def league
    invitation.league!
  end

  def approver
    invitation.approver!
  end
end
