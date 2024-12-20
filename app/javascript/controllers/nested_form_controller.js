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

    // Clone the template and replace the `NEW_RECORD` placeholder with a unique timestamp
    const content = template.innerHTML.replace(
      /NEW_RECORD/g,
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
}
