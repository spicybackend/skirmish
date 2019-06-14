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

  nav aria-label="Page navigation example"
    ul class="pagination"
      - if page_number != 0
        li class="page-item"
          a class="page-link" href="/notifications?page=#{page_number - 1}" Previous

      - (1..(total_items / per_page)).to_a.each do |page_number|
        li class="page-item"
          a class="page-link" href="/notifications?page=#{page_number}" = page_number

      - if page_number != last_page
        li class="page-item"
          a class="page-link" href="/notifications?page=#{page_number + 1}" Next
