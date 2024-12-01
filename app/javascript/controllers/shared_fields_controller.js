import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "description",
    "quantity",
    "unit",
    "descriptionField",
    "quantityField",
    "unitField",
  ]

  connect() {
    // this.element.addEventListener("submit", this.sync.bind(this))
  }

  // checkFields(event) {
  //   event.preventDefault()
  //   this.sync(event)

  //   console.log(
  //     this.descriptionFieldTargets.map((field) => field.value),
  //     this.quantityFieldTargets.map((field) => field.value),
  //     this.unitFieldTargets.map((field) => field.value)
  //   )
  // }

  // checkValues(event) {
  //   event.preventDefault()

  //   const descriptionValue = this.descriptionFieldTarget.value
  //   const quantityValue = this.quantityFieldTarget.value
  //   const unitValue = this.unitFieldTarget.value

  //   console.log(descriptionValue, quantityValue, unitValue)
  // }

  sync() {
    const descriptionValue = document.querySelector(
      'input[name="canvass[description]"]'
    ).value
    const quantityValue = document.querySelector(
      'input[name="canvass[quantity]"]'
    ).value
    const unitValue = document.querySelector(
      'input[name="canvass[unit]"]'
    ).value

    this.descriptionFieldTargets.forEach(
      (field) => (field.value = descriptionValue)
    )
    this.quantityFieldTargets.forEach((field) => (field.value = quantityValue))
    this.unitFieldTargets.forEach((field) => (field.value = unitValue))
  }
}
