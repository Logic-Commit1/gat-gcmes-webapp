import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.hasChanges = false

    // Store the handlers so we can remove them later
    this.beforeUnloadHandler = this.handleBeforeUnload.bind(this)
    this.clickHandler = this.handleClick.bind(this)
    this.inputHandler = this.handleInput.bind(this)

    // Add event listeners
    window.addEventListener("beforeunload", this.beforeUnloadHandler)
    document.addEventListener("click", this.clickHandler, true)

    // Add input change detection
    const form = this.element.querySelector("form")
    if (form) {
      form.addEventListener("input", this.inputHandler)
      form.addEventListener("change", this.inputHandler)
    }
  }

  disconnect() {
    // Clean up the event listeners when the controller is disconnected
    window.removeEventListener("beforeunload", this.beforeUnloadHandler)
    document.removeEventListener("click", this.clickHandler, true)

    const form = this.element.querySelector("form")
    if (form) {
      form.removeEventListener("input", this.inputHandler)
      form.removeEventListener("change", this.inputHandler)
    }
  }

  handleInput(event) {
    // Ignore changes to radio buttons
    if (event.target.type === "radio") return

    this.hasChanges = true
  }

  handleBeforeUnload(event) {
    if (!this.hasChanges) return

    // Cancel the event and show confirmation dialog
    event.preventDefault()
    // Chrome requires returnValue to be set
    event.returnValue = ""
  }

  handleClick(event) {
    if (!this.hasChanges) return

    // Check if the clicked element is a link or inside a link
    const link = event.target.closest("a")
    if (!link) return

    // Don't prompt for:
    // - Same page anchors
    // - Links that trigger Stimulus actions (they're likely form-related)
    // - Links without href
    // - Cancel button
    if (
      !link.href ||
      link.href.startsWith(window.location.href + "#") ||
      link.hasAttribute("data-action") ||
      link.textContent.trim() === "Cancel"
    )
      return

    // Show confirmation dialog
    if (
      !window.confirm(
        "You have unsaved changes. Are you sure you want to leave this page?"
      )
    ) {
      event.preventDefault()
      event.stopPropagation()
    }
  }
}
