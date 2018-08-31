- if membership.active?
  == form(action: "/leagues/#{league.id.to_s}/leave", method: :patch, class: "single-btn") do
    == csrf_tag
    == submit(t("league.actions.leave"), "data-confirm": "Are you sure?", class: "btn btn-danger btn-sm")
- else
  == form(action: "/leagues/#{league.id.to_s}/join", method: membership.id ? :patch : :post, class: "single-btn") do
    == csrf_tag
    == submit(t("league.actions.join"), class: "btn btn-primary btn-sm")
