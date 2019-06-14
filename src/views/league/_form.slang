== form(action: "/leagues/#{league.id.to_s}", method: league.id ? :patch : :post, class: "main") do
  h2 League Details
  p.subheading Some information about the league

  == csrf_tag

  - if league.errors
    ul.errors
      - league.errors.each do |error|
        li = error.to_s

  .form-group
    == label :name
    == text_field(:name, value: league.name, placeholder: "Give your league a name", class: "form-control")
  .form-group
    == label :description
    == text_field(:description, value: league.description, placeholder: "What's it all about?", class: "form-control")
  .form-group
    == label :visibility
    == select_field(:visibility, collection: League::VISIBILITY_OPTIONS.map{ |o| [o, o.capitalize] }, selected: league.visibility, class: "form-control")
  .form-group
    == label :accent_color, content: "Accent Colour"
    == text_field(:accent_color, value: league.accent_color, placeholder: "A splash of hex to brighten up your league", class: "form-control")
  .form-group
    == label :custom_icon_url, content: "Icon URL"
    == text_field(:custom_icon_url, value: league.custom_icon_url, placeholder: "An image to make your league truly yours", class: "form-control")
  .form-group
    == label :start_rating, content: "Initial Rating"
    == text_field(:start_rating, type: :number, value: league.start_rating || League::DEFAULT_START_RATING, placeholder: League::DEFAULT_START_RATING, class: "form-control")
  .form-group
    == label :k_factor, content: "Rating Change Weight"
    == text_field(:k_factor, type: :number, value: league.k_factor || League::DEFAULT_K_FACTOR, placeholder: League::DEFAULT_K_FACTOR, class: "form-control")

  == submit("Submit", class: "btn btn-primary")
  == link_to(t("general.actions.back"), "/leagues/#{league.id}", class: "btn btn-dark")
