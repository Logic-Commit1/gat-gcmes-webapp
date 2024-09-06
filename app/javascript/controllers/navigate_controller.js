import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  to(e) {
    e.preventDefault()

    const { url } = e.target.dataset

    // Use Turbo to navigate to the new form state
    Turbo.visit(url, { frame: "request_form_types" })
  }
}
