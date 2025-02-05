import NestedForm from "@stimulus-components/rails-nested-form"

export default class extends NestedForm {
  connect() {
    super.connect()
  }

  // Helper function to get a unique timestamp with a small delay
  getUniqueTimestamp() {
    return new Promise((resolve) =>
      setTimeout(() => resolve(new Date().getTime()), 1)
    )
  }

  // Helper to trigger calculation after DOM updates
  triggerCalculation() {
    requestAnimationFrame(() => {
      const calculatorController =
        this.application.getControllerForElementAndIdentifier(
          document.querySelector("[data-controller~='total-calculator']"),
          "total-calculator"
        )
      if (calculatorController) {
        calculatorController.calculate()
      }
    })
  }

  async duplicate(event) {
    event.preventDefault()

    // Find the product wrapper to duplicate
    const productWrapper = event.currentTarget.closest(".nested-form-wrapper")
    if (!productWrapper) return

    // Get all input fields from the current product
    const inputs = productWrapper.querySelectorAll(
      'input:not([type="hidden"]), select'
    )
    const values = {}

    // Store current values, excluding file field
    inputs.forEach((input) => {
      if (input.type === "file") return // Skip file inputs
      values[input.name] = input.value
    })

    // Get the template for a new product
    const template = document.querySelector(
      '[data-nested-form-target="template"]'
    )
    if (!template) return

    // Create new product with a unique timestamp
    const productTimestamp = await this.getUniqueTimestamp()
    const content = template.innerHTML.replace(/NEW_RECORD/g, productTimestamp)

    // Insert the new product after the current one
    productWrapper.insertAdjacentHTML("afterend", content)

    // Find the newly added product wrapper (it's the next sibling of the current wrapper)
    const newProductWrapper = productWrapper.nextElementSibling

    // Copy values to the new product's inputs
    Object.entries(values).forEach(([name, value]) => {
      const newInput = newProductWrapper.querySelector(
        `[name="${name.replace(/\[\d+\]/, `[${productTimestamp}]`)}"]`
      )
      if (newInput) {
        newInput.value = value
      }
    })

    await this.copySpecs(productWrapper, newProductWrapper, productTimestamp)
    await this.copyScopes(productWrapper, newProductWrapper, productTimestamp)
    this.triggerCalculation()
  }

  async copySpecs(productWrapper, newProductWrapper, productTimestamp) {
    const specs = productWrapper.querySelectorAll(".nested-spec-form")
    if (specs.length === 0) return

    const specTemplate = productWrapper.querySelector(
      '[data-nested-form-target="spec-template"]'
    )
    const specTarget = newProductWrapper.querySelector(
      '[data-nested-form-target="spec-target"]'
    )

    // Process specs sequentially to ensure unique timestamps
    for (const spec of specs) {
      if (spec.style.display === "none") continue

      const nameInput = spec.querySelector('input[name*="[name]"]')
      const valueInput = spec.querySelector('input[name*="[value]"]')
      if (!nameInput || !valueInput) continue

      const specTimestamp = await this.getUniqueTimestamp()
      let specContent = specTemplate.innerHTML
        .replace(
          /\[products_attributes\]\[\d+\]/g,
          `[products_attributes][${productTimestamp}]`
        )
        .replace(/NEW_SPEC_RECORD/g, specTimestamp)

      specTarget.insertAdjacentHTML("beforeend", specContent)

      const newSpec = specTarget.lastElementChild
      const newSpecNameInput = newSpec.querySelector(
        `input[name*="[specs_attributes][${specTimestamp}][name]"]`
      )
      const newSpecValueInput = newSpec.querySelector(
        `input[name*="[specs_attributes][${specTimestamp}][value]"]`
      )

      if (newSpecNameInput && newSpecValueInput) {
        newSpecNameInput.value = nameInput.value
        newSpecValueInput.value = valueInput.value
      }
    }
  }

  async copyScopes(productWrapper, newProductWrapper, productTimestamp) {
    const scopes = productWrapper.querySelectorAll(".nested-scope-form")
    if (scopes.length === 0) return

    const scopeTemplate = productWrapper.querySelector(
      '[data-nested-form-target="scope-template"]'
    )
    const scopeTarget = newProductWrapper.querySelector(
      '[data-nested-form-target="scope-target"]'
    )

    // Process scopes sequentially to ensure unique timestamps
    for (const scope of scopes) {
      if (scope.style.display === "none") continue

      const nameInput = scope.querySelector('input[name*="[name]"]')
      if (!nameInput) continue

      const scopeTimestamp = await this.getUniqueTimestamp()
      let scopeContent = scopeTemplate.innerHTML
        .replace(
          /\[products_attributes\]\[\d+\]/g,
          `[products_attributes][${productTimestamp}]`
        )
        .replace(/NEW_SCOPE_RECORD/g, scopeTimestamp)

      scopeTarget.insertAdjacentHTML("beforeend", scopeContent)

      const newScope = scopeTarget.lastElementChild
      const newScopeNameInput = newScope.querySelector(
        `input[name*="[scopes_attributes][${scopeTimestamp}][name]"]`
      )

      if (newScopeNameInput) {
        newScopeNameInput.value = nameInput.value
      }
    }
  }
}
