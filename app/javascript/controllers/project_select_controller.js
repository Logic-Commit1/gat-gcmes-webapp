// app/javascript/controllers/project_select.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["projectSelect"]

  connect() {
    console.log("connect project select controller")
  }

  showHiddenDivs() {
    // console.log("showHiddenDivs")
    const hiddenDivs = document.querySelectorAll(".hidden")

    hiddenDivs.forEach((div) => {
      if (!div.closest(".nested-form-wrapper")) {
        div.classList.remove("hidden")
      }
    })
  }
}
