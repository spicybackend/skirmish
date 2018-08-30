.row
  .col-sm-11
    h2 Notifications
  .col-sm-1
    == link_to(t("notification.actions.mark_all_as_read"), "/notifications/read_all?_csrf=#{csrf_token}", "data-method": "patch", "data-confirm": "Are you sure?", class: "btn btn-success btn-sm")
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
              == link_to("Mark Read", "/notifications/#{notification.id}/read?_csrf=#{csrf_token}", "data-method": "patch", "data-confirm": "Are you sure?", class: "btn btn-success btn-sm")
