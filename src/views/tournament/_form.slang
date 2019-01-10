== form(action: "/leagues/#{league.id}/tournaments", method: tournament.id ? :patch : :post, class: "main") do
  == csrf_tag

  h2 Tournament Details

  - if tournament.errors
    ul.errors
      - tournament.errors.each do |error|
        li = error.to_s

  .form-group
    .btn-group.btn-group-toggle data-toggle="buttons"
      label.btn.btn-secondary.active
        input checked="checked" type="radio" name="type" id="type-single-elimination" autocomplete="off" value="single-elimination"
          = I18n.translate("tournament.types.single-elimination")

  == submit("Submit", class: "btn btn-primary")
  == link_to(t("general.actions.back"), "/leagues/#{league.id}", class: "btn btn-dark")
