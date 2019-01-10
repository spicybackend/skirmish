.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Notifications
    .button-group
      == form(action: "/notifications/read_all", method: :patch, class: "single-btn") do
        == csrf_tag
        == submit(t("notification.actions.mark_all_as_read"), class: "btn btn-dark")

h6.section-header Unread
.notifications.tiles
  - unread_notifications.each do |notification|
    == render(partial: "_notification_tile.slang")


h6.section-header Read
.notifications.tiles
  - read_notifications.each do |notification|
    == render(partial: "_notification_tile.slang")
