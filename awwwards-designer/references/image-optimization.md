# Image Optimization — Deep Dive

Images are the largest contributor to page weight. Optimized images can cut LCP by seconds. This guide covers the full image pipeline from generation to delivery.

---

## Image Format Decision Tree

```
Is it a photograph or complex image?
  → AVIF (primary) → WebP (fallback) → JPEG (last resort)

Is it a graphic, logo, icon, or needs transparency?
  → SVG (vector, resolution-independent)

Is it a screenshot or needs pixel-perfect detail?
  → PNG (or AVIF if supported)

Is it animated?
  → AVIF animated OR WebM video loop (not GIF — GIF is obsolete for animation)
  → GIF: only for decorative loops where file size truly doesn't matter
```

### Format Comparison (typical 1200×800 photograph)

| Format | Quality 80 | Quality 90 | Notes |
|--------|-----------|-----------|-------|
| AVIF | ~40KB | ~80KB | Best compression, wide support (>93% global) |
| WebP | ~80KB | ~150KB | Good fallback, ~30% smaller than JPEG |
| JPEG | ~120KB | ~200KB | Universal support, worst compression |
| PNG | ~400KB+ | N/A | Never use for photographs |

**Browser support (2024):** AVIF: 93%+ global, WebP: 98%+, AVIF animations: ~88%. Use `<picture>` element for art direction and format fallbacks.

---

## Responsive Images

### srcset — Density Variants

```html
<img
  src="hero-800.avif"
  srcset="
    hero-400.avif 400w,
    hero-800.avif 800w,
    hero-1200.avif 1200w,
    hero-1600.avif 1600w
  "
  sizes="
    (max-width: 600px) 100vw,
    (max-width: 1200px) 80vw,
    1200px
  "
  alt="Hero image"
  width="1600"
  height="900"
  fetchpriority="high"
>
```

### sizes Attribute Guide

```html
<!-- Full width on mobile, 2/3 width on desktop -->
<img srcset="..." sizes="(max-width: 768px) 100vw, 66vw">

<!-- Fixed width on mobile, 600px on desktop -->
<img srcset="..." sizes="(max-width: 768px) 100vw, 600px">

<!-- 100vmin for square-ish crops -->
<img srcset="..." sizes="100vmin">
```

### The sizes Formula

`sizes` tells the browser how wide the image will render — it does NOT resize the image. The browser uses this + `srcset` to pick the smallest image that covers the slot:

```
Image candidate selected = max(available viewport width × device pixel ratio, natural width)
```

---

## The <picture> Element — Art Direction + Format Fallback

```html
<picture>
  <!-- AVIF with WebP and JPEG fallbacks -->
  <source
    type="image/avif"
    srcset="
      hero-400.avif 400w,
      hero-800.avif 800w,
      hero-1200.avif 1200w
    "
    sizes="100vw"
  >
  <source
    type="image/webp"
    srcset="
      hero-400.webp 400w,
      hero-800.webp 800w,
      hero-1200.webp 1200w
    "
    sizes="100vw"
  >
  <img
    src="hero-800.jpg"
    alt="Hero image"
    width="1600"
    height="900"
    fetchpriority="high"
  >
</picture>
```

### Art Direction Example

```html
<picture>
  <!-- Landscape for desktop -->
  <source
    media="(min-width: 768px)"
    srcset="hero-landscape.avif"
    type="image/avif"
  >
  <!-- Portrait crop for mobile -->
  <source
    media="(max-width: 767px)"
    srcset="hero-portrait.avif"
    type="image/avif"
  >
  <img src="hero-portrait.avif" alt="Hero" fetchpriority="high">
</picture>
```

---

## fetchpriority — The LCP Multiplier

The `fetchpriority` attribute (part of the Fetch Priority API) tells the browser how important a resource is relative to others.

