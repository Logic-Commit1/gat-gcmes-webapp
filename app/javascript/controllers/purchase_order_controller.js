import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="purchase-order"
export default class extends Controller {
  static targets = ["requestFormSelect", "itemsContainer"]

  connect() {}

  showRequestFormItems(event) {
    const selectedRequestFormIds = Array.from(event.target.selectedOptions).map(
      (option) => option.value
    )
    this.fetchItemsofRequestForm(selectedRequestFormIds)
  }

  selectCompanyForQuotations(event) {
    this.fetchAndUpdateOptions(
      event,
      "/quotations",
      this.quotationSelectTarget,
      "Select Quotation",
      "uid"
    )
  }

  fetchItemsofRequestForm(requestFormIds) {
    fetch(`/request_forms/items?request_form_ids=${requestFormIds.join(",")}`, {
      headers: {
        Accept: "application/json",
      },
    })
      .then((response) => {
        if (!response.ok) {
          throw new Error(`HTTP error! status: ${response.status}`)
        }
        return response.json() // Get the response as JSON
      })
      .then((items) => {
        this.updateItemsContainer(items)
      })
      .catch((error) => {
        console.error("Fetch error: ", error)
      })
  }

  handleContinueButton(event) {
    event.preventDefault()
    const selectedRequestFormIds = Array.from(
      this.requestFormSelectTarget.selectedOptions
    ).map((option) => option.value)
    this.fetchItemsofRequestForm(selectedRequestFormIds)

    // show hidden fields
    document.querySelector(".hidden").classList.remove("hidden")
  }

  updateItemsContainer(items) {
    let particularsTable = ""
    let productsTable = ""

    // Particulars table
    if (items.particulars && items.particulars.length > 0) {
      particularsTable = `
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Allowance</th>
              </tr>
            </thead>
            <tbody>
      `
      items.particulars.forEach((particular) => {
        particularsTable += `
            <tr>
              <td>${particular.name}</td>
              <td>${particular.allowance}</td>
            </tr>
        `
      })
      particularsTable += `
            </tbody>
          </table>
        `
    }

    // Products table
    if (items.products && items.products.length > 0) {
      productsTable = `
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Price</th>
                <th>Quantity</th>
                <th>Discount</th>
                <th>Total</th>
              </tr>
            </thead>
            <tbody>
      `
      items.products.forEach((product) => {
        productsTable += `
            <tr>
              <td>${product.name}</td>
              <td>${product.price}</td>
              <td>${product.quantity}</td>
              <td>${product.discount}</td>
              <td>${product.total}</td>
            </tr>
        `
      })
      productsTable += `
            </tbody>
          </table>
        `
    }

    this.itemsContainerTarget.innerHTML = particularsTable + productsTable
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
    })
  }
}
