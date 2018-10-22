.row
  h2.col.justify-content-between.btn-toolbar Game
    - player = current_player
    - if current_player.try(&.admin_of?(league)) && game.unconfirmed?
      .btn-group
        == form(action: "/leagues/#{game.league_id}/games/#{game.id}/confirm", method: :patch) do
          == csrf_tag
          == submit("#{t("game.actions.confirm")} on behalf", class: "btn btn-primary form-toggle-split")

        button type="button" class="btn btn-primary dropdown-toggle dropdown-toggle-split" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
          span.sr-only Toggle Dropdown
        .dropdown-menu.dropdown-menu-right
          == form(action: "/leagues/#{game.league_id}/games/#{game.id}", method: :delete) do
            == csrf_tag
            == submit(t("general.actions.delete"), "data-confirm": "Are you sure?", class: "dropdown-item danger")

.game-results
  .winning-result
    .player-result
      img.gravatar src="#{gravatar_src_for(game.winner)}"
      span.name = game.winner.tag
    - if game.confirmed?
      span.rating = winner_rating
    - else
      span.rating.delta = winner_delta
  span.versus VS
  .losing-result
    .player-result
      img.gravatar src="#{gravatar_src_for(game.loser)}"
      span.name = game.loser.tag
    - if game.confirmed?
      span.rating = loser_rating
    - else
      span.rating.delta = loser_delta

.centered
  h3 #{game.winner.tag} won against #{game.loser.tag}
  - if game.confirmed?
    .centered
      p Game confirmed #{time_units_since(game.confirmed_at).downcase}
  - else
    .centered
      - if show_game_confirmation
        p == render(partial: "_confirmation_form.slang")
      p Game not yet confirmed
