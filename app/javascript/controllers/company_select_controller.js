// app/javascript/controllers/company_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["clientSelect"]

  selectCompany(event) {
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
      .then(clients => this.updateClientOptions(clients))
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
}
