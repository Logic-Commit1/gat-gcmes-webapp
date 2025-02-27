import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["sidebar", "hamburger"]

  connect() {
    this.toggleSidebar = this.toggleSidebar.bind(this)
    this.hamburgerTarget.addEventListener("click", this.toggleSidebar)
  }

  disconnect() {
    this.hamburgerTarget.removeEventListener("click", this.toggleSidebar)
  }

  toggleSidebar() {
    this.sidebarTarget.classList.toggle("active")
    document.body.classList.toggle("sidebar-active")
    document.querySelector("main").style.marginLeft =
      this.sidebarTarget.classList.contains("active") ? "234px" : "30px"
  }
}