```html
<!-- HIGH — LCP element, preload it -->
<img src="hero.avif" fetchpriority="high">

<!-- LOW — decorative, below fold -->
<img src="decoration.avif" fetchpriority="low">

<!-- AUTO — browser decides (default) -->
<img src="normal.avif" fetchpriority="auto">
```

**Preload + fetchpriority="high" on the LCP element is the single highest-ROI optimization in web performance.**

```html
<head>
  <link rel="preload" as="image" href="hero.avif" fetchpriority="high">
</head>
<body>
  <img src="hero.avif" fetchpriority="high" alt="Hero">
</body>
```

---

## Lazy Loading

### Native Lazy Loading

```html
<!-- Native lazy loading — browser handles it -->
<img src="below-fold.jpg" loading="lazy" alt="..." width="800" height="600">

<!-- Explicit eager (opt out of lazy) -->
<img src="above-fold.jpg" loading="eager" alt="...">
```

### When NOT to Lazy Load

- **LCP element** — Ever. Never. It destroys LCP.
- **First 2-3 images above the fold** — Load these eagerly
- **Critical UI elements** — Logos, navigation icons, hero images

### JavaScript Lazy Loading (Intersection Observer)

```js
const lazyImages = document.querySelectorAll('img[data-src]');

const imageObserver = new IntersectionObserver((entries, observer) => {
  entries.forEach(entry => {
    if (entry.isIntersecting) {
      const img = entry.target;
      img.src = img.dataset.src;
      img.removeAttribute('data-src');
      observer.unobserve(img);
    }
  });
}, {
  rootMargin: '200px', // Start loading 200px before entering viewport
  threshold: 0.01
});

lazyImages.forEach(img => imageObserver.observe(img));
```

### Native Lazy Loading + JS Fallback

```html
<img
  src="image.avif"
  loading="lazy"
  decoding="async"
  alt="..."
>
<!-- decoding="async" allows the browser to decode off the main thread -->
```

---

## Blur-Up Placeholders (LQIP)

Low Quality Image Placeholders show a tiny blurred version while the full image loads.

### CSS Blur-Up

```css
.blur-up {
  filter: blur(20px);
  transition: filter 0.4s ease-out;
}

.blur-up.loaded {
  filter: blur(0);
}
```

```html
<img
  class="blur-up"
  src="tiny-blur.avif"
  data-src="full-image.avif"
  alt="..."
>
```

```js
img.onload = () => img.classList.add('loaded');
```

### Solid Color Placeholder

```css
/* When you know the dominant color from build-time analysis */
.hero-image-placeholder {
  background-color: #2d2d2d;
}
```

### SVG Blur-Up (Tiny Base64)

```html
<img
  src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAxIDEiPjxyZWN0IGZpbGw9IiMzMzMiIHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiLz48L3N2Zz4="
  data-src="hero.avif"
  alt="..."
>
```

---

## Image CDNs

Image CDNs transform, optimize, and deliver images from edge locations. For Antigravity builds, use Cloudflare (free tier excellent), Cloudinary, imgix, or Sanity.

### Cloudflare Images

```html
<!-- Cloudflare Images delivery -->
<img src="https://your-domain.com/cdn-cgi/image/width=800,format=avif,quality=80/hero.jpg">

<!-- Variant delivery -->
<img src="https://your-domain.com/cdn-cgi/image/width=800,height=450,fit=cover,format=avif/hero.jpg">
```

### Cloudinary URL Transform

```html
<!-- Auto-format and quality -->
<img src="https://res.cloudinary.com/demo/image/fetch/w_800,q_auto,f_avif/https://source-image.jpg">

<!-- Crop to face -->
<img src="https://res.cloudinary.com/demo/image/fetch/w_800,h_800,c_fill,g_face,f_avif,q_auto/https://source-image.jpg">
```

### imgix

```html
<!-- Auto format + quality + responsive -->
<img src="https://example.imgix.net/hero.jpg?w=800&auto=format,compress&fit=crop">
```

### CDN Checklist

