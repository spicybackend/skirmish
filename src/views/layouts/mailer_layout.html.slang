doctype html
html
  head
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    link rel="stylesheet" href="/dist/foundation-emails.css"
    link rel="stylesheet" href="/dist/main.bundle.css"
    link href="https://fonts.googleapis.com/css?family=Krub" rel="stylesheet"
  body
    table.body.mailer
      tr
        td.float-center align="center" valign="top"
          center
            == content
