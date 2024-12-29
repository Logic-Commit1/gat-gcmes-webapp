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
    "clientSelect",
    "clientError",
    "subjectInput",
    "subjectError",
    "descriptionInput",
    "descriptionError",
    "quantityInput",
    "quantityError",
    "unitSelect",
    "unitError",
    "suppliersTable",
    "suppliersError",
    "supplierSelect",
    "supplierError",
    "requestFormSelect",
    "requestFormError",
    "termsSelect",
    "termsError",
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

  validateQuotationForm(event) {
    this.clearErrors()
    let isValid = true

    // Validate project selection
    if (this.hasProjectSelectTarget && !this.projectSelectTarget.value) {
      event.preventDefault()
      this.projectSelectTarget.classList.add("field-error")
      this.projectErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate client selection
    if (this.hasClientSelectTarget && !this.clientSelectTarget.value) {
      event.preventDefault()
      this.clientSelectTarget.classList.add("field-error")
      this.clientErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate subject
    if (this.hasSubjectInputTarget && !this.subjectInputTarget.value.trim()) {
      event.preventDefault()
      this.subjectInputTarget.classList.add("field-error")
      this.subjectErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate items table
    if (this.hasItemsTableTarget) {
      const rows = Array.from(
        this.itemsTableTarget.querySelectorAll(
          'td:not([data-nested-form-target="target"])'
        )
      ).slice(0, 5)

      if (rows.length === 0) {
        event.preventDefault()
        this.itemsErrorTarget.classList.remove("hidden")
        isValid = false
      } else {
        let hasItemErrors = false

        rows.forEach((row) => {
          const inputs = row.querySelectorAll("input, select")
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

    return isValid
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

    // Validate project selection
    if (this.hasProjectSelectTarget && !this.projectSelectTarget.value) {
      event.preventDefault()
      this.projectSelectTarget.classList.add("field-error")
      this.projectErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate supplier selection
    if (this.hasSupplierSelectTarget && !this.supplierSelectTarget.value) {
      event.preventDefault()
      this.supplierSelectTarget.classList.add("field-error")
      this.supplierErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate request form selection
    // if (this.hasRequestFormSelectTarget) {
    //   const selectedOptions = Array.from(
    //     this.requestFormSelectTarget.selectedOptions
    //   )
    //   if (selectedOptions.length === 0) {
    //     event.preventDefault()
    //     this.requestFormSelectTarget.classList.add("field-error")
    //     this.requestFormErrorTarget.classList.remove("hidden")
    //     isValid = false
    //   }
    // }

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
          const inputs = row.querySelectorAll("input, select")
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

    // Validate payment terms
    if (this.hasTermsSelectTarget && !this.termsSelectTarget.value) {
      event.preventDefault()
      this.termsSelectTarget.classList.add("field-error")
      this.termsErrorTarget.classList.remove("hidden")
      isValid = false
    }

    return isValid
  }

  validateCanvassForm(event) {
    this.clearErrors()
    let isValid = true

    // Validate project selection
    if (this.hasProjectSelectTarget && !this.projectSelectTarget.value) {
      event.preventDefault()
      this.projectSelectTarget.classList.add("field-error")
      this.projectErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate description
    if (
      this.hasDescriptionInputTarget &&
      !this.descriptionInputTarget.value.trim()
    ) {
      event.preventDefault()
      this.descriptionInputTarget.classList.add("field-error")
      this.descriptionErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate quantity
    if (
      this.hasQuantityInputTarget &&
      (!this.quantityInputTarget.value || this.quantityInputTarget.value <= 0)
    ) {
      event.preventDefault()
      this.quantityInputTarget.classList.add("field-error")
      this.quantityErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate unit
    if (this.hasUnitSelectTarget && !this.unitSelectTarget.value) {
      event.preventDefault()
      this.unitSelectTarget.classList.add("field-error")
      this.unitErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate suppliers table
    if (this.hasSuppliersTableTarget) {
      const rows = this.suppliersTableTarget.querySelectorAll(
        'tr:not([data-nested-form-target="target"])'
      )

      if (rows.length === 0) {
        event.preventDefault()
        this.suppliersErrorTarget.classList.remove("hidden")
        isValid = false
      } else {
        let hasSupplierErrors = false

        rows.forEach((row) => {
          const inputs = row.querySelectorAll("input, select")
          inputs.forEach((input) => {
            // Skip remarks field as it's optional
            if (!input.name.includes("[remarks]")) {
              if (!input.value || input.value.trim() === "") {
                input.classList.add("field-error")
                hasSupplierErrors = true
              } else {
                input.classList.remove("field-error")
              }
            }
          })
        })

        if (hasSupplierErrors) {
          event.preventDefault()
          this.suppliersErrorTarget.classList.remove("hidden")
          isValid = false
        }
      }
    }

    return isValid
  }
}
