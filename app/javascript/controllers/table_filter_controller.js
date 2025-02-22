import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["searchInput", "dateInput", "table", "clearDateBtn"]
  static values = {
    url: String,
  }

  connect() {
    // this.filter()
  }

  filter() {
    const searchQuery = this.searchInputTarget.value
    const dateQuery = this.dateInputTarget.value
    const baseUrl = this.urlValue || window.location.pathname
    const url = new URL(baseUrl, window.location.origin)

    if (searchQuery) {
      url.searchParams.set("query", searchQuery)
    }
    if (dateQuery) {
      url.searchParams.set("date", dateQuery)
    }

    fetch(url, {
      headers: {
        Accept: "text/vnd.turbo-stream.html",
      },
    })
      .then((response) => response.text())
      .then((html) => {
        Turbo.renderStreamMessage(html)
      })
  }

  search() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.filter()
    }, 300)
  }

  clearDate() {
    this.dateInputTarget.value = ""
    // Clear the Flatpickr instance if it exists
    if (this.dateInputTarget._flatpickr) {
      this.dateInputTarget._flatpickr.clear()
    }

    this.clearDateBtnTarget.style.display = "none"
    this.filter()
  }
}
