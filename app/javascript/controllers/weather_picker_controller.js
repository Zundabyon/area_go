import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["btn"]

  connect() {
    const selected = this.btnTargets.find(btn => btn.dataset.selected === "true")
    if (selected) this._setActive(selected)
  }

  select(event) {
    this._setActive(event.currentTarget)
  }

  _setActive(activeBtn) {
    this.btnTargets.forEach(btn => {
      const active = btn === activeBtn
      btn.classList.toggle("border-water-500", active)
      btn.classList.toggle("bg-water-50",      active)
      btn.classList.toggle("text-water-700",   active)
      btn.classList.toggle("border-pebble-200", !active)
      btn.classList.toggle("bg-white",         !active)
      btn.classList.toggle("text-pebble-600",  !active)
    })
  }
}
