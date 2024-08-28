import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["description", "quantity", "unit", "descriptionField", "quantityField", "unitField"];

  connect() {
  }

  sync(event) {
    // Correct usage to log all targets
    const targetType = event.target.getAttribute("name");
    const value = event.target.value;

    if (targetType === "shared_description") {
      this.descriptionFieldTargets.forEach(field => field.value = value);
    } else if (targetType === "shared_quantity") {
      this.quantityFieldTargets.forEach(field => field.value = value);
    } else if (targetType === "shared_unit") {
      this.unitFieldTargets.forEach(field => field.value = value);
    }
  }
}
