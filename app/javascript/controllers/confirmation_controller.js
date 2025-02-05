import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirm"
export default class extends Controller {
  confirm(event) {
    const uid = event.currentTarget.dataset.uid
    if (!window.confirm(`Are you sure you want to void ${uid}?`)) {
      event.preventDefault() // Prevent form submission if the user cancels
    }
  }
}
