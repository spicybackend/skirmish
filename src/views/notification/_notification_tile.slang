a.tile href="/notifications/#{notification.id}"
  .icon
    img.glyph src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png" style="background-color: #{notification.color}"
  .content = notification.title
  .secondary = time_units_since(notification.created_at)
