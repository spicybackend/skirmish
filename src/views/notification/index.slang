.row
  h2.col.justify-content-between.btn-toolbar Notifications
    .button-group
      == form(action: "/notifications/read_all", method: :patch, class: "single-btn") do
        == csrf_tag
        == submit(t("notification.actions.mark_all_as_read"), "data-confirm": "Are you sure?", class: "btn btn-success btn-sm")

.notifications
  - notifications.each do |notification|
    a href="/notifications/#{notification.id}"
      .notification
        img.icon src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
        span.content = notification.title
        span.time = time_units_since(notification.created_at)
