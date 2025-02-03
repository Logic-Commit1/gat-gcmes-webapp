import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"

const TECHNICAL_TEAM_OPTIONS = [
  { text: "JOSELITO ONG", value: "JOSELITO ONG" },
  { text: "JUSTIN BRIAN MANGUBAT", value: "JUSTIN BRIAN MANGUBAT" },
  { text: "MARLON MARLOS", value: "MARLON MARLOS" },
]

// Connects to data-controller="slim-select"
export default class extends Controller {
  static targets = ["field"]

  connect() {
    const select = this.fieldTarget

    new SlimSelect({
      select: select,
      settings: {
        allowDeselect: true,
        closeOnSelect: false,
      },
      data: select.classList.contains("technical-team-select")
        ? TECHNICAL_TEAM_OPTIONS
        : undefined,
    })
  }
}
