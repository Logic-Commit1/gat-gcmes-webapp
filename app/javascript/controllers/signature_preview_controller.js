import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "container"]

  preview(event) {
    const fileInput = event.target
    const file = fileInput.files[0]

    if (file) {
      const reader = new FileReader()

      reader.onload = (e) => {
        const previewImage = document.getElementById("file-preview")
        const previewContainer = document.getElementById(
          "file-preview-container"
        )

        previewImage.src = e.target.result
        previewContainer.style.display = "block"
      }

      reader.readAsDataURL(file)
    }
  }
}
