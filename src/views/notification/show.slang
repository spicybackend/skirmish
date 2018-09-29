h1 Show Notifications
p = notifications.player.id
p = notifications.event_type
p = notifications.sent_at
p = notifications.read_at
p = notifications.title
p = notifications.content
p
  // Needs to be rebased on master once other change merged
  == link_to(t("general.actions.back"), "/notifications", class: "btn btn-light")
  // Needs to be a patch action
  == link_to("read", "/notifications/#{notifications.id}/read", class: "btn btn-success")
