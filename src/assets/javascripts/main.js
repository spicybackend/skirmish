import Amber from 'amber'

import "./game.js"
import "./tournament.js"

if (!Date.prototype.toGranite) {
  (function() {

    function pad(number) {
      if (number < 10) {
        return '0' + number;
      }
      return number;
    }

    Date.prototype.toGranite = function() {
      return this.getUTCFullYear() +
        '-' + pad(this.getUTCMonth() + 1) +
        '-' + pad(this.getUTCDate()) +
        ' ' + pad(this.getUTCHours()) +
        ':' + pad(this.getUTCMinutes()) +
        ':' + pad(this.getUTCSeconds())  ;
    };

  }());
}

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
