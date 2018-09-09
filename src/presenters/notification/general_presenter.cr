class Notification::GeneralPresenter
  getter notification

  delegate id, title, content, read?, read_at, to: notification

  def initialize(@notification : Notification)
  end

  def action_url
    "/notifications"
  end
end
