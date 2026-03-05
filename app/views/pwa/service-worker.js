const CACHE_NAME = "area-go-v1"
const STATIC_ASSETS = [
  "/",
  "/dashboard",
  "/lures",
  "/catch_records",
  "/offline"
]

// インストール: 静的アセットをキャッシュ
self.addEventListener("install", (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS)).catch(() => {})
  )
  self.skipWaiting()
})

// アクティベート: 古いキャッシュを削除
self.addEventListener("activate", (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    )
  )
  self.clients.claim()
})

// フェッチ戦略
self.addEventListener("fetch", (event) => {
  const url = new URL(event.request.url)

  // 外部ドメイン（Google Maps等）はネットワーク直接
  if (url.hostname !== location.hostname) return

  // POSTリクエストはキャッシュしない
  if (event.request.method !== "GET") return

  // 画像: Cache First
  if (event.request.destination === "image") {
    event.respondWith(
      caches.match(event.request).then((cached) => {
        return cached || fetch(event.request).then((response) => {
          const clone = response.clone()
          caches.open(CACHE_NAME).then((cache) => cache.put(event.request, clone))
          return response
        })
      })
    )
    return
  }

  // HTML/API: Network First、オフライン時はキャッシュにフォールバック
  event.respondWith(
    fetch(event.request)
      .then((response) => {
        const clone = response.clone()
        caches.open(CACHE_NAME).then((cache) => cache.put(event.request, clone))
        return response
      })
      .catch(() =>
        caches.match(event.request).then((cached) => cached || caches.match("/offline"))
      )
  )
})
