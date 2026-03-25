---
name: awwwards-performance-standards
description: >
  Performance standards for the awwwards-designer workflow. Contains Core Web Vitals
  targets (LCP, CLS, INP), tier-based JS bundle budgets, LCP/CLS/INP optimization
  techniques, animation performance rules, and Lighthouse targets. Applies across
  Phase 4 (Enhancement Layer) when making library and implementation choices, and
  Phase 5 (Quality Gate) when auditing performance. Performance targets are universal
  and do not defer to DESIGN.md.
---

# Awwwwards Performance Standards

Performance is not a feature — it IS the feature. Every Antigravity build ships to real users on real devices under real network conditions. These standards ensure every site earns its Awwwwards nomination.

---

## Table of Contents

1. [Core Web Vitals Targets](#1-core-web-vitals-targets)
2. [JS Bundle Budgets](#2-js-bundle-budgets)
3. [LCP Optimization](#3-lcp-optimization)
4. [CLS Prevention](#4-cls-prevention)
5. [INP Optimization](#5-inp-optimization)
6. [Animation Performance](#6-animation-performance)
7. [Quick Wins Checklist](#7-quick-wins-checklist)
8. [Lighthouse Targets](#8-lighthouse-targets)
9. [Reference Files](#9-reference-files)

---

## 1. Core Web Vitals Targets

Source: [web.dev Core Web Vitals](https://web.dev/vitals/) (Google, 2024)

### Thresholds

| Metric | Abbr | Good | Poor |
|--------|------|------|------|
| Largest Contentful Paint | LCP | < 2.5s | > 4.0s |
| Cumulative Layout Shift | CLS | < 0.1 | > 0.25 |
| Interaction to Next Paint | INP | < 200ms | > 500ms |
| First Contentful Paint | FCP | < 1.8s | > 3.0s |
| Time to First Byte | TTFB | < 800ms | > 1800ms |

### Awwwwards Targets

```
LCP  < 1.8s   CLS  < 0.05   INP  < 100ms   FCP  < 1.2s   TTFB < 400ms
```

### What Each Metric Measures

- **LCP** — Time to render largest visible element (hero `<img>`, poster, large heading, background div).
- **CLS** — Sum of unexpected layout shifts (impact × distance). Everything that moves after initial paint counts.
- **INP** — 98th percentile interaction latency. Replaced FID March 2024. Full input → visual response cycle.
- **FCP** — First DOM content paint (text, image, SVG, canvas).
- **TTFB** — Server/proxy/database responsiveness before the browser even starts.

### Measurement Tools

| Tool | Type | Best For |
|------|------|----------|
| PageSpeed Insights | Field + Lab | CrUX ground truth + lab |
| Lighthouse (DevTools) | Lab | Quick dev audits |
| WebPageTest | Lab | Waterfalls, filmstrip, real devices |
| web-vitals.js | Field (RUM) | Real-user monitoring |
| CrUX (BigQuery) | Field | Historical trends |

**Field vs Lab:** Field data = real users. Lab data = simulation. Always check PSI field data first.

---

## 2. JS Bundle Budgets

Tier-based budgets (gzip). HTTP Archive 2024 median: ~300KB gzip. Awwwwards-tier: stay small.

| Tier | Budget | Use Case |
|------|--------|---------|
| **1** | < 20KB | Critical path only. GSAP core, basic interactions. |
| **2** | < 120KB | Standard site. Full animation library, moderate interactivity. |
| **2.5** | < 150KB | Enhanced. GSAP + Lenis + minimal Three.js. |
| **3** | < 300KB | Complex. Full Three.js, WebGL, heavy interactivity. |

### Cutting JS: Priority Order

```
1. Remove it     — Does it need JS at all? CSS can do a lot.
2. Defer it      — Does it need to run before paint? If not → defer or module.
3. Lazy load it — Does it only run on interaction? Use dynamic import().
4. Split it     — Route-based code splitting (Vite/Rollup).
5. Replace it   — Heavy library → lighter alternative.
```

### Library Alternatives

| Heavy | Light | Savings |
|-------|-------|---------|
| jQuery | Vanilla JS | ~30KB |
| Moment.js | date-fns / native Intl | ~67KB |
| Lodash full | lodash-es | ~70KB |
| GSAP + plugins | GSAP core only | ~50KB |

---

## 3. LCP Optimization

LCP is the most impactful metric. Target: < 1.8s.

### The LCP Checklist

- [ ] **Preload the hero image** — `<link rel="preload" as="image" href="hero.avif" fetchpriority="high">`
- [ ] **Never lazy-load the LCP element** — `loading="lazy"` destroys LCP
- [ ] **Inline critical CSS** — No stylesheet blocking first paint
- [ ] **Serve from CDN** — Eliminates TTFB as bottleneck
- [ ] **Use AVIF/WebP** — Smaller files = faster decode
- [ ] **Preconnect to image origins**

### fetchpriority="high" — The Highest-ROI Fix

```html
<!-- WRONG — LCP suffers -->
<img src="hero.jpg" alt="Hero">

<!-- RIGHT — browser prioritizes this resource -->
<link rel="preload" as="image" href="hero.avif" fetchpriority="high">
<img src="hero.avif" fetchpriority="high" alt="Hero">
```

### Identifying Your LCP Element

```js
new PerformanceObserver((list) => {
  const entries = list.getEntries();
  const lastEntry = entries[entries.length - 1];
  console.log('LCP element:', lastEntry.element);
  console.log('LCP time:', lastEntry.startTime);
}).observe({ type: 'largest-contentful-paint', buffered: true });
```

---

## 4. CLS Prevention

Every unexpected layout shift is a UX failure. CLS accumulates across the entire page lifetime.

### The CLS Checklist

- [ ] **Reserve space for all images** — `width` + `height` attributes OR `aspect-ratio` CSS
- [ ] **Never insert content above existing content** — No banner injection, cookie notices
- [ ] **Use `font-display: swap`** — Prevents invisible text during font load
- [ ] **Use `size-adjust` descriptors** — Compensates for fallback font metric differences
- [ ] **Set `contain: layout` on dynamic containers**
- [ ] **No layout property animations** — `transform`/`opacity` only

### The Aspect-Ratio Method

```css
/* WRONG — causes CLS */
img { max-width: 100%; }

/* RIGHT — zero CLS */
img {
  width: 100%;
  aspect-ratio: 16 / 9;
  height: auto; /* auto-computed from aspect-ratio */
}
```

### Font Metric Stability (CLS from Font Swap)

```css
@font-face {
  font-family: 'MyFont-fallback';
  src: local('Arial');
  font-display: swap;
  size-adjust: 103%;
  ascent-override: 95%;
  descent-override: 25%;
}
```

Use [Fontaine](https://github.com/unjs/fontaine) or [next/font](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) for automatic fallback metric generation.

---

## 5. INP Optimization

INP (Interaction to Next Paint) replaced FID in March 2024. It measures the 98th percentile latency of ALL interactions — not just the first.

### The INP Checklist

- [ ] **Break up long tasks** — No task > 50ms on the main thread
- [ ] **Use `requestIdleCallback`** — Defer non-critical work to idle time
- [ ] **Debounce scroll/pointer handlers** — Never process every scroll event
- [ ] **Use `requestAnimationFrame`** — For all DOM reads/writes that need to sync with paint
- [ ] **Lazy load below-fold interactivity** — Only load JS when needed
- [ ] **Web Workers for heavy computation** — Offload parsing, formatting to worker threads
- [ ] **Avoid layout thrashing** — Batch DOM reads, then batch writes (read-write pattern)

### Breaking Long Tasks

```js
// WRONG — blocks main thread for 200ms
function processItems(items) {
  items.forEach(item => expensiveOperation(item));
}

// RIGHT — yields to browser between chunks
async function processItemsAsync(items) {
  const CHUNK = 50;
  for (let i = 0; i < items.length; i += CHUNK) {
    items.slice(i, i + CHUNK).forEach(expensiveOperation);
    await new Promise(r => setTimeout(r, 0)); // Yield
  }
}
```

### Debounce + RAF

```js
let ticking = false;
window.addEventListener('scroll', handler, { passive: true });

function handler() {
  if (!ticking) {
    requestAnimationFrame(() => {
      updateScrollState(); // DOM read/write
      ticking = false;
    });
    ticking = true;
  }
}
```

---

## 6. Animation Performance

Every animation that causes layout or paint steals frames. GPU-accelerate or don't animate.

### GPU-Accelerated Properties (Safe)

| Property | Notes |
|----------|-------|
| `transform` | Best. `translate3d`, `scale`, `rotate` |
| `opacity` | Very cheap. Great for fades. |
| `filter` | blur, brightness, contrast — GPU filters |
| `clip-path` | Shape reveals |
| `backdrop-filter` | Frosted glass |

### NEVER Animate These

```
width, height, margin, padding, border
top, left, right, bottom, inset
font-size, font-weight, line-height, letter-spacing
display, visibility, overflow
background-color, box-shadow, border-radius
color, border-color, text-shadow
```

### will-change: The Right Way

```css
/* Apply just before animation */
.animated-element {
  will-change: transform, opacity;
}

/* Remove after animation completes */
.animated-element.done {
  will-change: auto;
}
```

**Never apply `will-change` preemptively.** It reserves GPU memory. Only apply when animation is imminent.

---

## 7. Quick Wins Checklist

Do these on EVERY build. Every single one.

```
□ 1. Preload LCP image: <link rel="preload" as="image" href="hero.avif" fetchpriority="high">
□ 2. AVIF primary, WebP fallback, JPEG last resort — never serve PNG for photos
□ 3. font-display: swap on every @font-face rule
□ 4. aspect-ratio on every <img> — zero excuses for missing dimensions
□ 5. Defer all non-critical JS (all JS is non-critical except what's needed for LCP)
□ 6. Inline critical CSS for above-fold content
□ 7. Preconnect to all external origins (fonts, images, CDNs)
□ 8. loading="lazy" on all below-fold images
□ 9. No layout property animations (transform + opacity only)
□ 10. Lighthouse Performance 90+ before ship
```

---

## 8. Lighthouse Targets

| Category | Target | Minimum |
|----------|--------|---------|
| Performance | 90+ | 85 |
| Accessibility | 90+ | 85 |
| Best Practices | 90+ | 85 |
| SEO | 90+ | 85 |

### Lighthouse Scoring Weights (v10+)

| Metric | Weight | P75 Target |
|--------|--------|-----------|
| Largest Contentful Paint | 25% | < 2.5s |
| Total Blocking Time | 30% | < 200ms |
| Cumulative Layout Shift | 25% | < 0.1 |
| First Contentful Paint | 10% | < 1.8s |
| Speed Index | 10% | < 3.4s |

**TBT (Total Blocking Time)** — Sum of long tasks (>50ms) between FCP and TTI. Main thread work blocking interaction.

---

## 9. Reference Files

Load deep dives as needed:

| Reference | When to Load |
|-----------|-------------|
| `references/image-optimization.md` | Images, CDNs, lazy loading, blur-up, video |
| `references/font-loading.md` | Preloading, font-display, subsets, self-host, size-adjust |
| `references/css-performance.md` | Critical CSS, containment, will-change, animation props |
| `references/testing.md` | Lighthouse, WebPageTest, CI budgets, RUM, regression |

---

## TL;DR Decision Tree

```
Is it a layout-affecting property (width, height, top, left, margin)?
  → No? Animate it. (transform, opacity, filter are fine)
  → Yes? STOP. Find a transform-based alternative.

Is it above the fold / LCP element?
  → YES: preload, inline CSS, no defer, fetchpriority="high"
  → NO: lazy load, defer, loading="lazy"

Does it need JS to run before paint?
  → YES: Is it needed for LCP? If no → defer or module
  → Can it be dynamic import()? If yes → do that

Is it a font?
  → Preload WOFF2, font-display: swap, subset, size-adjust, self-host

Is the bundle over budget?
  → Cut: remove > defer > lazy load > split > replace
```
