import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "error"]
  static values = {
    checkUrl: String,
    currentValue: String,
  }
  static outlets = ["form-validation"]

  initialize() {
    this.debouncedValidate = this.debounce(this.validate.bind(this), 300)
    this.isValid = true
  }

  validate() {
    const value = this.inputTarget.value.trim()

    // Skip validation if empty or unchanged
    if (!value || value === this.currentValueValue) {
      this.hideError()
      this.isValid = true
      this.notifyValidationState()
      return
    }

    fetch(`${this.checkUrlValue}?code=${encodeURIComponent(value)}`)
      .then((response) => response.json())
      .then((data) => {
        if (data.exists) {
          this.showError()
          this.inputTarget.classList.add("field-error")
          this.isValid = false
        } else {
          this.hideError()
          this.inputTarget.classList.remove("field-error")
          this.isValid = true
        }
        this.notifyValidationState()
      })
  }

  inputChanged() {
    this.debouncedValidate()
  }

  showError() {
    this.errorTarget.classList.remove("hidden")
  }

  hideError() {
    this.errorTarget.classList.add("hidden")
  }

  notifyValidationState() {
    if (this.hasFormValidationOutlet) {
      this.formValidationOutlet.setInlineValidationState(this.isValid)
    }
  }

  // Debounce helper to prevent too many API calls
  debounce(func, wait) {
    let timeout
    return function executedFunction(...args) {
      const later = () => {
        clearTimeout(timeout)
        func(...args)
      }
      clearTimeout(timeout)
      timeout = setTimeout(later, wait)
    }
  }
}
