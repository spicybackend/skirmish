- if tournament.errors
  ul.errors
    - tournament.errors.each do |error|
      li = error.to_s

== form(action: "/leagues/#{league.id}/tournaments", method: tournament.id ? :patch : :post) do
  == csrf_tag

  .form-group
    .btn-group.btn-group-toggle data-toggle="buttons"
      label.btn.btn-secondary.active
        input checked="checked" type="radio" name="type" id="type-single-elimination" autocomplete="off" value="single-elimination"
          = I18n.translate("tournament.types.single-elimination")
      label.btn.btn-secondary.disabled
        input disabled="true" type="radio" name="type" id="type-double-elimination" autocomplete="off" value="double-elimination"
          = I18n.translate("tournament.types.double-elimination")

  == submit("Submit", class: "btn btn-primary")
  == link_to(t("general.actions.back"), "/leagues/#{league.id}", class: "btn btn-light")
