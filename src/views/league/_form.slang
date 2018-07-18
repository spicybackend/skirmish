- if league.errors
  ul.errors
    - league.errors.each do |error|
      li = error.to_s

== form(action: "/leagues/#{league.id.to_s}", method: league.id ? :patch : :post) do
  == csrf_tag
  .form-group
    == text_field(name: "name", value: league.name, placeholder: "Name", class: "form-control")
  .form-group
    == text_field(name: "description", value: league.description, placeholder: "Description", class: "form-control")
  == submit("Submit", class: "btn btn-primary btn-sm")
  == link_to("back", "/leagues", class: "btn btn-light btn-sm")
