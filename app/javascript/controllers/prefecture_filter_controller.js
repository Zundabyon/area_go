import { Controller } from "@hotwired/stimulus"

// 北海道〜沖縄の標準地理順
const PREFECTURE_ORDER = [
  "北海道",
  "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
  "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
  "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県",
  "岐阜県", "静岡県", "愛知県",
  "三重県", "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
  "鳥取県", "島根県", "岡山県", "広島県", "山口県",
  "徳島県", "香川県", "愛媛県", "高知県",
  "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"
]

// 都道府県 → 施設の2段階絞り込みコントローラー
export default class extends Controller {
  static targets = ["prefectureSelect", "facilitySelect"]
  static values  = {
    facilities:        Array,   // [{ id, name, prefecture }, ...]
    initialPrefecture: String,
    initialFacilityId: String
  }

  connect() {
    this._populatePrefectures()

    // 編集モード: 既選択の都道府県・施設を復元
    if (this.initialPrefectureValue) {
      this.prefectureSelectTarget.value = this.initialPrefectureValue
      this._updateFacilities(this.initialFacilityIdValue)
    } else {
      this._updateFacilities()
    }
  }

  // data-action="change->prefecture-filter#filter"
  filter() {
    this._updateFacilities()
  }

  // data-action="change->prefecture-filter#facilityChanged"
  facilityChanged() {
    const id  = this.facilitySelectTarget.value
    const fac = this.facilitiesValue.find(f => f.id.toString() === id.toString())
    if (fac?.latitude && fac?.longitude) {
      this.dispatch("facility-selected", {
        detail: { lat: parseFloat(fac.latitude), lng: parseFloat(fac.longitude), name: fac.name },
        bubbles: true
      })
    }
  }

  // ─── private ────────────────────────────────────────────────────────────────

  _populatePrefectures() {
    const seen  = new Set()
    const prefs = []
    this.facilitiesValue.forEach(f => {
      if (f.prefecture && !seen.has(f.prefecture)) {
        seen.add(f.prefecture)
        prefs.push(f.prefecture)
      }
    })
    // 北海道〜沖縄の標準地理順で並べる
    prefs.sort((a, b) => {
      const ai = PREFECTURE_ORDER.indexOf(a)
      const bi = PREFECTURE_ORDER.indexOf(b)
      if (ai === -1 && bi === -1) return a.localeCompare(b, "ja")
      if (ai === -1) return 1
      if (bi === -1) return -1
      return ai - bi
    })

    const sel = this.prefectureSelectTarget
    prefs.forEach(pref => {
      const opt = document.createElement("option")
      opt.value = pref
      opt.textContent = pref
      sel.appendChild(opt)
    })
  }

  _updateFacilities(preSelectId = null) {
    const pref = this.prefectureSelectTarget.value
    const sel  = this.facilitySelectTarget

    // リセット
    sel.innerHTML = ""
    const blank = document.createElement("option")
    blank.value = ""
    blank.textContent = pref ? "施設を選択" : "← 先に都道府県を選択"
    sel.appendChild(blank)
    sel.disabled = !pref

    if (!pref) return

    const filtered = this.facilitiesValue.filter(f => f.prefecture === pref)
    filtered.forEach(facility => {
      const opt = document.createElement("option")
      opt.value       = facility.id
      opt.textContent = facility.name
      if (preSelectId && facility.id.toString() === preSelectId.toString()) {
        opt.selected = true
      }
      sel.appendChild(opt)
    })
  }
}
