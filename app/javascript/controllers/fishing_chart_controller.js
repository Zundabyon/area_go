import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["canvas", "dataInput", "colorPicker", "lineWidth"]
  static values  = { depth: { type: Number, default: 5 }, readonly: { type: Boolean, default: false }, existingData: String }

  connect() {
    this.canvas    = this.canvasTarget
    this.ctx       = this.canvas.getContext("2d")
    this.strokes   = []
    this.current   = null
    this.isDrawing = false

    this.setupCanvas()
    this.drawBackground()

    if (this.existingDataValue) {
      try {
        const data   = JSON.parse(this.existingDataValue)
        this.strokes = data.strokes || []
        this.redraw()
      } catch (e) {}
    }

    if (!this.readonlyValue) this.bindEvents()
  }

  setupCanvas() {
    const dpr         = window.devicePixelRatio || 1
    const rect        = this.canvas.getBoundingClientRect()
    const w           = rect.width  || 300
    const h           = rect.height || 260
    this.canvas.width  = w * dpr
    this.canvas.height = h * dpr
    this.ctx.scale(dpr, dpr)
    this.cssWidth  = w
    this.cssHeight = h
  }

  drawBackground() {
    const ctx = this.ctx
    const w   = this.cssWidth
    const h   = this.cssHeight

    // 空
    const skyGrad = ctx.createLinearGradient(0, 0, 0, h * 0.12)
    skyGrad.addColorStop(0, "#bae6fd")
    skyGrad.addColorStop(1, "#7dd3fc")
    ctx.fillStyle = skyGrad
    ctx.fillRect(0, 0, w, h * 0.12)

    // 水中
    const waterGrad = ctx.createLinearGradient(0, h * 0.12, 0, h * 0.85)
    waterGrad.addColorStop(0, "#06b6d4")
    waterGrad.addColorStop(0.5, "#0e7490")
    waterGrad.addColorStop(1, "#164e63")
    ctx.fillStyle = waterGrad
    ctx.fillRect(0, h * 0.12, w, h * 0.73)

    // 底
    const bottomGrad = ctx.createLinearGradient(0, h * 0.85, 0, h)
    bottomGrad.addColorStop(0, "#92400e")
    bottomGrad.addColorStop(1, "#78350f")
    ctx.fillStyle = bottomGrad
    ctx.fillRect(0, h * 0.85, w, h * 0.15)

    // 水面ライン
    ctx.strokeStyle = "rgba(255,255,255,0.5)"
    ctx.lineWidth   = 1.5
    ctx.setLineDash([8, 4])
    ctx.beginPath()
    ctx.moveTo(0, h * 0.12)
    ctx.lineTo(w, h * 0.12)
    ctx.stroke()
    ctx.setLineDash([])

    // ラベル
    ctx.fillStyle = "rgba(255,255,255,0.75)"
    ctx.font      = "11px sans-serif"
    ctx.textAlign = "left"
    ctx.fillText("水面", 6, h * 0.12 - 4)
    ctx.fillText(`底 (${this.depthValue}m)`, 6, h * 0.85 + 14)
  }

  redraw() {
    this.ctx.clearRect(0, 0, this.cssWidth, this.cssHeight)
    this.drawBackground()
    this.strokes.forEach(s => this.drawStroke(s))
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

  bindEvents() {
    this.canvas.addEventListener("mousedown",  this.startDraw.bind(this))
    this.canvas.addEventListener("mousemove",  this.draw.bind(this))
    this.canvas.addEventListener("mouseup",    this.endDraw.bind(this))
    this.canvas.addEventListener("mouseleave", this.endDraw.bind(this))
    this.canvas.addEventListener("touchstart",  this.startDrawTouch.bind(this), { passive: false })
    this.canvas.addEventListener("touchmove",   this.drawTouch.bind(this),      { passive: false })
    this.canvas.addEventListener("touchend",    this.endDraw.bind(this))
  }

  getPos(event) {
    const rect = this.canvas.getBoundingClientRect()
    return { x: event.clientX - rect.left, y: event.clientY - rect.top }
  }

  startDraw(event) {
    this.isDrawing = true
    const pos = this.getPos(event)
    this.current = {
      type:   "path",
      color:  this.hasColorPickerTarget ? this.colorPickerTarget.value : "#0ea5e9",
      width:  this.hasLineWidthTarget   ? parseInt(this.lineWidthTarget.value) : 4,
      points: [pos]
    }
  }

  draw(event) {
    if (!this.isDrawing || !this.current) return
    const pos = this.getPos(event)
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

  endDraw() {
    if (!this.isDrawing || !this.current) return
    this.isDrawing = false
    if (this.current.points.length > 1) {
      this.strokes.push(this.current)
      this.saveToInput()
    }
    this.current = null
  }

  startDrawTouch(event) {
    event.preventDefault()
    const t = event.touches[0]
    this.startDraw({ clientX: t.clientX, clientY: t.clientY })
  }

  drawTouch(event) {
    event.preventDefault()
    const t = event.touches[0]
    this.draw({ clientX: t.clientX, clientY: t.clientY })
  }

  undo() {
    this.strokes.pop()
    this.redraw()
    this.saveToInput()
  }

  clear() {
    this.strokes = []
    this.redraw()
    this.saveToInput()
  }

  saveToInput() {
    if (!this.hasDataInputTarget) return
    this.dataInputTarget.value = JSON.stringify({
      version: 1, canvas_width: this.cssWidth, canvas_height: this.cssHeight,
      water_depth: this.depthValue, strokes: this.strokes
    })
  }
}
