- if notifications.errors
  ul.errors
    - notifications.errors.each do |error|
      li = error.to_s

== form(action: "/notifications/#{notifications.id.to_s}", method: notifications.id ? :patch : :post) do
  == csrf_tag
  .form-group
    == label(:player)
    == select_field(name: "player_id", collection: Player.all.map{|player| [player.id, player.id]}, selected: notifications.player_id, class: "form-control")
  .form-group
    == text_field(name: "event_type", value: notifications.event_type, placeholder: "Event_type", class: "form-control")
  .form-group
    == text_field(name: "sent_at", value: notifications.sent_at, placeholder: "Sent_at", class: "form-control")
  .form-group
    == text_field(name: "read_at", value: notifications.read_at, placeholder: "Read_at", class: "form-control")
  .form-group
    == text_field(name: "title", value: notifications.title, placeholder: "Title", class: "form-control")
  .form-group
    == text_field(name: "content", value: notifications.content, placeholder: "Content", class: "form-control")
  == submit("Submit", class: "btn btn-primary btn-sm")
  == link_to("back", "/notifications", class: "btn btn-light btn-sm")
