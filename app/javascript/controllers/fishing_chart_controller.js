import { Controller } from "@hotwired/stimulus"

// ─── Constants ───────────────────────────────────────────────────────────────
const SKY      = 0.12    // sky occupies top 12% of canvas
const MIN_BR   = 0.30    // minimum bottomRatio (can't drag above here)
const MAX_BR   = 0.97    // maximum bottomRatio
const MAX_DEPT = 5       // reference scale in meters (area trout ponds: 0-5 m)
const HANDLE_R = 10      // hit-test radius for bottom handles (px)
const DEFAULT_BOTTOM = 0.88  // default visual position (lower = more water visible)

// X positions (ratio) of the 3 bottom control handles
const HANDLE_DEFS = [
  { key: "left",   xr: 0.15 },
  { key: "center", xr: 0.50 },
  { key: "right",  xr: 0.85 },
]

// ─── Controller ──────────────────────────────────────────────────────────────
export default class extends Controller {
  static targets = ["canvas", "dataInput", "colorPicker", "lineWidth", "depthInput", "modeBtn"]
  static values  = {
    depth:        { type: Number,  default: 5 },
    readonly:     { type: Boolean, default: false },
    existingData: String
  }

  connect() {
    this.canvas       = this.canvasTarget
    this.ctx          = this.canvas.getContext("2d")
    this.actions      = []    // completed actions (strokes + stamps)
    this.current      = null  // stroke in progress
    this.isDrawing    = false
    this.mode         = "draw"           // "draw" | "stamp_fish" | "stamp_hit"
    this.dragHandle   = null             // "left" | "center" | "right" | null

    // Bottom shape: 3 Y-ratio control points
    this.bottomPoints = { left: 0.85, center: 0.85, right: 0.85 }

    this.setupCanvas()
    this._loadExistingData()
    this.redraw()

    if (!this.readonlyValue) {
      this.bindEvents()
      this.setMode("draw")   // initialise button styles
    }
  }

  // ─── Data loading ───────────────────────────────────────────────────────────

  _loadExistingData() {
    let bottomFromData = false
    if (this.existingDataValue) {
      try {
        const data = JSON.parse(this.existingDataValue)

        // actions (v2) or legacy strokes (v1)
        if (data.actions) {
          this.actions = data.actions
        } else if (data.strokes) {
          this.actions = data.strokes  // type:"path" — handled in redraw()
        }

        // bottom shape
        if (data.bottomPoints) {
          this.bottomPoints = data.bottomPoints
          bottomFromData = true
        } else if (data.bottomRatio != null) {
          const r = data.bottomRatio
          this.bottomPoints = { left: r, center: r, right: r }
          bottomFromData = true
        }
      } catch (e) {}
    }

    if (!bottomFromData) {
      // Always start at the default visual position — user can drag to adjust
      this.bottomPoints = { left: DEFAULT_BOTTOM, center: DEFAULT_BOTTOM, right: DEFAULT_BOTTOM }
    }
  }

  // ─── Math helpers ───────────────────────────────────────────────────────────

  _depthToRatio(depth) {
    const t = Math.min(Math.max(depth, 0), MAX_DEPT) / MAX_DEPT
    return MIN_BR + t * (MAX_BR - MIN_BR)
  }

  _ratioToDepth(ratio) {
    const t = (ratio - MIN_BR) / (MAX_BR - MIN_BR)
    return Math.round(Math.max(t * MAX_DEPT, 0) * 10) / 10  // 0.1 m precision
  }

  // Quadratic bezier control Y so the curve passes through center at x = w/2
  _bottomCtrl() {
    const { left: l, center: c, right: r } = this.bottomPoints
    return Math.max(SKY + 0.02, 2 * c - 0.5 * (l + r))
  }

  _findHandle(pos) {
    for (const h of HANDLE_DEFS) {
      const hx = this.cssWidth  * h.xr
      const hy = this.cssHeight * this.bottomPoints[h.key]
      const dx = pos.x - hx
      const dy = pos.y - hy
      if (Math.sqrt(dx * dx + dy * dy) <= HANDLE_R + 4) return h.key
    }
    return null
  }

