.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Leagues
    - if current_user
      .button-group
        a.btn.btn-primary href="/leagues/new" New

h6.section-header All Leagues
.leagues
  - leagues.each do |league|
    .col-sm-6
      .card.text-white.bg-dark.w-100.mb-3
        .card-header.flex-spread
          span.icon-card-header
            .icon
              img.glyph style="background-color: #{league.accent_color};" src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
            = league.name
          span.text-right = "Rated #{current_player.try(&.rating_for(league))}"

        .card-body
          p = league.description

          - members_count = league.active_memberships_query.count
          - if members_count == 1
            span.text-muted = "#{members_count} member"
          - elsif members_count == 0
            span.text-muted No members
          - else
            span.text-muted = "#{members_count} members"

        .card-footer
          a.card-link href="/leagues/#{league.id}" View League
          a.card-link href="/leagues/#{league.id}/games/new" Log Game
