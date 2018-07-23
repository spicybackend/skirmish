h1 New Game

== form(action: "/leagues/#{league.id}/games", method: :post) do
  == csrf_tag
  .form-group
    div class="simple-logger"
      span class="sentence-part" I

      div class="status-selection"
        button id="dropdown-status" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
          | Won
        div class="dropdown-menu" aria-labelledby="dropdown-status"
          a class="dropdown-item" href="#"
            | Lost
        == hidden_field name: "status", content: "0"

      span class="sentence-part" against

      div class="player-selction"
        button id="dropdown-player" type="button" class="btn btn-secondary dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
          == players.first.tag
        div class="dropdown-menu" aria-labelledby="dropdown-player"
          - players.each do |player|
            a class="dropdown-item" href="##{player.id}"
              = "#{player.tag}"
        == hidden_field name: "other-player-id", content: "#{players.first.id}"

  .form-group
  == submit "Log Game", class: "btn btn-primary"
  == link_to("back", "/leagues/#{league.id}", class: "btn btn-light")