  _currentDepth() {
    if (this.hasDepthInputTarget) {
      const v = parseFloat(this.depthInputTarget.value)
      if (!isNaN(v)) return v
    }
    return this.depthValue
  }

  // ─── Canvas setup ───────────────────────────────────────────────────────────

  setupCanvas() {
    const dpr          = window.devicePixelRatio || 1
    const rect         = this.canvas.getBoundingClientRect()
    const w            = rect.width  || 300
    const h            = rect.height || 260
    this.canvas.width  = w * dpr
    this.canvas.height = h * dpr
    this.ctx.scale(dpr, dpr)
    this.cssWidth  = w
    this.cssHeight = h
  }

  // ─── Drawing ────────────────────────────────────────────────────────────────

  drawBackground() {
    const ctx  = this.ctx
    const w    = this.cssWidth
    const h    = this.cssHeight
    const { left: l, center: c, right: r } = this.bottomPoints
    const ctrl = this._bottomCtrl()
    const maxBR = Math.max(l, c, r)
    const minBR = Math.min(l, c, r)

    // 空
    const skyGrad = ctx.createLinearGradient(0, 0, 0, h * SKY)
    skyGrad.addColorStop(0, "#bae6fd")
    skyGrad.addColorStop(1, "#7dd3fc")
    ctx.fillStyle = skyGrad
    ctx.fillRect(0, 0, w, h * SKY)

    // 水中（底の形に合わせたパス）
    const waterGrad = ctx.createLinearGradient(0, h * SKY, 0, h * maxBR)
    waterGrad.addColorStop(0,   "#06b6d4")
    waterGrad.addColorStop(0.6, "#0e7490")
    waterGrad.addColorStop(1,   "#164e63")
    ctx.fillStyle = waterGrad
    ctx.beginPath()
    ctx.moveTo(0, h * SKY)
    ctx.lineTo(w, h * SKY)
    ctx.lineTo(w, h * r)
    ctx.quadraticCurveTo(w / 2, h * ctrl, 0, h * l)
    ctx.closePath()
    ctx.fill()

    // 川底（底の形に合わせたパス）
    const bottomGrad = ctx.createLinearGradient(0, h * minBR, 0, h)
    bottomGrad.addColorStop(0, "#92400e")
    bottomGrad.addColorStop(1, "#78350f")
    ctx.fillStyle = bottomGrad
    ctx.beginPath()
    ctx.moveTo(0, h * l)
    ctx.quadraticCurveTo(w / 2, h * ctrl, w, h * r)
    ctx.lineTo(w, h)
    ctx.lineTo(0, h)
    ctx.closePath()
    ctx.fill()

    // 水面の破線
    ctx.strokeStyle = "rgba(255,255,255,0.5)"
    ctx.lineWidth   = 1.5
    ctx.setLineDash([8, 4])
    ctx.beginPath(); ctx.moveTo(0, h * SKY); ctx.lineTo(w, h * SKY); ctx.stroke()
    ctx.setLineDash([])

    // 底ライン + ハンドル（編集時のみ）
    if (!this.readonlyValue) {
      // 底の曲線（オレンジ破線）
      ctx.strokeStyle = "rgba(255, 200, 80, 0.65)"
      ctx.lineWidth   = 2
      ctx.setLineDash([5, 5])
      ctx.beginPath()
      ctx.moveTo(0, h * l)
      ctx.quadraticCurveTo(w / 2, h * ctrl, w, h * r)
      ctx.stroke()
      ctx.setLineDash([])

      // 3つのドラッグハンドル
      HANDLE_DEFS.forEach(({ key, xr }) => {
        const hx     = w * xr
        const hy     = h * this.bottomPoints[key]
        const active = this.dragHandle === key
        ctx.beginPath()
        ctx.arc(hx, hy, active ? HANDLE_R + 2 : HANDLE_R, 0, Math.PI * 2)
        ctx.fillStyle   = active ? "rgba(255,220,50,1)" : "rgba(255,200,80,0.85)"
        ctx.fill()
        ctx.strokeStyle = "#78350f"
        ctx.lineWidth   = 1.5
        ctx.stroke()
        // 矢印テキスト
        ctx.fillStyle    = "#78350f"
        ctx.font         = "bold 8px sans-serif"
        ctx.textAlign    = "center"
        ctx.textBaseline = "middle"
        ctx.fillText("↕", hx, hy)
      })
      ctx.textBaseline = "alphabetic"
    }

    // ラベル
    ctx.fillStyle = "rgba(255,255,255,0.85)"
    ctx.font      = "11px sans-serif"
    ctx.textAlign = "left"
    ctx.fillText("水面", 6, h * SKY - 4)
    ctx.fillText("底", 6, h * c + 14)
  }

