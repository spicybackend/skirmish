== form(action: "/leagues/#{league.id}/games", method: :post, class: "main", id: "game-log-form") do
  == csrf_tag

  h2 New Game

  .form-group.game-logger
    .game-logger-field
      span class="sentence-part" I
      select.form-control.btn-dark name="status"
        option value="won" selected="selected" Won
        option value="lost" Lost

    .game-logger-field
      span class="sentence-part" against
      == select_field(name: "opponent-id", collection: other_players.map { |player| [player.id, player.display_name] }, selected: player_id_preselect, class: "form-control btn-dark")

    .game-logger-field
      span class="sentence-part" in #{league.name}

  .form-group
    == submit t("game.actions.log_game"), class: "btn btn-primary"
    == link_to(t("general.actions.back"), "/leagues/#{league.id}", class: "btn btn-dark")
