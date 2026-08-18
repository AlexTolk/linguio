import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flashcard-set"
export default class extends Controller {
  static targets = ["card", "flipInner", "progress", "input", "submit"]

  connect() {
    this.index = 0
    this.graded = new Set()
    this.showCurrent()
  }

  showCurrent() {
    this.cardTargets.forEach((card, i) => {
      if (i === this.index) {
        card.classList.remove("opacity-0", "translate-x-6", "pointer-events-none")
        card.classList.add("opacity-100", "translate-x-0")
      } else {
        card.classList.remove("opacity-100", "translate-x-0")
        card.classList.add("opacity-0", "translate-x-6", "pointer-events-none")
      }
    })
    this.progressTarget.textContent = `Card ${Math.min(this.index + 1, this.cardTargets.length)} of ${this.cardTargets.length}`
  }

  flip() {
    this.flipInnerTargets[this.index].classList.toggle("flipped")
  }

  mark(event) {
    const known = event.params.known
    this.inputTargets[this.index].value = known
    this.graded.add(this.index)

    if (this.index < this.cardTargets.length - 1) {
      this.index += 1
      this.showCurrent()
    } else {
      this.progressTarget.textContent = "All cards reviewed"
    }

    if (this.graded.size === this.cardTargets.length) {
      this.submitTarget.disabled = false
    }
  }
}