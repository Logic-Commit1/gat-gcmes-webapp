import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toast"]
  static values = { duration: Number }

  connect() {
    this.toastTargets.forEach((toast) => {
      // Get duration from data attribute or default to 4000ms
      const duration = toast.dataset.alertDurationValue || 4000
      setTimeout(() => this.hideToast(toast), duration)
    })
  }

  close(event) {
    const toast = event.currentTarget.closest(".alert-toast")
    this.hideToast(toast)
  }

  hideToast(toast) {
    if (!toast) return

    toast.classList.add("hide")
    // Remove the element after animation completes
    setTimeout(() => {
      console.log("removing toast")
    }, 300) // Match the CSS animation duration
  }
}
