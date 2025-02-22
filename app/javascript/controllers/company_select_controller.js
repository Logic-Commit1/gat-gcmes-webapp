// app/javascript/controllers/company_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "clientSelect",
    "supplierSelect",
    "requestFormSelect",
    "projectSelect",
    "projectSelectField",
    "canvassSelect",
    "quotationSelect",
  ]

  connect() {
    // Check if the form is in edit mode
    // if (this.element.dataset.editMode === "true") {
    //   this.populateClientSelect()
    // }
  }

  selectCompanyForClient(event) {
    this.fetchAndUpdateOptions(
      event,
      "/clients",
      this.clientSelectTarget,
      "Select Client",
      "name"
    )
    this.showHiddenDivs() // Call the method to show hidden divs
  }

  selectCompanyForProjectsClient(event) {
    this.selectCompanyForProjects(event)
    this.selectCompanyForClient(event)

    this.showHiddenDivs()
  }

  populateClientSelect() {
    const selectedCompanyId = this.element.querySelector(
      "#company-field input:checked"
    ).value
    this.fetchAndUpdateOptions(
      { target: { value: selectedCompanyId } },
      "/clients",
      this.clientSelectTarget,
      "Select Client",
      "name"
    )
  }

  selectCompanyForProjectsAndSuppliers(event) {
    this.selectCompanyForProjects(event)
    this.selectCompanyForSuppliers(event)
    // this.selectCompanyForRequestForms(event)
  }

  selectCompanyForProjectsCanvassesQuotations(event) {
    this.selectCompanyForProjects(event)
    if (this.hasCanvassSelectTarget) {
      this.selectCompanyForCanvasses(event)
      // this.selectCompanyForQuotations(event)
    }
    this.showHiddenDivs()
  }

  selectCompanyForSuppliers(event) {
    this.fetchAndUpdateOptions(
      event,
      "/suppliers",
      this.supplierSelectTarget,
      "Select Vendor",
      "name"
    )
    this.populateAllSupplierSelects(event.target.value)
  }

  selectCompanyForRequestForms(event) {
    this.fetchAndUpdateOptions(
      event,
      "/order_request_forms",
      this.requestFormSelectTarget,
      "",
      "uid"
    )
  }

  selectCompanyForProjects(event) {
    this.fetchAndUpdateOptions(
      event,
      "/projects",
      this.projectSelectTarget,
      "Select Project",
      "uid"
    )
    this.showHiddenDivs()
  }

  selectCompanyForCanvasses(event) {
    this.fetchAndUpdateOptions(
      event,
      "/canvasses",
      this.canvassSelectTarget,
      "Select Canvass",
      "uid"
    )
  }

  selectCompanyForQuotations(event) {
    this.fetchAndUpdateOptions(
      event,
      "/quotations",
      this.quotationSelectTarget,
      "Select Quotation",
      "uid"
    )
    this.showHiddenDivs()
  }

  fetchAndUpdateOptions(
    event,
    endpoint,
    selectTarget,
    promptText,
    displayAttribute
  ) {
    const companyId = event.target.value

    fetch(`/companies/${companyId}${endpoint}`, {
      headers: {
        Accept: "application/json",
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        return response.json()
      })
      .then((items) => {
        console.log(items)
        this.updateOptions(selectTarget, items, promptText, displayAttribute)
      })

      .catch((error) => {
        console.error("Fetch error: ", error)
      })
  }

  updateOptions(selectTarget, items, promptText, displayAttribute) {
    // Clear existing options
    selectTarget.innerHTML = ""

    // Add a prompt option
    if (promptText !== "") {
      const promptOption = document.createElement("option")
      promptOption.textContent = promptText
      promptOption.value = ""
      selectTarget.appendChild(promptOption)
    }

    // Add new options based on the provided items
    items.forEach((item) => {
      const option = document.createElement("option")
      option.value = item.id
      option.textContent = item[displayAttribute]
      selectTarget.appendChild(option)

      if (this.element.dataset.clientId == item.id) {
        option.selected = true
      }
    })
  }

  showHiddenDivs() {
    const hiddenDivs = this.element.querySelectorAll(".hidden")

    hiddenDivs.forEach((div) => {
      if (
        !div.closest(".nested-form-wrapper") &&
        !div.classList.contains("error-message")
      ) {
        div.classList.remove("hidden")
      }
    })
  }

  showProjectSelect() {
    this.projectSelectFieldTarget.classList.remove("hidden")
  }

  getDynamicTarget() {
    const targets = [
      this.supplierSelectTarget,
      this.requestFormSelectTarget,
      this.projectSelectTarget,
      this.canvassSelectTarget,
      this.quotationSelectTarget,
    ]

    function hasValue(target) {
      return target && target.value.trim() !== ""
    }

    return targets.find(hasValue)
  }

  populateAllSupplierSelects(companyId) {
    const allSupplierSelects = document.querySelectorAll(
      '[data-company-select-target="supplierSelect"]'
    )

    allSupplierSelects.forEach((select) => {
      if (select !== this.supplierSelectTarget) {
        this.fetchAndUpdateOptions(
          { target: { value: companyId } },
          "/suppliers",
          select,
          "Select Vendor",
          "name"
        )
      }
    })
  }
}