  redraw() {
    this.ctx.clearRect(0, 0, this.cssWidth, this.cssHeight)
    this.drawBackground()
    this.actions.forEach(a => {
      if (a.type === "stroke" || a.type === "path") this.drawStroke(a)
      else if (a.type === "stamp") this.drawStamp(a)
    })
  }

  drawStroke(stroke) {
    if (!stroke.points || stroke.points.length < 2) return
    const ctx       = this.ctx
    ctx.strokeStyle = stroke.color
    ctx.lineWidth   = stroke.width
    ctx.lineCap     = "round"
    ctx.lineJoin    = "round"
    ctx.beginPath()
    ctx.moveTo(stroke.points[0].x, stroke.points[0].y)
    stroke.points.slice(1).forEach(p => ctx.lineTo(p.x, p.y))
    ctx.stroke()
  }

  drawStamp(stamp) {
    const ctx = this.ctx
    ctx.save()
    if (stamp.kind === "fish") {
      // Fish emoji stamp
      ctx.shadowColor  = "rgba(0,0,0,0.55)"
      ctx.shadowBlur   = 4
      ctx.font         = "26px sans-serif"
      ctx.textAlign    = "center"
      ctx.textBaseline = "middle"
      ctx.fillText("🐟", stamp.x, stamp.y)
    } else if (stamp.kind === "hit") {
      // Red circle badge with HIT text
      ctx.shadowColor = "rgba(0,0,0,0.45)"
      ctx.shadowBlur  = 4
      ctx.beginPath()
      ctx.arc(stamp.x, stamp.y, 15, 0, Math.PI * 2)
      ctx.fillStyle = "#ef4444"
      ctx.fill()
      ctx.shadowBlur   = 0
      ctx.fillStyle    = "#ffffff"
      ctx.font         = "bold 9px sans-serif"
      ctx.textAlign    = "center"
      ctx.textBaseline = "middle"
      ctx.fillText("HIT!", stamp.x, stamp.y)
    }
    ctx.restore()
  }

  // ─── Events ─────────────────────────────────────────────────────────────────

  bindEvents() {
    this.canvas.addEventListener("mousedown",  this._startDraw.bind(this))
    this.canvas.addEventListener("mousemove",  this._onMove.bind(this))
    this.canvas.addEventListener("mouseup",    this._endDraw.bind(this))
    this.canvas.addEventListener("mouseleave", this._endDraw.bind(this))
    this.canvas.addEventListener("touchstart", this._startTouch.bind(this), { passive: false })
    this.canvas.addEventListener("touchmove",  this._moveTouch.bind(this),  { passive: false })
    this.canvas.addEventListener("touchend",   this._endDraw.bind(this))
  }

  _getPos(event) {
    const rect = this.canvas.getBoundingClientRect()
    return { x: event.clientX - rect.left, y: event.clientY - rect.top }
  }

