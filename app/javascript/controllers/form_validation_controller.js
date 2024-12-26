import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "form",
    "projectSelect",
    "projectError",
    "canvassSelect",
    "canvassError",
    "quotationSelect",
    "quotationError",
    "itemsTable",
    "itemsError",
    "particularsTable",
    "particularsError",
  ]

  connect() {
    this.clearErrors()
  }

  clearErrors() {
    // Hide all error messages
    this.element.querySelectorAll(".error-message").forEach((element) => {
      element.classList.add("hidden")
    })
    // Remove error classes from all input fields
    this.element.querySelectorAll(".field-error").forEach((element) => {
      element.classList.remove("field-error")
    })
    // Remove error classes from all select fields
    this.element.querySelectorAll("select").forEach((element) => {
      element.classList.remove("field-error")
    })
  }

  validateRequestForm(event) {
    this.clearErrors()
    let isValid = true

    // Validate project selection (common for both types)
    if (this.hasProjectSelectTarget && !this.projectSelectTarget.value) {
      event.preventDefault()
      this.projectSelectTarget.classList.add("field-error")
      this.projectErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate Order type specific fields
    if (this.hasCanvassSelectTarget && this.hasQuotationSelectTarget) {
      // Validate canvass
      if (!this.canvassSelectTarget.value) {
        event.preventDefault()
        this.canvassSelectTarget.classList.add("field-error")
        this.canvassErrorTarget.classList.remove("hidden")
        isValid = false
      }

      // Validate quotation
      if (!this.quotationSelectTarget.value) {
        event.preventDefault()
        this.quotationSelectTarget.classList.add("field-error")
        this.quotationErrorTarget.classList.remove("hidden")
        isValid = false
      }

      // Validate items table
      if (this.hasItemsTableTarget) {
        const rows = this.itemsTableTarget.querySelectorAll(
          'tr:not([data-nested-form-target="target"])'
        )

        if (rows.length === 0) {
          event.preventDefault()
          this.itemsErrorTarget.classList.remove("hidden")
          isValid = false
        } else {
          let hasItemErrors = false

          rows.forEach((row) => {
            const inputs = row.querySelectorAll("input")
            inputs.forEach((input) => {
              if (!input.value || input.value.trim() === "") {
                input.classList.add("field-error")
                hasItemErrors = true
              } else {
                input.classList.remove("field-error")
              }
            })
          })

          if (hasItemErrors) {
            event.preventDefault()
            this.itemsErrorTarget.classList.remove("hidden")
            isValid = false
          }
        }
      }
    }

    // Validate Allowance type specific fields
    if (this.hasParticularsTableTarget) {
      const rows = this.particularsTableTarget.querySelectorAll(
        'tr:not([data-nested-form-target="target"])'
      )

      if (rows.length === 0) {
        event.preventDefault()
        this.particularsErrorTarget.classList.remove("hidden")
        isValid = false
      } else {
        let hasParticularErrors = false

        rows.forEach((row) => {
          const inputs = row.querySelectorAll("input")
          inputs.forEach((input) => {
            // Skip remarks field as it's optional
            if (!input.name.includes("[remarks]")) {
              if (!input.value || input.value.trim() === "") {
                input.classList.add("field-error")
                hasParticularErrors = true
              } else {
                input.classList.remove("field-error")
              }
            }
          })
        })

        if (hasParticularErrors) {
          event.preventDefault()
          this.particularsErrorTarget.classList.remove("hidden")
          isValid = false
        }
      }
    }

    return isValid
  }

  validatePurchaseOrderForm(event) {
    this.clearErrors()
    let isValid = true

    return isValid
  }
}
