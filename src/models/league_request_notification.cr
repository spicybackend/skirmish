require "./notification"

class LeagueRequestNotification < Notification
  mapping(
    source_type: String,
    source_id: Int64
  )

  def title
    "Invite request for #{league.name}"
  end

  def content
    "#{requester.display_name} has requested to join #{league.name}"
  end

  def action_url
    "/leagues/#{league.id}/requests"
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

  def requester
    invitation.player!
  end

  def icon_url
    league.icon_url
  end

  def custom_icon?
    league.custom_icon?
  end
end
