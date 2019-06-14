a.tile href="/notifications/#{notification.id}"
  == render(partial: "notification/_icon.slang")
  .content = notification.title
  .secondary = time_units_since(notification.created_at)
