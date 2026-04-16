import { Controller } from "@hotwired/stimulus"

// 釣果フォーム内でルアーをその場で登録するコントローラー（フルスクリーンモーダル）
export default class extends Controller {
  static targets = ["select", "modal",
                    "nameInput", "manufacturerInput", "typeSelect",
                    "colorFrontInput", "colorFrontHex",
                    "colorBackWrapper", "colorBackInput", "colorBackHex",
                    "buoyancyWrapper", "buoyancySelect",
                    "weightInput", "error"]

  PRESET_COLORS = [
    "#ff0000","#ff6600","#ffcc00","#ffff00","#99ff00",
    "#00ff00","#00ffcc","#00ccff","#0066ff","#6600ff",
    "#cc00ff","#ff00cc","#ff69b4","#ffffff","#cccccc",
    "#808080","#333333","#000000","#8b4513","#ffd700"
  ]

  connect() {
    this._renderSwatches("colorFront")
    this._renderSwatches("colorBack")
    this._updateTypeFields()
    // Escape キーでモーダルを閉じる
    this._escHandler = (e) => { if (e.key === "Escape") this.close() }
    document.addEventListener("keydown", this._escHandler)
  }

  disconnect() {
    document.removeEventListener("keydown", this._escHandler)
  }

  // 「+ 新しいルアーを登録」ボタン
  open() {
    this.modalTarget.classList.remove("hidden")
    document.body.style.overflow = "hidden"
    this.nameInputTarget.focus()
  }

  // ✕ ボタン or Escape
  close() {
    this.modalTarget.classList.add("hidden")
    document.body.style.overflow = ""
    this.clearForm()
  }

  // 種類変更 → 浮力・裏カラー の表示制御
  typeChanged() {
    this._updateTypeFields()
  }

  _updateTypeFields() {
    const checked  = this.typeSelectTargets.find(r => r.checked)
    const type     = checked?.value || "spoon"
    const isSpoon  = type === "spoon"
    const isMinnow = type === "minnow"
    this.buoyancyWrapperTarget.hidden  = isSpoon
    this.colorBackWrapperTarget.hidden = isMinnow
  }

  // カラースウォッチを描画
  _renderSwatches(side) {
    // side = "colorFront" or "colorBack"
    const pickerId = `${side}Picker`
    const wrapper  = this.element.querySelector(`[data-inline-lure-picker="${pickerId}"]`)
    if (!wrapper) return

    const hiddenInput = side === "colorFront" ? this.colorFrontInputTarget : this.colorBackInputTarget
    const hexInput    = side === "colorFront" ? this.colorFrontHexTarget   : this.colorBackHexTarget
    const preview     = this.element.querySelector(`[data-inline-lure-preview="${side}"]`)

    const updateAll = (color) => {
      hiddenInput.value = color
      hexInput.value    = color
      if (preview) preview.style.backgroundColor = color
    }

    this.PRESET_COLORS.forEach(color => {
      const btn = document.createElement("button")
      btn.type  = "button"
      btn.style.backgroundColor = color
      btn.className = "w-7 h-7 rounded-full border-2 border-white shadow hover:scale-110 transition-transform flex-shrink-0"
      btn.addEventListener("click", () => { updateAll(color); if (cp) cp.value = color })
      wrapper.appendChild(btn)
    })

    const cp     = document.createElement("input")
    cp.type      = "color"
    cp.value     = hiddenInput.value || "#ffffff"
    cp.className = "w-7 h-7 rounded cursor-pointer border border-pebble-200 flex-shrink-0"
    cp.addEventListener("input", e => { updateAll(e.target.value) })
    wrapper.appendChild(cp)

    // hex テキスト同期
    hexInput.value = hiddenInput.value || "#ffffff"
    hexInput.addEventListener("input", e => {
      let val = e.target.value.trim()
      if (val && !val.startsWith("#")) val = "#" + val
      if (/^#[0-9a-fA-F]{6}$/.test(val)) {
        hiddenInput.value = val
        if (preview) preview.style.backgroundColor = val
        if (cp) cp.value = val
      }
    })
  }

  // 保存（fetch POST /lures JSON）
  async save(event) {
    event.preventDefault()
    this.errorTarget.textContent = ""

    const colorFront = this.colorFrontInputTarget.value || "#ffffff"
    const colorBack  = this.colorBackWrapperTarget.hidden ? colorFront : (this.colorBackInputTarget.value || "#ffffff")
    const buoyancy   = this.buoyancyWrapperTarget.hidden ? null : this.buoyancySelectTarget.value
    const checked    = this.typeSelectTargets.find(r => r.checked)
    const lureType   = checked?.value || "spoon"

    const body = {
      lure: {
        name:         this.nameInputTarget.value.trim(),
        manufacturer: this.manufacturerInputTarget.value.trim() || null,
        lure_type:    lureType,
        color_front:  colorFront,
        color_back:   colorBack,
        buoyancy:     buoyancy,
        weight:       this.weightInputTarget.value || ""
      }
    }

    try {
      const response = await fetch("/lures", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content,
          "Accept":       "application/json"
        },
        body: JSON.stringify(body)
      })

      const data = await response.json()

      if (response.ok) {
        const option = new Option(`${data.name} (${data.lure_type_label})`, data.id, true, true)
        this.selectTarget.add(option)
        this.selectTarget.value = data.id
        this.close()
      } else {
        this._showError((data.errors || []).join("、"))
      }
    } catch (e) {
      this._showError("通信エラーが発生しました")
    }
  }

  _showError(msg) {
    this.errorTarget.textContent = msg
    this.errorTarget.classList.remove("hidden")
  }

  clearForm() {
    this.nameInputTarget.value       = ""
    // radio を spoon にリセット
    this.typeSelectTargets.forEach(r => { r.checked = (r.value === "spoon") })
    // カラーリセット
    const white = "#ffffff"
    this.colorFrontInputTarget.value = white
    this.colorFrontHexTarget.value   = white
    this.colorBackInputTarget.value  = white
    this.colorBackHexTarget.value    = white
    this.element.querySelectorAll("[data-inline-lure-preview]").forEach(el => {
      el.style.backgroundColor = white
    })
    this.manufacturerInputTarget.value = ""
    this.buoyancySelectTarget.value      = "3"
    this.weightInputTarget.value         = ""
    this.errorTarget.textContent         = ""
    this.errorTarget.classList.add("hidden")
    this._updateTypeFields()
  }
}
