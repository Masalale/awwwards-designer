# Performance Standards

> Performance targets are universal — they do not defer to DESIGN.md. These apply to every build regardless of tier.

---

## Core Web Vitals — Awwwards Targets

| Metric | Target |
|--------|--------|
| LCP | < 1.8s |
| CLS | < 0.05 |
| INP | < 100ms |
| FCP | < 1.2s |
| TTFB | < 400ms |
| Lighthouse Performance | ≥ 90 |

---

## JS Bundle Budgets (gzip)

| Tier | Budget |
|------|--------|
| 1 (CSS-only) | < 20 KB |
| 2 (JS-enhanced) | < 120 KB |
| 2.5 (light 3D) | < 150 KB |
| 3 (WebGL) | < 300 KB |

---

## LCP Checklist

- [ ] Preload hero image: `<link rel="preload" as="image" href="hero.avif" fetchpriority="high">`
- [ ] Never lazy-load the LCP element — no `loading="lazy"` on hero
- [ ] Inline critical CSS — no stylesheet blocking first paint
- [ ] Serve from CDN
- [ ] AVIF primary, WebP fallback — never PNG for photos

## CLS Checklist

- [ ] Reserve space for all images — `width` + `height` OR `aspect-ratio`
- [ ] Never insert content above existing content
- [ ] `font-display: swap` on every `@font-face`
- [ ] Use `size-adjust` for fallback font metric compensation
- [ ] No layout property animations — `transform`/`opacity` only

## INP Checklist

- [ ] Break up long tasks — no task > 50ms on main thread
- [ ] Use `requestAnimationFrame` for DOM reads/writes
- [ ] Lazy load below-fold interactivity
- [ ] Debounce scroll/pointer handlers
- [ ] Avoid layout thrashing — batch DOM reads, then writes

---

## Quick Wins (Every Build)

```
□ 1. Preload LCP image: fetchpriority="high"
□ 2. AVIF primary, WebP fallback, JPEG last resort
□ 3. font-display: swap on every @font-face
□ 4. aspect-ratio on every <img>
□ 5. Defer all non-critical JS
□ 6. Inline critical CSS for above-fold content
□ 7. Preconnect to external origins
□ 8. loading="lazy" on below-fold images
□ 9. No layout property animations
□ 10. Lighthouse Performance ≥ 90 before ship
```

---

## See Also

- `references/image-optimization.md` — Image formats, CDNs, lazy loading
- `references/font-loading.md` — Preloading, font-display, subsets, size-adjust
- `references/css-performance.md` — Critical CSS, containment, will-change
- `references/testing.md` — Lighthouse, WebPageTest, CI budgets
