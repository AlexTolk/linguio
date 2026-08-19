import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="matching"
export default class extends Controller {
  static targets = ["left", "right", "input", "submit"]

  connect() {
    this.selectedLeft = null
    this.updateSubmitState()
  }

  selectLeft(event) {
    const el = event.currentTarget

    if (el.classList.contains("matched")) {
      this.unmatch(el.dataset.matchingKey)
      return
    }

    this.leftTargets.forEach((l) => l.classList.remove("border-primary-900", "bg-primary-100", "text-primary-900"))

    if (this.selectedLeft === el) {
      this.selectedLeft = null
      return
    }

    el.classList.add("border-primary-900", "bg-primary-100", "text-primary-900")
    this.selectedLeft = el
  }

  selectRight(event) {
    const el = event.currentTarget

    if (el.classList.contains("matched")) {
      this.unmatch(el.dataset.matchingMatchedLeft)
      return
    }

    if (!this.selectedLeft) return

    const leftEl = this.selectedLeft
    const leftKey = leftEl.dataset.matchingKey
    const rightValue = el.dataset.matchingValue

    const input = this.inputTargets.find((i) => i.dataset.matchingKey === leftKey)
    input.value = rightValue

    leftEl.classList.remove("border-primary-900", "bg-primary-100", "text-primary-900")
    leftEl.classList.add("matched", "border-success-700", "bg-success-100", "text-success-700")
    el.classList.add("matched", "border-success-700", "bg-success-100", "text-success-700")

    leftEl.dataset.matchingMatchedRight = rightValue
    el.dataset.matchingMatchedLeft = leftKey

    this.selectedLeft = null
    this.updateSubmitState()
  }

  unmatch(leftKey) {
    const leftEl = this.leftTargets.find((l) => l.dataset.matchingKey === leftKey)
    if (!leftEl) return

    const rightValue = leftEl.dataset.matchingMatchedRight
    const rightEl = this.rightTargets.find((r) => r.dataset.matchingValue === rightValue)

    leftEl.classList.remove("matched", "border-success-700", "bg-success-100", "text-success-700")
    if (rightEl) rightEl.classList.remove("matched", "border-success-700", "bg-success-100", "text-success-700")

    const input = this.inputTargets.find((i) => i.dataset.matchingKey === leftKey)
    input.value = ""

    this.updateSubmitState()
  }

  updateSubmitState() {
    const allMatched = this.inputTargets.every((i) => i.value !== "")
    this.submitTarget.disabled = !allMatched
  }
}