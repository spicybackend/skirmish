a.tile href="/notifications/#{notification.id}"
  == render(partial: "notification/_icon.slang")
  .content class="notification #{notification.read? ? "read" : "unread"}" = notification.title
  .secondary = time_units_since(notification.created_at).capitalize
