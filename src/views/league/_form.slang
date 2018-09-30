- if league.errors
  ul.errors
    - league.errors.each do |error|
      li = error.to_s

== form(action: "/leagues/#{league.id.to_s}", method: league.id ? :patch : :post) do
  == csrf_tag

  .form-group
    == label(name: "name", content: "Name")
    == text_field(name: "name", value: league.name, placeholder: "Give your league a name", class: "form-control")
  .form-group
    == label(name: "description", content: "Description")
    == text_field(name: "description", value: league.description, placeholder: "What's it all about?", class: "form-control")
  .form-group
    == label(name: "accent_color", content: "Accent Colour")
    == text_field(name: "accent_color", value: league.accent_color, placeholder: "A splash of hex to make your league truly yours", class: "form-control")
  .form-group
    == label(name: "start_rating", content: "Initial Rating")
    == input_field(:number, name: "start_rating", value: league.start_rating || League::DEFAULT_START_RATING, placeholder: League::DEFAULT_START_RATING, class: "form-control")
  .form-group
    == label(name: "k_factor", content: "Rating Change Weight")
    == input_field(:number, name: "k_factor", value: league.k_factor || League::DEFAULT_K_FACTOR, placeholder: League::DEFAULT_K_FACTOR, class: "form-control")

  == submit("Submit", class: "btn btn-primary")
  == link_to(t("general.actions.back"), "/leagues/#{league.id}", class: "btn btn-light")
