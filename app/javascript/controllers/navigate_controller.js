import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  to(e) {
    e.preventDefault()
    
    const {url} = e.target.dataset
    console.log(url)

    this.element.src = url
  }
}