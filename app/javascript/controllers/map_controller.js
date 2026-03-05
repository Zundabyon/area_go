import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["container", "searchInput", "latInput", "lngInput", "placeIdInput", "facilityNameInput"]
  static values  = { mode: String, apiKey: String, pins: Array, initialLat: Number, initialLng: Number }

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
    const defaultCenter = {
      lat: this.hasInitialLatValue && this.initialLatValue !== 0 ? this.initialLatValue : 35.6812,
      lng: this.hasInitialLngValue && this.initialLngValue !== 0 ? this.initialLngValue : 139.7671
    }

    this.map = new google.maps.Map(this.containerTarget, {
      center: defaultCenter,
      zoom: 12,
      mapTypeId: "roadmap",
      styles: this.mapStyles()
    })

    if (this.modeValue === "facility_search") {
      this.initPlacesSearch()
    } else if (this.modeValue === "catch_pin") {
      this.initCatchPinMode()
    } else if (this.modeValue === "view") {
      this.renderPins()
    }
  }

  initPlacesSearch() {
    const autocomplete = new google.maps.places.Autocomplete(
      this.searchInputTarget,
      { types: ["establishment"], fields: ["place_id", "name", "geometry", "formatted_address"] }
    )
    autocomplete.bindTo("bounds", this.map)
    autocomplete.addListener("place_changed", () => {
      const place = autocomplete.getPlace()
      if (!place.geometry) return
      this.map.panTo(place.geometry.location)
      this.map.setZoom(16)
      if (this.hasLatInputTarget)           this.latInputTarget.value          = place.geometry.location.lat()
      if (this.hasLngInputTarget)           this.lngInputTarget.value          = place.geometry.location.lng()
      if (this.hasPlaceIdInputTarget)       this.placeIdInputTarget.value      = place.place_id
      if (this.hasFacilityNameInputTarget)  this.facilityNameInputTarget.value = place.name
      if (this.facilityMarker) this.facilityMarker.setMap(null)
      this.facilityMarker = new google.maps.Marker({
        map: this.map, position: place.geometry.location, title: place.name
      })
    })
  }

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

  renderPins() {
    const infoWindow = new google.maps.InfoWindow()
    const pins = this.pinsValue || []
    const bounds = new google.maps.LatLngBounds()
    pins.forEach(pin => {
      if (!pin.latitude || !pin.longitude) return
      const pos = { lat: parseFloat(pin.latitude), lng: parseFloat(pin.longitude) }
      const marker = new google.maps.Marker({ map: this.map, position: pos, title: `${pin.fish_species} ${pin.size_cm}cm` })
      bounds.extend(pos)
      marker.addListener("click", () => {
        infoWindow.setContent(`
          <div style="font-size:13px;padding:4px">
            <strong>${pin.fish_species} ${pin.size_cm ? pin.size_cm + "cm" : ""}</strong><br>
            ${pin.facility?.name || ""}<br>
            <a href="/catch_records/${pin.id}" style="color:#0e7490">詳細を見る</a>
          </div>
        `)
        infoWindow.open(this.map, marker)
      })
    })
    if (pins.length > 0) this.map.fitBounds(bounds)
  }

  mapStyles() {
    return [
      { featureType: "water",     stylers: [{ color: "#0e7490" }] },
      { featureType: "landscape", stylers: [{ color: "#d1fae5" }] },
      { featureType: "poi.park",  stylers: [{ color: "#6ee7b7" }] }
    ]
  }
}
