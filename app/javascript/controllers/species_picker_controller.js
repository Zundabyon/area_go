import { Controller } from "@hotwired/stimulus"

// 魚種選択コントローラー
// プリセット種名のドロップダウン + その他（自由入力）テキストを管理する
export default class extends Controller {
  static targets = ["select", "customWrapper", "customInput", "hiddenInput"]

  // 編集時: hidden inputの既存値をUIに反映
  connect() {
    const current = this.hiddenInputTarget.value
    if (!current) return

    const presets = Array.from(this.selectTarget.options).map(o => o.value).filter(v => v !== "" && v !== "__other__")

    if (presets.includes(current)) {
      this.selectTarget.value = current
    } else {
      // 既存値がプリセットにない → その他として表示
      this.selectTarget.value = "__other__"
      this.customInputTarget.value = current
      this.customWrapperTarget.classList.remove("hidden")
    }
  }

  // selectが変更されたとき
  selectChanged() {
    const val = this.selectTarget.value
    if (val === "__other__") {
      this.customWrapperTarget.classList.remove("hidden")
      this.hiddenInputTarget.value = this.customInputTarget.value
      this.customInputTarget.focus()
    } else {
      this.customWrapperTarget.classList.add("hidden")
      this.hiddenInputTarget.value = val
    }
  }

  // テキスト入力が変更されたとき
  customChanged() {
    this.hiddenInputTarget.value = this.customInputTarget.value
  }
}
