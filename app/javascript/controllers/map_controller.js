import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "container", "searchInput",
    "latInput", "lngInput", "placeIdInput",
    "facilityNameInput", "addressInput", "prefectureInput", "phoneInput", "websiteInput"
  ]
  static values = { mode: String, apiKey: String, pins: Array, initialLat: Number, initialLng: Number }

  connect() {
    if (window.google?.maps) {
      this.initMap()
    } else {
      window._googleMapsCallbacks = window._googleMapsCallbacks || []
      window._googleMapsCallbacks.push(() => this.initMap())
      if (!document.querySelector('script[src*="maps.googleapis.com"]')) {
        window.initGoogleMaps = () => {
          window._googleMapsCallbacks.forEach(cb => cb())
          window._googleMapsCallbacks = []
        }
        const script  = document.createElement("script")
        script.src    = `https://maps.googleapis.com/maps/api/js?key=${this.apiKeyValue}&libraries=places&callback=initGoogleMaps`
        script.async  = true
        script.defer  = true
        document.head.appendChild(script)
      }
    }
  }

  initMap() {
    const hasPin     = this.hasInitialLatValue && this.initialLatValue !== 0
    const defaultCenter = {
      lat: hasPin ? this.initialLatValue  : 35.6812,
      lng: hasPin ? this.initialLngValue  : 139.7671
    }

    // Satellite (hybrid) for catch_pin and facility_search; road for overview
    const isSatellite = (this.modeValue === "catch_pin" || this.modeValue === "facility_search")
    const zoomByMode  = { catch_pin: 17, facility_search: 14, view: 11 }
    const zoom        = zoomByMode[this.modeValue] ?? 12

    this.map = new google.maps.Map(this.containerTarget, {
      center:    defaultCenter,
      zoom:      zoom,
      mapTypeId: isSatellite ? "hybrid" : "roadmap",
      mapTypeControl:        false,
      streetViewControl:     false,
      fullscreenControl:     false,
      gestureHandling:       "cooperative"
    })

    if (this.modeValue === "facility_search") {
      this.initPlacesSearch()
    } else if (this.modeValue === "catch_pin") {
      this.initCatchPinMode()
    } else if (this.modeValue === "view") {
      this.renderPins()
    }
  }

  // ─── 施設検索モード ─────────────────────────────────────────────────────────

  initPlacesSearch() {
    const autocomplete = new google.maps.places.Autocomplete(
      this.searchInputTarget,
      {
        types:  ["establishment"],
        fields: [
          "place_id", "name", "geometry",
          "formatted_address", "address_components",
          "international_phone_number", "website"
        ]
      }
    )
    autocomplete.bindTo("bounds", this.map)
    autocomplete.addListener("place_changed", () => {
      const place = autocomplete.getPlace()
      if (!place.geometry) return

      this.map.panTo(place.geometry.location)
      this.map.setZoom(18)

      // 地理情報
      if (this.hasLatInputTarget)     this.latInputTarget.value     = place.geometry.location.lat()
      if (this.hasLngInputTarget)     this.lngInputTarget.value     = place.geometry.location.lng()
      if (this.hasPlaceIdInputTarget) this.placeIdInputTarget.value = place.place_id

      // 施設情報を各フォームフィールドに自動入力
      if (this.hasFacilityNameInputTarget) this.facilityNameInputTarget.value = place.name || ""
      if (this.hasAddressInputTarget)      this.addressInputTarget.value      = place.formatted_address || ""
      if (this.hasPhoneInputTarget)        this.phoneInputTarget.value        = place.international_phone_number || ""
      if (this.hasWebsiteInputTarget)      this.websiteInputTarget.value      = place.website || ""

      // 都道府県を address_components から抽出
      if (this.hasPrefectureInputTarget && place.address_components) {
        const pref = place.address_components.find(c =>
          c.types.includes("administrative_area_level_1")
        )
        if (pref) this.prefectureInputTarget.value = pref.long_name
      }

      // マーカー設置
      if (this.facilityMarker) this.facilityMarker.setMap(null)
      this.facilityMarker = new google.maps.Marker({
        map: this.map, position: place.geometry.location, title: place.name
      })
    })
  }

  // ─── 釣果ピンモード ─────────────────────────────────────────────────────────

  initCatchPinMode() {
    if (this.hasInitialLatValue && this.initialLatValue !== 0) {
      this.placeCatchMarker({ lat: this.initialLatValue, lng: this.initialLngValue })
    }
    this.map.addListener("click", (event) => {
      if (this.hasLatInputTarget) this.latInputTarget.value = event.latLng.lat()
      if (this.hasLngInputTarget) this.lngInputTarget.value = event.latLng.lng()
      this.placeCatchMarker({ lat: event.latLng.lat(), lng: event.latLng.lng() })
    })
  }

  placeCatchMarker(position) {
    if (this.catchMarker) this.catchMarker.setMap(null)
    this.catchMarker = new google.maps.Marker({ map: this.map, position, draggable: true })
    this.catchMarker.addListener("dragend", (event) => {
      if (this.hasLatInputTarget) this.latInputTarget.value = event.latLng.lat()
      if (this.hasLngInputTarget) this.lngInputTarget.value = event.latLng.lng()
    })
  }

  // 施設選択時に呼ばれる: 施設の位置にマップを移動する
  panToFacility({ detail: { lat, lng, name } }) {
    if (!this.map) return
    const pos = { lat, lng }
    this.map.panTo(pos)
    this.map.setZoom(17)
    // 施設マーカーを表示（アイコンは釣り場を示すピン）
    if (this.facilityPinMarker) this.facilityPinMarker.setMap(null)
    this.facilityPinMarker = new google.maps.Marker({
      map:      this.map,
      position: pos,
      title:    name,
      icon: {
        path:        google.maps.SymbolPath.CIRCLE,
        scale:       8,
        fillColor:   "#0e7490",
        fillOpacity: 0.35,
        strokeColor: "#0e7490",
        strokeWeight: 2
      }
    })
  }

  // ─── 閲覧モード（複数ピン表示） ────────────────────────────────────────────

  renderPins() {
    const infoWindow = new google.maps.InfoWindow()
    const pins       = this.pinsValue || []
    const bounds     = new google.maps.LatLngBounds()
    pins.forEach(pin => {
      if (!pin.latitude || !pin.longitude) return
      const pos    = { lat: parseFloat(pin.latitude), lng: parseFloat(pin.longitude) }
      const marker = new google.maps.Marker({
        map: this.map, position: pos,
        title: `${pin.fish_species} ${pin.size_cm}cm`
      })
      bounds.extend(pos)
      marker.addListener("click", () => {
        const facility = pin.facility?.name ? `<div>${pin.facility.name}</div>` : ""
        const lure     = pin.lure?.name ? `<div>${pin.lure.name}</div>` : ""
        infoWindow.setContent(`
          <div style="font-size:13px;padding:4px">
            <strong>${pin.fish_species} ${pin.size_cm ? pin.size_cm + "cm" : ""}</strong><br>
            ${facility}
            ${lure}
            <a href="/catch_records/${pin.id}" style="color:#0e7490">詳細を見る</a>
          </div>
        `)
        infoWindow.open(this.map, marker)
      })
    })
    if (pins.length > 0) this.map.fitBounds(bounds)
  }
}
