h1 New Game

== form(action: "/leagues/#{league.id}/games", method: :post) do
  == csrf_tag
  .form-group
    div id="simple-logger"
      span class="sentence-part" I

      div class="status-selection"
        == hidden_field name: "status", value: "won"
        button id="status-dropdown" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
          | won
        div id="status-dropdown-options" class="dropdown-menu" aria-labelledby="dropdown-status"
          a class="dropdown-item" href="#" data-status="lost"
            | lost

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
    == submit "Log Game", class: "btn btn-primary"
    == link_to("back", "/leagues/#{league.id}", class: "btn btn-light")
