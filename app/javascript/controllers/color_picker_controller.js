import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "picker"]

  PRESET_COLORS = [
    "#ff0000","#ff6600","#ffcc00","#ffff00","#00ff00",
    "#00ccff","#0066ff","#9900ff","#ff69b4","#ffffff",
    "#cccccc","#808080","#000000","#8b4513","#ffd700"
  ]

  connect() {
    this.renderSwatches()
    this.updatePreview(this.inputTarget.value || "#ffffff")
  }

  renderSwatches() {
    this.PRESET_COLORS.forEach(color => {
      const btn = document.createElement("button")
      btn.type  = "button"
      btn.style.backgroundColor = color
      btn.className = "w-6 h-6 rounded-full border-2 border-white shadow hover:scale-110 transition-transform"
      btn.addEventListener("click", () => this.selectColor(color))
      this.pickerTarget.appendChild(btn)
    })
    const cp  = document.createElement("input")
    cp.type   = "color"
    cp.value  = this.inputTarget.value || "#ffffff"
    cp.className = "w-6 h-6 rounded cursor-pointer border border-pebble-200"
    cp.addEventListener("input", e => this.selectColor(e.target.value))
    this.pickerTarget.appendChild(cp)
  }

  selectColor(color) {
    this.inputTarget.value = color
    this.updatePreview(color)
  }

  updatePreview(color) {
    this.previewTarget.style.backgroundColor = color
  }
}
