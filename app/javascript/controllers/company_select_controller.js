// app/javascript/controllers/company_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["clientSelect","supplierSelect","requestFormSelect"]

  selectCompanyForClient(event) {
    const companyId = event.target.value

    fetch(`/companies/${companyId}/clients`, {
      headers: {
        "Accept": "application/json"
      }
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        return response.json()
      })
      .then(clients => {
        this.updateClientOptions(clients);
        this.showHiddenDivs(); // Call the method to show hidden divs
      })
      .catch(error => {
        console.error("Fetch error: ", error)
      })
  }

  selectCompanyForRequestFormsAndSuppliers(event) {
    this.selectCompanyForSuppliers(event)
    this.selectCompanyForRequestForms(event)
  }

  selectCompanyForSuppliers(event) {
    const companyId = event.target.value

    fetch(`/companies/${companyId}/suppliers`, {
      headers: {
        "Accept": "application/json"
      }
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        return response.json()
      })
      .then(suppliers => this.updateSupplierOptions(suppliers))
      .catch(error => {
        console.error("Fetch error: ", error)
      })
  }

  selectCompanyForRequestForms(event) {
    const companyId = event.target.value

    fetch(`/companies/${companyId}/request_forms`, {
      headers: {
        "Accept": "application/json"
      }
    })
      .then(response => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        return response.json()
      })
      .then(requestForms => this.updateRequestFormOptions(requestForms))
      .catch(error => {
        console.error("Fetch error: ", error)
      })
  }

  updateClientOptions(clients) {
    // Clear existing options
    this.clientSelectTarget.innerHTML = ""

    // Add a prompt option
    const promptOption = document.createElement("option")
    promptOption.textContent = "Select Client"
    promptOption.value = ""
    this.clientSelectTarget.appendChild(promptOption)

    // Add new options for each client
    clients.forEach(client => {
      const option = document.createElement("option")
      option.value = client.id
      option.textContent = client.name
      this.clientSelectTarget.appendChild(option)
    })
  }

  updateSupplierOptions(suppliers) {
    // Clear existing options
    this.supplierSelectTarget.innerHTML = ""

    // Add a prompt option
    const promptOption = document.createElement("option")
    promptOption.textContent = "Select Supplier"
    promptOption.value = ""
    this.supplierSelectTarget.appendChild(promptOption)

    // Add new options for each supplier
    suppliers.forEach(supplier => {
      const option = document.createElement("option")
      option.value = supplier.id
      option.textContent = supplier.name
      this.supplierSelectTarget.appendChild(option)
    })
  }

  updateRequestFormOptions(requestForms) {
    // Clear existing options
    this.requestFormSelectTarget.innerHTML = ""

    // Add a prompt option
    const promptOption = document.createElement("option")
    promptOption.textContent = "Select Request Form"
    promptOption.value = ""
    this.requestFormSelectTarget.appendChild(promptOption)

    // Add new options for each client
    requestForms.forEach(requestForm => {
      const option = document.createElement("option")
      option.value = requestForm.id
      option.textContent = requestForm.uid
      this.requestFormSelectTarget.appendChild(option)
    })
  }

  showHiddenDivs() {
    // Show hidden divs by removing the 'hidden' class
    const hiddenDivs = this.element.querySelectorAll('.hidden');
    console.log(hiddenDivs)
    hiddenDivs.forEach(div => {
        div.classList.remove('hidden');
    });
  } 

}
