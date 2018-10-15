.row
  h2.col.justify-content-between.btn-toolbar Leagues
    - if current_user
      .button-group
        a.btn.btn-primary href="/leagues/new" New

h6.section-header All Leagues
.leagues
  - leagues.each do |league|
    a href="/leagues/#{league.id}"
      .league
        img.icon style="background-color: #{league.accent_color};" src="https://png.icons8.com/ios-glyphs/200/ffffff/trophy.png"
        span.title = league.name
        span.description = league.description
        - members_count = league.active_memberships_query.count
        - if members_count == 1
          span.membership-count = "#{members_count} member"
        - elsif members_count == 0
          span.membership-count No members
        - else
          span.membership-count = "#{members_count} members"