  _startDraw(event) {
    const pos    = this._getPos(event)
    const handle = this._findHandle(pos)

    // Bottom handle drag takes priority
    if (handle) {
      this.dragHandle = handle
      this.canvas.style.cursor = "ns-resize"
      return
    }

    // Stamp placement
    if (this.mode === "stamp_fish" || this.mode === "stamp_hit") {
      const kind = this.mode === "stamp_fish" ? "fish" : "hit"
      this.actions.push({ type: "stamp", kind, x: pos.x, y: pos.y })
      this.redraw()
      this.saveToInput()
      return
    }

    // Draw mode — start a new stroke
    this.isDrawing = true
    this.current = {
      type:   "stroke",
      color:  this.hasColorPickerTarget ? this.colorPickerTarget.value : "#0ea5e9",
      width:  this.hasLineWidthTarget   ? parseInt(this.lineWidthTarget.value) : 4,
      points: [pos]
    }
  }

  _onMove(event) {
    const pos = this._getPos(event)

    // Drag handle
    if (this.dragHandle) {
      this._doDragHandle(pos.y)
      return
    }

    // Cursor hint
    this.canvas.style.cursor = this._findHandle(pos) ? "ns-resize" : "crosshair"

    // Live stroke drawing
    if (!this.isDrawing || !this.current) return
    this.current.points.push(pos)
    const pts = this.current.points
    if (pts.length >= 2) {
      const ctx       = this.ctx
      ctx.strokeStyle = this.current.color
      ctx.lineWidth   = this.current.width
      ctx.lineCap     = "round"
      ctx.lineJoin    = "round"
      ctx.beginPath()
      ctx.moveTo(pts[pts.length - 2].x, pts[pts.length - 2].y)
      ctx.lineTo(pts[pts.length - 1].x, pts[pts.length - 1].y)
      ctx.stroke()
    }
  }

  _endDraw() {
    if (this.dragHandle) {
      this.dragHandle = null
      this.canvas.style.cursor = "crosshair"
      this.saveToInput()
      return
    }
    if (!this.isDrawing || !this.current) return
    this.isDrawing = false
    if (this.current.points.length > 1) {
      this.actions.push(this.current)
      this.saveToInput()
    }
    this.current = null
  }

  _startTouch(event) {
    event.preventDefault()
    const t = event.touches[0]
    this._startDraw({ clientX: t.clientX, clientY: t.clientY })
  }

  _moveTouch(event) {
    event.preventDefault()
    const t = event.touches[0]
    this._onMove({ clientX: t.clientX, clientY: t.clientY })
  }

  // ─── Bottom handle drag ─────────────────────────────────────────────────────

  _doDragHandle(y) {
    const newRatio = Math.min(Math.max(y / this.cssHeight, MIN_BR), MAX_BR)
    this.bottomPoints[this.dragHandle] = newRatio
    this.redraw()
  }

  // ─── Mode switching ─────────────────────────────────────────────────────────

  setMode(mode) {
    this.mode = mode
    this.canvas.style.cursor = "crosshair"
    if (this.hasModeBtnTarget) {
      this.modeBtnTargets.forEach(btn => {
        const active = btn.dataset.mode === mode
        btn.classList.toggle("bg-water-500", active)
        btn.classList.toggle("text-white",   active)
        btn.classList.toggle("bg-pebble-50",      !active)
        btn.classList.toggle("text-pebble-700",   !active)
      })
    }
  }

  setModeDraw()      { this.setMode("draw") }
  setModeStampFish() { this.setMode("stamp_fish") }
  setModeStampHit()  { this.setMode("stamp_hit") }

  // ─── Stimulus actions ───────────────────────────────────────────────────────

  depthInputChanged() {
    // Intentionally decoupled — depth_m field no longer drives the bottom shape
  }

  undo() {
    this.actions.pop()
    this.redraw()
    this.saveToInput()
  }

  clear() {
    this.actions = []
    this.redraw()
    this.saveToInput()
  }

  // ─── Persistence ────────────────────────────────────────────────────────────

  saveToInput() {
    if (!this.hasDataInputTarget) return
    this.dataInputTarget.value = JSON.stringify({
      version:       2,
      canvas_width:  this.cssWidth,
      canvas_height: this.cssHeight,
      water_depth:   this._currentDepth(),
      bottomPoints:  this.bottomPoints,
      actions:       this.actions
    })
  }
}
