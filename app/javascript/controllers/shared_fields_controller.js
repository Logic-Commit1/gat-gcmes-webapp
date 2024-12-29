import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "description",
    "quantity",
    "unit",
    "brand",
    "descriptionField",
    "quantityField",
    "unitField",
    "brandField",
  ]

  connect() {
    this.element.addEventListener("submit", this.sync.bind(this))
  }

  checkFields(event) {
    event.preventDefault()
    this.sync(event)

    console.log(
      this.descriptionFieldTargets.map((field) => field.value),
      this.quantityFieldTargets.map((field) => field.value),
      this.unitFieldTargets.map((field) => field.value),
      this.brandFieldTargets.map((field) => field.value)
    )
  }

  checkValues(event) {
    event.preventDefault()

    const descriptionValue = this.descriptionFieldTarget.value
    const quantityValue = this.quantityFieldTarget.value
    const unitValue = this.unitFieldTarget.value
    const brandValue = this.brandFieldTarget.value
    console.log(descriptionValue, quantityValue, unitValue, brandValue)
  }

  sync() {
    console.log("1")
    const descriptionValue = document.querySelector(
      'input[name="canvass[description]"]'
    ).value
    console.log("2")
    const quantityValue = document.querySelector(
      'input[name="canvass[quantity]"]'
    ).value
    console.log("3")
    const unitValue = document.querySelector(
      'select[name="canvass[unit]"]'
    ).value
    console.log("4")
    const brandValue = document.querySelector(
      'input[name="canvass[brand]"]'
    ).value
    console.log("5")
    this.descriptionFieldTargets.forEach(
      (field) => (field.value = descriptionValue)
    )
    this.quantityFieldTargets.forEach((field) => (field.value = quantityValue))
    this.unitFieldTargets.forEach((field) => (field.value = unitValue))
    this.brandFieldTargets.forEach((field) => (field.value = brandValue))
  }
}
