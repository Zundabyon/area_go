// app/javascript/controllers/lure_select_controller.js
import { Controller } from "@hotwired/stimulus"

// data-controller="lure-select" をつけた要素を管理するコントローラーですわ
export default class extends Controller {

  // data-lure-select-target="xxx" で参照できる要素を宣言
  static targets = [
    "manufacturer", // メーカーのセレクトボックス
    "lureType",     // 種別のセレクトボックス
    "lureName"      // ルアー名のセレクトボックス
  ]

  // data-lure-select-lures-value にJSONを渡すと自動でthis.luresValueで取れますわ
  static values = {
    lures: Object  // Rubyの定数をJSONとして受け取る
  }

  // メーカーが変わったとき
  manufacturerChanged() {
    const manufacturer = this.manufacturerTarget.value

    // lure_typeをリセット
    this.lureTypeTarget.innerHTML = '<option value="">種別を選択</option>'
    this.lureNameTarget.innerHTML = '<option value="">ルアーを選択</option>'

    if (!manufacturer) return

    // 選択されたメーカーが持つ種別だけ表示（空配列の種別は除外）
    const types = this.luresValue[manufacturer]
    const typeLabels = {
      spoon:     "スプーン",
      crankbait: "クランクベイト",
      minnow:    "ミノー",
      other:     "その他"
    }

    Object.entries(types).forEach(([type, names]) => {
      if (names.length === 0) return  // ルアーが0件の種別はスキップ
      const option = document.createElement("option")
      option.value = type
      option.textContent = typeLabels[type]
      this.lureTypeTarget.appendChild(option)
    })
  }

  // 種別が変わったとき
  lureTypeChanged() {
    const manufacturer = this.manufacturerTarget.value
    const lureType     = this.lureTypeTarget.value

    // ルアー名をリセット
    this.lureNameTarget.innerHTML = '<option value="">ルアーを選択</option>'

    if (!manufacturer || !lureType) return

    // 選択されたメーカー＋種別のルアー名一覧を取得
    const names = this.luresValue[manufacturer][lureType] || []

    names.forEach(name => {
      const option = document.createElement("option")
      option.value = name
      option.textContent = name
      this.lureNameTarget.appendChild(option)
    })
  }
}