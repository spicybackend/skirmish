.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Game Results
    - player = current_player
    - if current_player.try(&.admin_of?(league)) && game.unconfirmed?
      .btn-group
        button type="button" class="btn btn-warning dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
          | Admin Tools
        .dropdown-menu.dropdown-menu-right
          == form(action: "/leagues/#{game.league_id}/games/#{game.id}/confirm", method: :patch) do
            == csrf_tag
            == submit("#{t("game.actions.confirm")} on behalf", "data-confirm": "Are you sure you want to confirm this game on behalf of the unconfirmed?", class: "dropdown-item primary")
          == form(action: "/leagues/#{game.league_id}/games/#{game.id}", method: :delete) do
            == csrf_tag
            == submit(t("general.actions.delete"), "data-confirm": "Are you sure you want to delete this unconfirmed game?", class: "dropdown-item danger")

p.description
  - if match = game.match
    | For a
    == link_to("tournament match", "/leagues/#{league.id}/tournaments/#{match.tournament_id}")
    | in
  - else
    | For
  == link_to(league.name, "/leagues/#{league.id}")

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
