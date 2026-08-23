import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialogue"
export default class extends Controller {
  static targets = ["line", "submit"]

  connect() {
    this.revealUpToNextChoice(0)
  }

  revealUpToNextChoice(startIndex) {
    for (let i = startIndex; i < this.lineTargets.length; i++) {
      const line = this.lineTargets[i]
      if (line.classList.contains("hidden")) this.revealLine(line)

      const hasOptions = line.dataset.hasOptions === "true"
      const answered = line.querySelector('input[type="radio"]:checked') !== null

      if (hasOptions && !answered) return
    }

    this.submitTarget.classList.remove("hidden")
  }

  revealLine(line) {
    line.classList.remove("hidden")
    requestAnimationFrame(() => {
      requestAnimationFrame(() => {
        line.classList.remove("opacity-0", "translate-y-2")
        line.classList.add("opacity-100", "translate-y-0")
      })
    })
  }

  choose(event) {
    const line = event.currentTarget.closest('[data-dialogue-target="line"]')
    const index = parseInt(line.dataset.index, 10)
    this.revealUpToNextChoice(index + 1)
  }
}