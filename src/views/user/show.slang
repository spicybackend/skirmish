h1 Profile
p class="small"
  == "@#{user.username}"
p
  == user.email
p
  == link_to("edit", "/profile/edit", class: "btn btn-success btn-sm")
