.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Game Results
    - player = current_player
    - if current_player.try(&.admin_of?(league)) && game.unconfirmed?
      .btn-group
        button type="button" class="btn btn-dark dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false"
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

.col-sm-9.centered
  .game-results
    .winner-avatar.animated.bounceInLeft
      img.gravatar src="#{gravatar_src_for(game.winner)}"

    .versus
      img.animated.rotateIn.faster src="/dist/images/versus.svg"

    .loser-avatar.animated.bounceInRight
      img.gravatar src="#{gravatar_src_for(game.loser)}"
      span.droplet.animated.fadeInDown.delay-2s 💧

  .game-overview.centered
    h3 #{game.winner.tag} won against #{game.loser.tag}
    - if game.confirmed?
      .centered
        p Game confirmed #{time_units_since(game.confirmed_at).downcase}
    - else
      .centered
        p Game not yet confirmed
        - if show_game_confirmation
          p == render(partial: "_confirmation_form.slang")

  .game-stats.row
    .col-sm-12.col-md-6
      .card.text-white.bg-dark.mb-3
        .card-header.flex-spread
          span.icon-card-header Winner
          span.text-right 👑

        .card-body
          h3 = game.winner.tag
          p = game.confirmed? ? "Gained #{rating_delta} points (#{winner_rating})" : "Will gain #{rating_delta} points (#{winner_rating + rating_delta})"

        .card-footer
          a.card-link href="/profile/#{game.winner.tag}" View Profile

    .col-sm-12.col-md-6
      .card.text-white.bg-dark.mb-3
        .card-header.flex-spread
          span.icon-card-header Loser
          span.text-right 💀

        .card-body
          h3 = game.loser.tag
          p = game.confirmed? ? "Lost #{rating_delta} points (#{loser_rating})" : "Will lose #{rating_delta} points (#{loser_rating - rating_delta})"

        .card-footer
          a.card-link href="/profile/#{game.loser.tag}" View Profile
