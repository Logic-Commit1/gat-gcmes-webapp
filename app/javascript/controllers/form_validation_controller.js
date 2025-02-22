import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "form",
    "projectSelect",
    "projectError",
    "poNumberInput",
    "poNumberError",
    "clientPoInput",
    "clientPoError",
    "supervisorInput",
    "supervisorError",
    "canvassSelect",
    "canvassError",
    "quotationSelect",
    "quotationError",
    "itemsTable",
    "itemsError",
    "particularsTable",
    "particularsError",
    "quotationTypeRadio",
    "quotationTypeError",
    "attentionInput",
    "attentionError",
    "vesselInput",
    "vesselError",
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
    "companySelect",
    "companyError",
    "amountInput",
    "amountError",
    "paymentSelect",
    "paymentError",
    "nameInput",
    "nameError",
    "codeInput",
    "codeError",
    "addressInput",
    "addressError",
    "contactsTable",
    "contactsError",
    "quotationSelect",
    "quotationError",
  ]

  connect() {
    this.clearErrors()
    this.inlineValidationValid = true
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

  setInlineValidationState(isValid) {
    this.inlineValidationValid = isValid
  }

  validateQuotationForm(event) {
    this.clearErrors()
    let isValid = true

    // Validate type
    if (
      this.hasQuotationTypeRadioTarget &&
      !document.querySelector('input[name="quotation[quotation_type]"]:checked')
    ) {
      event.preventDefault()
      this.quotationTypeRadioTarget.classList.add("field-error")
      this.quotationTypeErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate client selection
    if (this.hasClientSelectTarget && !this.clientSelectTarget.value) {
      event.preventDefault()
      this.clientSelectTarget.classList.add("field-error")
      this.clientErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate attention
    if (
      this.hasAttentionInputTarget &&
      !this.attentionInputTarget.value.trim()
    ) {
      event.preventDefault()
      this.attentionInputTarget.classList.add("field-error")
      this.attentionErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate vessel
    if (this.hasVesselInputTarget && !this.vesselInputTarget.value.trim()) {
      event.preventDefault()
      this.vesselInputTarget.classList.add("field-error")
      this.vesselErrorTarget.classList.remove("hidden")
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
      ).slice(0, 4)

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
    // if (this.hasProjectSelectTarget && !this.projectSelectTarget.value) {
    //   event.preventDefault()
    //   this.projectSelectTarget.classList.add("field-error")
    //   this.projectErrorTarget.classList.remove("hidden")
    //   isValid = false
    // }

    // Validate items table
    if (this.hasItemsTableTarget) {
      const rows = Array.from(
        this.itemsTableTarget.querySelectorAll(
          'td:not([data-nested-form-target="target"])'
        )
      ).slice(0, 4)

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
    // if (this.hasProjectSelectTarget && !this.projectSelectTarget.value) {
    //   event.preventDefault()
    //   this.projectSelectTarget.classList.add("field-error")
    //   this.projectErrorTarget.classList.remove("hidden")
    //   isValid = false
    // }

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

  validateProjectForm(event) {
    this.clearErrors()
    let isValid = true

    // Validate company selection
    if (this.hasCompanySelectTarget) {
      const selectedCompany = this.element.querySelector(
        'input[name="project[company_id]"]:checked'
      )
      if (!selectedCompany) {
        event.preventDefault()
        this.companyErrorTarget.classList.remove("hidden")
        isValid = false
      }
    }

    // Validate supervisor
    if (this.hasSupervisorInputTarget && !this.supervisorInputTarget.value) {
      event.preventDefault()
      this.supervisorInputTarget.classList.add("field-error")
      this.supervisorErrorTarget.classList.remove("hidden")
      isValid = false
    }

    if (this.hasQuotationSelectTarget && !this.quotationSelectTarget.value) {
      event.preventDefault()
      this.quotationSelectTarget.classList.add("field-error")
      this.quotationErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate client selection
    // if (this.hasClientSelectTarget && !this.clientSelectTarget.value) {
    //   event.preventDefault()
    //   this.clientSelectTarget.classList.add("field-error")
    //   this.clientErrorTarget.classList.remove("hidden")
    //   isValid = false
    // }

    // Validate PO number
    if (this.hasPoNumberInputTarget && !this.poNumberInputTarget.value.trim()) {
      event.preventDefault()
      this.poNumberInputTarget.classList.add("field-error")
      this.poNumberErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate client PO
    if (this.hasClientPoInputTarget) {
      const isNewRecord = !this.formTarget.dataset.projectId
      if (isNewRecord && !this.clientPoInputTarget.value) {
        event.preventDefault()
        this.clientPoInputTarget.classList.add("field-error")
        this.clientPoErrorTarget.classList.remove("hidden")
        isValid = false
      }
    }

    // Validate amount
    if (this.hasAmountInputTarget) {
      const amount = this.amountInputTarget.value.trim()
      if (!amount || isNaN(amount) || parseFloat(amount) <= 0) {
        event.preventDefault()
        this.amountInputTarget.classList.add("field-error")
        this.amountErrorTarget.classList.remove("hidden")
        isValid = false
      }
    }

    // Validate payment selection
    if (this.hasPaymentSelectTarget && !this.paymentSelectTarget.value) {
      event.preventDefault()
      this.paymentSelectTarget.classList.add("field-error")
      this.paymentErrorTarget.classList.remove("hidden")
      isValid = false
    }

    return isValid
  }

  validateClientForm(event) {
    this.clearErrors()
    let isValid = true

    // Check inline validation state first
    if (!this.inlineValidationValid) {
      event.preventDefault()
      isValid = false
    }

    // Validate company selection
    if (this.hasCompanySelectTarget) {
      const selectedCompany = this.element.querySelector(
        'input[name="client[company_id]"]:checked'
      )
      if (!selectedCompany) {
        event.preventDefault()
        this.companyErrorTarget.classList.remove("hidden")
        isValid = false
      }
    }

    // Validate name
    if (this.hasNameInputTarget && !this.nameInputTarget.value.trim()) {
      event.preventDefault()
      this.nameInputTarget.classList.add("field-error")
      this.nameErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate code
    if (this.hasCodeInputTarget && !this.codeInputTarget.value.trim()) {
      event.preventDefault()
      this.codeInputTarget.classList.add("field-error")
      this.codeErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate address
    if (this.hasAddressInputTarget && !this.addressInputTarget.value.trim()) {
      event.preventDefault()
      this.addressInputTarget.classList.add("field-error")
      this.addressErrorTarget.classList.remove("hidden")
      isValid = false
    }

    // Validate contacts table
    // if (this.hasContactsTableTarget) {
    //   const rows = this.contactsTableTarget.querySelectorAll(
    //     'tr:not([data-nested-form-target="target"])'
    //   )

    //   if (rows.length === 0) {
    //     event.preventDefault()
    //     this.contactsErrorTarget.classList.remove("hidden")
    //     isValid = false
    //   } else {
    //     let hasContactErrors = false

    //     rows.forEach((row) => {
    //       const inputs = row.querySelectorAll("input")
    //       inputs.forEach((input) => {
    //         if (!input.value || input.value.trim() === "") {
    //           input.classList.add("field-error")
    //           hasContactErrors = true
    //         } else {
    //           input.classList.remove("field-error")
    //         }
    //       })
    //     })

    //     if (hasContactErrors) {
    //       event.preventDefault()
    //       this.contactsErrorTarget.classList.remove("hidden")
    //       isValid = false
    //     }
    //   }
    // }

    return isValid
  }
}
