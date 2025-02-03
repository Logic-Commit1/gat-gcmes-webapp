import NestedForm from "@stimulus-components/rails-nested-form"

export default class extends NestedForm {
  connect() {
    super.connect()
  }

  addSpec(event) {
    event.preventDefault()

    this.showHiddenSpecTitles(event)

    // Find the closest nested form wrapper for the current product
    const targetWrapper = event.currentTarget.closest(".nested-form-wrapper")

    // Locate the template for specs (look within the current product wrapper)
    const template = targetWrapper.querySelector(
      '[data-nested-form-target="template"]'
    )

    if (!template) {
      console.error("Template not found for specifications")
      return
    }

    // Clone the template and replace the `NEW_SPEC_RECORD` placeholder with a unique timestamp
    const content = template.innerHTML.replace(
      /NEW_SPEC_RECORD/g,
      new Date().getTime()
    )

    // Insert the content into the target within the product's scope
    const target = targetWrapper.querySelector(
      '[data-nested-form-target="spec-target"]'
    )
    if (target) {
      target.insertAdjacentHTML("beforeend", content)
    }
  }

  removeSpec(event) {
    event.preventDefault()

    // Find the closest specification form wrapper
    const specWrapper = event.currentTarget.closest(".nested-spec-form")

    if (!specWrapper) {
      console.error("Specification form wrapper not found")
      return
    }

    // Mark the hidden _destroy field for this spec as true
    const destroyField = specWrapper.querySelector('input[name*="_destroy"]')
    if (destroyField) {
      destroyField.value = "1"
    }

    // Hide the specification form
    specWrapper.style.display = "none"
  }

  showHiddenSpecTitles(event) {
    // Find the closest nested form wrapper for the current button
    const targetWrapper = event.currentTarget.closest(".nested-form-wrapper")

    // Locate the hidden spec title within the same wrapper
    const hiddenSpecTitle = targetWrapper.querySelector(".hidden#spec-title")
    if (hiddenSpecTitle) {
      hiddenSpecTitle.classList.remove("hidden")
    }
  }

  addScope(event) {
    event.preventDefault()

    this.showHiddenScopeTitles(event)

    // Find the closest nested form wrapper for the current product
    const productWrapper = event.currentTarget.closest(".nested-form-wrapper")

    // Find the index of the current product
    const productIndexInput = productWrapper.querySelector(
      'input[name^="quotation[products_attributes]"]'
    )
    if (!productIndexInput) {
      console.error("Could not determine the product index")
      return
    }

    // Extract product index from the input name (e.g., "quotation[products_attributes][0][name]")
    const match = productIndexInput.name.match(
      /quotation\[products_attributes]\[([0-9]+)]/
    )
    if (!match) {
      console.error("Could not extract product index")
      return
    }

    // Generate a truly unique index for the new scope
    const uniqueScopeIndex = `${new Date().getTime().toString()}`

    // Locate the template for scopes
    const template = productWrapper.querySelector(
      '[data-nested-form-target="scope-template"]'
    )
    if (!template) {
      console.error("Template not found for scopes")
      return
    }

    // Create a deep copy of the template's content
    let content = template.innerHTML
    console.log("previouscontent", content)

    // Ensure all instances of `NEW_SCOPE_RECORD` are replaced properly
    content = content.replace(/NEW_SCOPE_RECORD/g, uniqueScopeIndex)

    // Debugging logs
    console.log("uniqueScopeIndex:", uniqueScopeIndex)
    console.log("Final content after replacement:", content)

    // Insert the content into the target within the product's scope
    const target = productWrapper.querySelector(
      '[data-nested-form-target="scope-target"]'
    )

    if (target) {
      target.insertAdjacentHTML("beforeend", content)
    }
  }

  removeScope(event) {
    event.preventDefault()

    // Find the closest scope form wrapper
    const scopeWrapper = event.currentTarget.closest(".nested-scope-form")

    if (!scopeWrapper) {
      console.error("Scope form wrapper not found")
      return
    }

    // Mark the hidden _destroy field for this scope as true
    const destroyField = scopeWrapper.querySelector('input[name*="_destroy"]')
    if (destroyField) {
      destroyField.value = "1"
    }

    // Hide the scope form
    scopeWrapper.style.display = "none"
  }

  showHiddenScopeTitles(event) {
    // Find the closest nested form wrapper for the current button
    const targetWrapper = event.currentTarget.closest(".nested-form-wrapper")

    // Locate the hidden scope title within the same wrapper
    const hiddenScopeTitle = targetWrapper.querySelector(".hidden#scope-title")
    if (hiddenScopeTitle) {
      hiddenScopeTitle.classList.remove("hidden")
    }
  }
}
