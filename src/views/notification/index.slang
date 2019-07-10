.row
  h2.col.justify-content-between.btn-toolbar
    span.heading-text Notifications
    .button-group
      == form(action: "/notifications/read_all", method: :patch, class: "single-btn") do
        == csrf_tag
        == submit(t("notification.actions.mark_all_as_read"), class: "btn btn-dark")

- if notifications.empty?
  p No notifications to show
- else
  .notifications.tiles
    - notifications.each do |notification|
      == render(partial: "_notification_tile.slang")

  nav
    ul class="pagination justify-content-center"
      li class="page-item #{"disabled" if page_number == 1}"
        a class="page-link" href="/notifications?page=#{[1, page_number - 1].max}" Previous

      - (1..last_page).to_a.each do |page|
        li class="page-item #{"current" if page_number == page}"
          a class="page-link" href="/notifications?page=#{page}" = page

      li class="page-item #{"disabled" if page_number == last_page}"
        a class="page-link" href="/notifications?page=#{[last_page, page_number + 1].min}" Next
