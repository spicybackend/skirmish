if (document.getElementById('simple-logger')) {
  let statusField = document.getElementById('status')
  let statusDropdown = document.getElementById('status-dropdown')
  let statusDropdownOptions = document.getElementById('status-dropdown-options')

  Array.from(statusDropdownOptions.children).forEach(dropdownItem => {
    dropdownItem.addEventListener('click', (e) => {
      let item = e.target
      let newStatus = item.getAttribute('data-status').trim()
      let newStatusTitle = item.innerText.trim()

      item.innerText = statusDropdown.innerText.trim()
      item.setAttribute('data-status', statusField.getAttribute('value').trim())

      statusDropdown.innerText = newStatusTitle
      statusField.setAttribute('value', newStatus)
    })
  })

  let playerField = document.getElementById('opponent-id')
  let playerDropdown = document.getElementById('player-dropdown')
  let playerDropdownOptions = document.getElementById('player-dropdown-options')

  Array.from(playerDropdownOptions.children).forEach(dropdownItem => {
    dropdownItem.addEventListener('click', (e) => {
      let item = e.target
      let newPlayerId = item.getAttribute('data-player-id').trim()
      let newPlayerName = item.innerText.trim()

      item.innerText = playerDropdown.innerText.trim()
      item.setAttribute('data-player-id', playerField.getAttribute('value').trim())

      playerDropdown.innerText = newPlayerName
      playerField.setAttribute('value', newPlayerId)
    })
  })
}
