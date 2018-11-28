== form(action: "/leagues/#{league.id}/games", method: :post, class: "main") do
  == csrf_tag
  h2 New Game

  .form-group.game-logger
    .game-logger-field
      span class="sentence-part" I
      select.form-control.btn.btn-secondary name="status"
        option value="won" selected="selected" Won
        option value="lost" Lost

    .game-logger-field
      span class="sentence-part" against
      select.form-control.btn.btn-secondary name="opponent-id"
        - other_players.each do |player|
          - if player.id == player_id_preselect
            option value="#{player.id}" selected="selected" #{player.tag}
          - else
            option value="#{player.id}" #{player.tag}

    .game-logger-field
      span class="sentence-part" in #{league.name}

  .form-group
    == submit t("game.actions.log_game"), class: "btn btn-primary"
    == link_to(t("general.actions.back"), "/leagues/#{league.id}", class: "btn btn-light")
