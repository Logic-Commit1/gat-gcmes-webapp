import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    console.log("Dropdown Controller connected")
    this.menuVisible = false
    this.bindClickOutside = this.clickOutside.bind(this)
  }

  toggleMenu() {
    this.menuVisible = !this.menuVisible
    this.menuTarget.classList.toggle("hidden", !this.menuVisible)

    if (this.menuVisible) {
      // Add click outside listener when menu is shown
      document.addEventListener("click", this.bindClickOutside)
    } else {
      // Remove listener when menu is hidden
      document.removeEventListener("click", this.bindClickOutside)
    }
  }

  clickOutside(event) {
    // If click is outside the dropdown menu and its trigger
    if (!this.element.contains(event.target)) {
      this.hideMenu()
    }
  }

  hideMenu() {
    this.menuVisible = false
    this.menuTarget.classList.add("hidden")
    document.removeEventListener("click", this.bindClickOutside)
  }

  disconnect() {
    // Clean up event listener when controller is disconnected
    document.removeEventListener("click", this.bindClickOutside)
  }
}
