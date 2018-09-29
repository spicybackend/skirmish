.row
  .col.justify-content-between.btn-toolbar
    h2 Leagues
    - if current_user
      .button-group
        a.btn.btn-success.btn-sm href="/leagues/new" New

.leagues
  - leagues.each do |league|
    a href="/leagues/#{league.id}"
      .league
        img.icon src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
        span.title = league.name
        span.description = league.description
        - if members_count = league.memberships_query.count == 1
          span.membership-count = "#{league.memberships_query.count} member"
        - else
          span.membership-count = "#{league.memberships_query.count} members"
