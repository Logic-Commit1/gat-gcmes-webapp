import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "subTotal",
    "vat",
    "total",
    "discount",
    "priceInput",
    "quantityInput",
    "allowanceTotal",
  ]

  connect() {
    if (this.hasAllowanceTotalTarget) {
      this.calculateAllowanceTotal()
    } else {
      this.calculate()
    }
  }

  calculate() {
    const subTotal = this.calculateSubTotal()
    const discountPercentage = this.getDiscountPercentage()
    const discountAmount = subTotal * (discountPercentage / 100)
    const discountedSubTotal = subTotal - discountAmount
    const vat = discountedSubTotal * 0.12
    const total = discountedSubTotal + vat

    // if no discount or vat, show subtotal
    if (
      !this.hasSubTotalTarget &&
      !this.hasDiscountTarget &&
      !this.hasVatTarget
    ) {
      this.totalTarget.textContent = `PHP ${this.formatNumber(subTotal)}`
      return
    }

    if (this.hasSubTotalTarget) {
      this.subTotalTarget.textContent = `PHP ${this.formatNumber(subTotal)}`
    }
    if (this.hasDiscountTarget) {
      this.discountTarget.textContent = `- ${this.formatNumber(discountAmount)}`
    }
    if (this.hasVatTarget) {
      this.vatTarget.textContent = `${this.formatNumber(vat)}`
    }
    this.totalTarget.textContent = `PHP ${this.formatNumber(total)}`
  }

  calculateSubTotal() {
    let sum = 0
    const rows = document.querySelectorAll(".product-row")
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
    if (this.hasDiscountTarget) {
      const discountInput = document.querySelector(
        'input[name*="[discount_rate]"]'
      )
      return parseFloat(discountInput.value) || 0
    }
    return 0
  }

  formatNumber(value) {
    return new Intl.NumberFormat("en-PH", {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    }).format(value)
  }

  calculateAllowanceTotal() {
    let sum = 0
    const rows = document.querySelectorAll(
      '.nested-form-wrapper:not([data-nested-form-target="template"])'
    )

    rows.forEach((row) => {
      const allowance =
        parseFloat(row.querySelector('input[name*="[allowance]"]')?.value) || 0
      sum += allowance
    })

    this.allowanceTotalTarget.textContent = `PHP ${this.formatNumber(sum)}`
  }
}
