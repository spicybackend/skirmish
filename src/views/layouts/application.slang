doctype html
html
  head
    title = t "application.name"
    meta charset="utf-8"
    meta http-equiv="X-UA-Compatible" content="IE=edge"
    meta name="viewport" content="width=device-width, initial-scale=1"
    meta name="theme-color" content="#343a40"
    meta name="msapplication-navbutton-color" content="#343a40"
    meta name="apple-mobile-web-app-status-bar-style" content="#343a40"
    link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/3.7.0/animate.min.css"
    link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/css/bootstrap.min.css"
    link rel="stylesheet" href="/dist/main.bundle.css"
    link rel="apple-touch-icon" href="/favicon.png"
    link rel="icon" href="/favicon.png"
    link rel="icon" type="image/x-icon" href="/favicon.ico"
    link href="https://fonts.googleapis.com/css?family=Muli" rel="stylesheet"

  body
    .masthead
      .container
        nav.navbar.navbar-expand-lg.navbar-dark
          == render(partial: "layouts/_nav.slang")
    .container
      .row
        .col-sm
          - flash.each do |key, value|
            div class="alert alert-#{key}"
              p = flash[key]
      .row
        .col-sm-12.main
          == content

    script src="https://code.jquery.com/jquery-3.3.1.min.js"
    script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
    script src="https://stackpath.bootstrapcdn.com/bootstrap/4.1.0/js/bootstrap.min.js"
    / script src="/dist/cytoscape.min.js"
    script src="/dist/main.bundle.js"
