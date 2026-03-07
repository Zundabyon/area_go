import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // buoyancy: 浮力セクション（スプーンは非表示）
  // colorBack: 裏カラーセクション（ミノーは非表示）
  // colorFrontLabel: 表カラーのラベル（ミノーは「カラー」に変更）
  static targets = ["buoyancy", "colorBack", "colorFrontLabel"]

  connect() {
    this._update()
  }

  update() {
    this._update()
  }

  _update() {
    const selected = this.element.querySelector('input[name*="lure_type"]:checked')
    const type     = selected?.value
    const isSpoon  = type === "spoon"
    const isMinnow = type === "minnow"

    // スプーンは浮力なし
    if (this.hasBuoyancyTarget) {
      this.buoyancyTarget.hidden = isSpoon
    }

    // ミノーは表裏なし（裏カラーを非表示）
    if (this.hasColorBackTarget) {
      this.colorBackTarget.hidden = isMinnow
    }

    // ミノーは「カラー（表）」→「カラー」に変える
    if (this.hasColorFrontLabelTarget) {
      this.colorFrontLabelTarget.textContent = isMinnow ? "カラー" : "カラー（表）"
    }
  }
}