- [ ] Enable AVIF + WebP auto-negotiation
- [ ] Set `Cache-Control: public, max-age=31536000, immutable` for hashed assets
- [ ] Use consistent URLs (avoid `?v=timestamp` for immutable content)
- [ ] Configure responsive breakpoints that match your `srcset`
- [ ] Set image quality to 75-85 for most content (test visually)
- [ ] Strip EXIF metadata (it adds bytes without visual value)

---

## Aspect Ratio — The CLS Prevention Must

```css
/* Method 1: HTML attributes (preferred) */
<img src="hero.avif" width="1600" height="900" alt="...">

/* Method 2: CSS aspect-ratio (when HTML dimensions unknown at build) */
img {
  aspect-ratio: 16 / 9;
  width: 100%;
  height: auto; /* auto computed from aspect-ratio + width */
}

/* Method 3: padding-bottom hack (older browsers) */
.aspect-box {
  position: relative;
  width: 100%;
  padding-bottom: 56.25%; /* 9/16 = 0.5625 */
}
.aspect-box > img {
  position: absolute;
  top: 0; left: 0;
  width: 100%; height: 100%;
  object-fit: cover;
}

/* Responsive aspect ratios */
.ratio-4-3 { aspect-ratio: 4 / 3; }
.ratio-16-9 { aspect-ratio: 16 / 9; }
.ratio-1-1 { aspect-ratio: 1 / 1; }
.ratio-3-4 { aspect-ratio: 3 / 4; }
```

---

## Video Optimization

```html
<!-- Video poster — critical for LCP if video is LCP element -->
<video
  src="hero.mp4"
  poster="hero-poster.avif"
  preload="none"
  muted
  autoplay
  loop
  playsinline
  fetchpriority="high"
></video>

<!-- Lazy load video -->
<video
  src="hero.mp4"
  poster="hero-poster.avif"
  preload="none"
  loading="lazy"
  muted
  autoplay
  loop
  playsinline
></video>
```

### Video Best Practices

- Always set `poster` attribute — shows immediately while video loads
- Poster should be AVIF/WebP, generated from first frame
- Use `preload="none"` for below-fold videos
- Use `preload="metadata"` for near-fold videos
- `muted`, `autoplay`, `loop`, `playsinline` for background videos
- Consider `<source>` elements with format fallbacks
- For autoplay muted video that IS the LCP element: preload + fetchpriority="high"

---

## Build-Time Image Processing

Use sharp, imagemin, or your bundler's image plugin (Vite's `vite-plugin-imagemin`).

```js
// Example: sharp processing pipeline
import sharp from 'sharp';

const hero = sharp('source/hero.jpg');
const metadata = await hero.metadata();

// Generate AVIF + WebP + JPEG at multiple sizes
const widths = [400, 800, 1200, 1600];

for (const w of widths) {
  await hero
    .clone()
    .resize(w)
    .avif({ quality: 80 })
    .toFile(`dist/hero-${w}.avif`);

  await hero
    .clone()
    .resize(w)
    .webp({ quality: 80 })
    .toFile(`dist/hero-${w}.webp`);
}
```

---

## Image Optimization Checklist

```plaintext
□ AVIF primary format for all photographs
□ WebP fallback for all photographs
□ JPEG only as last resort fallback
□ SVG for all icons, logos, vectors
□ srcset with 3-4 density variants (400w, 800w, 1200w, 1600w)
□ sizes attribute on every responsive image
□ fetchpriority="high" on LCP element + preload link in <head>
□ loading="lazy" on all below-fold images
□ decoding="async" on all images
□ width + height attributes OR aspect-ratio CSS on every image
□ Image CDN for transformation and delivery
□ Cache-Control: immutable for versioned assets
□ Blur-up placeholder for hero images
□ poster attribute on every <video>
□ No GIF for animation (use WebM/AVIF video)
□ Build-time processing: sharp, imagemin, or vite-plugin-imagemin
```
