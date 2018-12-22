h2 League Management

p.description = "For #{league.name}"
- path = context.request.path

ul.nav.nav-tabs
  li.nav-item
    - active = path.match(/\/leagues\/\d+\/players/) ? "active" : ""
    a class="nav-link #{active}" href="/leagues/#{league.id}/players" Active Players
  li.nav-item
    - active = path.match(/\/leagues\/\d+\/inactive_players/) ? "active" : ""
    a class="nav-link #{active}" href="/leagues/#{league.id}/inactive_players" Inactive Players
  li.nav-item
    - active = path.match(/\/leagues\/\d+\/requests/) ? "active" : ""
    a class="nav-link #{active}" href="/leagues/#{league.id}/requests" Pending Requests
  li.nav-item
    - active = path.match(/\/leagues\/\d+\/invites/) ? "active" : ""
    a class="nav-link #{active}" href="/leagues/#{league.id}/invites" Pending Invites
  li.nav-item
    - active = path.match(/\/leagues\/\d+\/admins/) ? "active" : ""
    a class="nav-link #{active}" href="/leagues/#{league.id}/admins" Admins
