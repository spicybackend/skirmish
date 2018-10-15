doctype html
html
  head
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    link href="https://fonts.googleapis.com/css?family=Krub" rel="stylesheet"
    style
      = File.read("public/dist/foundation-emails.css")
    style
      = File.read("public/dist/main.bundle.css")
  body
    table.body.mailer
      tr
        td.float-center align="center" valign="top"
          center
            == content
