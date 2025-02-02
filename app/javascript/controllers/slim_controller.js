import { Controller } from "@hotwired/stimulus"
import SlimSelect from "slim-select"
// Connects to data-controller="slim-select"
export default class extends Controller {
  static targets = ["field"]
  connect() {
    new SlimSelect({
      select: this.fieldTarget,
    })
  }
}
