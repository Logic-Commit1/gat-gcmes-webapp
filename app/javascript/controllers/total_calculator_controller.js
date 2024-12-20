import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "subTotal",
    "vat",
    "total",
    "discount",
    "priceInput",
    "quantityInput",
  ]

  connect() {
    this.calculate()
  }

  calculate() {
    const subTotal = this.calculateSubTotal()
    const discountPercentage = this.getDiscountPercentage()
    const discountAmount = subTotal * (discountPercentage / 100)
    const discountedSubTotal = subTotal - discountAmount
    const vat = discountedSubTotal * 0.12
    const total = discountedSubTotal + vat

    this.subTotalTarget.textContent = `${this.formatNumber(subTotal)}`
    this.discountTarget.textContent = `- ${this.formatNumber(discountAmount)}`
    this.vatTarget.textContent = `${this.formatNumber(vat)}`
    this.totalTarget.textContent = `PHP ${this.formatNumber(total)}`
  }

  calculateSubTotal() {
    let sum = 0
    const rows = document.querySelectorAll(
      '.nested-form-wrapper:not([data-nested-form-target="template"])'
    )

    rows.forEach((row) => {
      const quantity =
        parseFloat(row.querySelector('input[name*="[quantity]"]').value) || 0
      const price =
        parseFloat(row.querySelector('input[name*="[price]"]').value) || 0
      sum += quantity * price
    })

    return sum
  }

  getDiscountPercentage() {
    const discountInput = document.querySelector(
      'input[name*="[discount_rate]"]'
    )
    return parseFloat(discountInput.value) || 0
  }

  formatNumber(value) {
    return new Intl.NumberFormat("en-PH", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value)
  }
}
