import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "label"]

  LABELS = {
    1: "フローティング",
    2: "スローフローティング",
    3: "サスペンド",
    4: "スローシンキング",
    5: "シンキング"
  }

  connect() {
    this.updateLabel()
  }

  updateLabel() {
    const val = parseInt(this.inputTarget.value) || 3
    this.labelTarget.textContent = this.LABELS[val] || "サスペンド"
  }
}
