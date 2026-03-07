import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "preview", "picker", "hexText"]

  PRESET_COLORS = [
    "#ff0000","#ff6600","#ffcc00","#ffff00","#99ff00",
    "#00ff00","#00ffcc","#00ccff","#0066ff","#6600ff",
    "#cc00ff","#ff00cc","#ff69b4","#ffffff","#cccccc",
    "#808080","#333333","#000000","#8b4513","#ffd700"
  ]

  connect() {
    this.renderSwatches()
    this.updatePreview(this.inputTarget.value || "#ffffff")
  }

  renderSwatches() {
    // プリセットスウォッチ
    this.PRESET_COLORS.forEach(color => {
      const btn = document.createElement("button")
      btn.type  = "button"
      btn.style.backgroundColor = color
      btn.className = "w-7 h-7 rounded-full border-2 border-white shadow hover:scale-110 transition-transform flex-shrink-0"
      btn.addEventListener("click", () => this.selectColor(color))
      this.pickerTarget.appendChild(btn)
    })

    // ネイティブカラーピッカー
    const cp     = document.createElement("input")
    cp.type      = "color"
    cp.value     = this.inputTarget.value || "#ffffff"
    cp.className = "w-7 h-7 rounded cursor-pointer border border-pebble-200 flex-shrink-0"
    cp.addEventListener("input", e => {
      this.selectColor(e.target.value)
    })
    this.pickerTarget.appendChild(cp)
    this._cp = cp

    // hex テキスト入力の同期（DOM に target がある場合）
    if (this.hasHexTextTarget) {
      this.hexTextTarget.value = this.inputTarget.value || "#ffffff"
      this.hexTextTarget.addEventListener("input", e => {
        let val = e.target.value.trim()
        if (val && !val.startsWith("#")) val = "#" + val
        if (/^#[0-9a-fA-F]{6}$/.test(val)) {
          this.inputTarget.value = val
          this.updatePreview(val)
          if (this._cp) this._cp.value = val
        }
      })
    }
  }

  selectColor(color) {
    this.inputTarget.value = color
    this.updatePreview(color)
    if (this.hasHexTextTarget) this.hexTextTarget.value = color
    if (this._cp && this._cp.value !== color) this._cp.value = color
  }

  updatePreview(color) {
    this.previewTarget.style.backgroundColor = color
  }
}
