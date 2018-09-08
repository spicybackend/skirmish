.row
  .col.justify-content-between.btn-toolbar
    h2 Notifications
    .button-group
      == form(action: "/notifications/read_all", method: :patch, class: "single-btn") do
        == csrf_tag
        == submit(t("notification.actions.mark_all_as_read"), "data-confirm": "Are you sure?", class: "btn btn-success btn-sm")

.table-responsive
  table.table.table-striped
    thead
      tr
        th Title
        th Content
        th Actions
    tbody
      - notifications.each do |notification|
        tr
          td = notification.title
          td = notification.content
          td
            span
              == link_to("Open", "/notifications/#{notification.id}", class: "btn btn-primary btn-sm")
              - if !notification.read?
                == form(action: "/notifications/#{notification.id}/read", method: :patch, class: "single-btn") do
                  == csrf_tag
                  == submit(t("notification.actions.mark_as_read"), "data-confirm": "Are you sure?", class: "btn btn-success btn-sm")
