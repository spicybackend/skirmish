- if membership.active?
  == form(action: "/leagues/#{league.id.to_s}/leave", method: :patch) do
    == csrf_tag
    .form-group
      == submit("Leave", "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
- else
  == form(action: "/leagues/#{league.id.to_s}/join", method: membership.id ? :patch : :post) do
    == csrf_tag
    .form-group
      == submit("Join", class: "btn btn-primary btn-sm")
