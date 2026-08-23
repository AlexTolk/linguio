import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="fill-blank-carousel"
export default class extends Controller {
  static targets = ["card", "input", "progress", "prevButton", "nextButton", "submitButton"]

  connect() {
    this.index = 0
    this.showCurrent()
  }

  showCurrent() {
    this.cardTargets.forEach((card, i) => {
      if (i === this.index) {
        card.classList.remove("opacity-0", "translate-x-4", "pointer-events-none")
        card.classList.add("opacity-100", "translate-x-0")
      } else {
        card.classList.remove("opacity-100", "translate-x-0")
        card.classList.add("opacity-0", "translate-x-4", "pointer-events-none")
      }
    })

    this.progressTarget.textContent = `${this.index + 1} of ${this.cardTargets.length}`
    this.prevButtonTarget.classList.toggle("invisible", this.index === 0)

    const isLast = this.index === this.cardTargets.length - 1
    this.nextButtonTarget.classList.toggle("hidden", isLast)
    this.submitButtonTarget.classList.toggle("hidden", !isLast)

    this.updateNavState()
  }

  currentInput() {
    return this.inputTargets[this.index]
  }

  updateNavState() {
    const filled = this.currentInput().value.trim() !== ""
    this.nextButtonTarget.disabled = !filled
    this.submitButtonTarget.disabled = !filled
  }

  next() {
    if (this.currentInput().value.trim() === "") return
    if (this.index < this.cardTargets.length - 1) {
      this.index += 1
      this.showCurrent()
    }
  }

  prev() {
    if (this.index > 0) {
      this.index -= 1
      this.showCurrent()
    }
  }

  handleEnter(event) {
    event.preventDefault()
    if (this.nextButtonTarget.classList.contains("hidden")) {
      if (!this.submitButtonTarget.disabled) this.submitButtonTarget.click()
    } else {
      this.next()
    }
  }
  toggleHint(event) {
    const card = event.currentTarget.closest('[data-fill-blank-carousel-target="card"]')
    const hint = card.querySelector('[data-role="hint"]')
    hint.classList.toggle("invisible")
    event.currentTarget.textContent = hint.classList.contains("invisible") ? "show hint" : "hide hint"
  }
}