import Amber from 'amber'

import "./tournament.js"
import "./party-popper.js"

/*
 * Ensure the data-confirm elements show popup confirmations
 */
document.querySelectorAll("form").forEach((form) => {
  form.querySelectorAll("form input[type=submit]").forEach((submissionElem) => {
    let confirmationMessage = submissionElem.getAttribute("data-confirm");

    if (confirmationMessage) {
      submissionElem.addEventListener("click", function(e) {
        e.preventDefault()

        if (confirm(confirmationMessage)) {
          form.submit()
        }
      })
    }
  })
})
