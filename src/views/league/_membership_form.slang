- if membership.active?
  == form(action: "/leagues/#{league.id.to_s}/leave", method: :patch, class: "single-btn") do
    == csrf_tag
    == submit("Leave", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
- else
  == form(action: "/leagues/#{league.id.to_s}/join", method: membership.id ? :patch : :post, class: "single-btn") do
    == csrf_tag
    == submit("Join", class: "btn btn-primary btn-sm")
