import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["manufacturer", "lureType", "lureName", "lureNameInput"]
  static values  = { lures: Object }

  // コントローラー接続時（ページ読み込み時）に既存値を復元
  connect() {
    const manufacturer = this.manufacturerTarget.value
    const lureType     = this.lureTypeTarget.value
    const lureName     = this.lureNameTarget.dataset.selected

    if (manufacturer) {
      this._populateLureTypes(manufacturer, lureType)
    }
    if (manufacturer && lureType) {
      this._populateLureNames(manufacturer, lureType, lureName)
    }
  }

  manufacturerChanged() {
    const manufacturer = this.manufacturerTarget.value

    // 種別・ルアー名をリセット
    this._resetSelect(this.lureTypeTarget,  "← 先にメーカーを選択")
    this._resetSelect(this.lureNameTarget,  "← 先に種別を選択")
    this.lureTypeTarget.disabled = true
    this.lureNameTarget.disabled = true

    if (!manufacturer) return
    this._populateLureTypes(manufacturer)
  }

  lureTypeChanged() {
    const manufacturer = this.manufacturerTarget.value
    const lureType     = this.lureTypeTarget.value

    this._resetSelect(this.lureNameTarget, "← 先に種別を選択")
    this.lureNameTarget.disabled = true

    if (!lureType) return
    this._populateLureNames(manufacturer, lureType)
  }

  // ── private ──────────────────────────────

  _populateLureTypes(manufacturer, selectedType = "") {
    const types = this.luresValue[manufacturer]
    const labels = { spoon: "スプーン", crankbait: "クランクベイト", minnow: "ミノー", other: "その他" }

    this._resetSelect(this.lureTypeTarget, "種別を選択")

    Object.entries(types).forEach(([type, names]) => {
      if (names.length === 0) return
      const opt = document.createElement("option")
      opt.value       = type
      opt.textContent = labels[type]
      opt.selected    = type === selectedType
      this.lureTypeTarget.appendChild(opt)
    })

    this.lureTypeTarget.disabled = false
  }

  _populateLureNames(manufacturer, lureType, selectedName = "") {
    const names = this.luresValue[manufacturer][lureType] || []

    this._resetSelect(this.lureNameTarget, "ルアーを選択")

    names.forEach(name => {
      const opt = document.createElement("option")
      opt.value       = name
      opt.textContent = name
      opt.selected    = name === selectedName
      this.lureNameTarget.appendChild(opt)
    })

    this.lureNameTarget.disabled = false
  }

  _resetSelect(selectEl, placeholder) {
    selectEl.innerHTML = `<option value="">${placeholder}</option>`
  }
}