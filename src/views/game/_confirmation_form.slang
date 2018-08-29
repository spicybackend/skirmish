== form(action: "/leagues/#{game.league.id}/games/#{game.id}/confirm", method: :patch, class: "single-btn") do
  == csrf_tag
  == submit(t("game.actions.confirm"), "data-confirm": "Are you sure?", class: "btn btn-success btn-sm")
