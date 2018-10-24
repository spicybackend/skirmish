== form(action: "/leagues/#{game.league_id}/games/#{game.id}/confirm", method: :patch, class: "single-btn") do
  == csrf_tag
  == submit(t("game.actions.confirm"), class: "btn btn-primary")
