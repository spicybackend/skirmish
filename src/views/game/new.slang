== form(action: "/leagues/#{league.id}/games", method: :post, class: "main") do
  == csrf_tag
  h2 New Game

  .form-group
    div id="simple-logger"
      span class="sentence-part" I

      div class="status-selection"
        == hidden_field name: "status", value: "won"
        button id="status-dropdown" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
          == t("game.won").downcase
        div id="status-dropdown-options" class="dropdown-menu" aria-labelledby="dropdown-status"
          a class="dropdown-item" href="#" data-status="lost"
            == t("game.lost").downcase

      span class="sentence-part" against

      div class="player-selction"
        - first_player = other_players.shift
        == hidden_field name: "opponent-id", value: "#{first_player.try(&.id)}"
        button id="player-dropdown" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
          == first_player.tag
        - if other_players.any?
          div id="player-dropdown-options" class="dropdown-menu" aria-labelledby="dropdown-player"
            - other_players.each do |player|
              a class="dropdown-item" href="#" data-player-id="#{player.id}"
                = "#{player.tag}"

  .form-group
    == submit t("game.actions.log_game"), class: "btn btn-primary"
    == link_to(t("general.actions.back"), "/leagues/#{league.id}", class: "btn btn-light")
