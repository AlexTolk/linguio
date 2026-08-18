import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dropdown"
export default class extends Controller {
  static targets = ["menu"]

  toggle() {
    this.menuTarget.classList.toggle("hidden")
  }

  hide() {
    this.menuTarget.classList.add("hidden")
  }

  hideOnClickOutside(event) {
    if (!this.element.contains(event.target)) {
      this.hide()
    }
  }

  hideOnEscape(event) {
    if (event.key === "Escape") this.hide()
  }

  connect() {
    this.boundHideOnClickOutside = this.hideOnClickOutside.bind(this)
    this.boundHideOnEscape = this.hideOnEscape.bind(this)
    document.addEventListener("click", this.boundHideOnClickOutside)
    document.addEventListener("keydown", this.boundHideOnEscape)
  }

  disconnect() {
    document.removeEventListener("click", this.boundHideOnClickOutside)
    document.removeEventListener("keydown", this.boundHideOnEscape)
  }
}