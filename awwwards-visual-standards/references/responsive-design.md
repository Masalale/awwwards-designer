# Responsive Design Deep Dive

> "Start with mobile first. The desktop is just a larger canvas, not a different canvas." — Luke Wroblewski

This reference covers mobile-first breakpoints, fluid typography, 100dvh usage,
responsive images, container queries, touch targets, and the mobile address bar problem.

---

## Mobile-First Breakpoints

### The Mobile-First Principle

Mobile-first means writing CSS for the smallest viewport first, then adding enhancements
for larger screens. This is the opposite of desktop-first, which is the wrong approach.

```css
/* ❌ WRONG: Desktop-first — base styles assume large screen */
body {
  font-size: 18px;      /* Too large for mobile */
  max-width: 1440px;     /* Centers content, looks wrong on mobile */
  padding: 48px 80px;   /* Huge padding on mobile */
}

/* ✅ CORRECT: Mobile-first — base styles are the mobile experience */
body {
  font-size: 16px;
  padding: 16px 20px;
}

@media (min-width: 768px) {
  body {
    font-size: 18px;
    padding: 24px 40px;
  }
}

@media (min-width: 1024px) {
  body {
    max-width: 1280px;
    padding: 32px 80px;
  }
}
```

### Breakpoint Scale

| Name    | Min-Width | Target Viewport     | Primary Use                    |
|---------|-----------|---------------------|--------------------------------|
| xs      | 375px     | Small phones        | Compact mobile layouts         |
| sm      | 640px     | Large phones/small  | Enhanced mobile                |
| md      | 768px     | Tablets (portrait)  | Tablet-scale layouts           |
| lg      | 1024px    | Tablets (landscape) | Small laptops, tablet desktop  |
| xl      | 1280px    | Laptops             | Standard desktop               |
| 2xl     | 1440px    | Desktops            | Large desktop                  |
| 3xl     | 1536px    | Wide monitors       | Extra-large displays           |

### CSS Implementation

```css
:root {
  /* Breakpoints as custom properties */
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
  --breakpoint-2xl: 1440px;
}

/* === Mobile-first media queries === */

/* Small devices (large phones) */
@media (min-width: 640px) {
  .container { max-width: 640px; }
}

/* Medium devices (tablets) */
@media (min-width: 768px) {
  .container { max-width: 768px; }
  .hero-layout { grid-template-columns: 1fr 1fr; }
}

/* Large devices (small desktop) */
@media (min-width: 1024px) {
  .container { max-width: 1024px; }
  .hero-layout { gap: 4rem; }
}

/* Extra-large (full desktop) */
@media (min-width: 1280px) {
  .container { max-width: 1280px; }
}

/* Maximum constraint for very wide screens */
@media (min-width: 1536px) {
  .container { max-width: 1280px; } /* Don't expand past this */
}
```

### Max-Width vs Min-Width

| Approach    | Best For                          | Caveat                          |
|-------------|-----------------------------------|---------------------------------|
| `min-width` | Mobile-first progressive enhanc.  | Write styles for mobile, add up |
| `max-width` | Targeting specific screen sizes   | Can get messy, often redundant |
| Combination | Precise control over ranges       | `min-width: 768px) and (max-width: 1023px)` |

```css
/* Range query — only targets tablets in landscape */
@media (min-width: 768px) and (max-width: 1023px) {
  .tablet-only { display: block; }
}
```

---

## Container Queries

### Why Container Queries Matter

Media queries respond to the **viewport width**. Container queries respond to the
**parent container width**. This is game-changing for reusable components.

**Problem with media queries:** A card component can't know its own width using media queries.
It only knows the viewport width.

**Solution with container queries:** A card can adapt to whether it's in a narrow sidebar
or a wide main content area — without knowing anything about the viewport.

### Browser Support

Container queries are supported in all modern browsers (Chrome 105+, Safari 16+, Firefox 110+).
For older browsers, use `@supports`:

```css
/* Feature detection */
@supports (container-type: inline-size) {
  /* Container query styles here */
}
```

### Container Query Syntax

```css
/* 1. Define a containment context on the parent */
.card-grid {
  container-type: inline-size;
  container-name: card-grid;
}

/* 2. Use container() to query the parent */
.card {
  display: grid;
  grid-template-columns: 1fr;
  gap: 1rem;
}

@container card-grid (min-width: 400px) {
  .card {
    grid-template-columns: 1fr 1fr;
  }
}

@container card-grid (min-width: 700px) {
  .card {
    grid-template-columns: 1fr 1fr 1fr;
  }
}
```

### Container Query vs Media Query Decision

| Scenario                                   | Use                        |
|-------------------------------------------|----------------------------|
| Reusable component adapts to layout slot   | Container Query            |
| Page-level layout changes                  | Media Query                |
| Navigation behavior based on viewport     | Media Query                |
| Card grid with dynamic parent width       | Container Query            |
| Full-screen hero text size                 | Fluid Typography (no query)|
| Sidebar visibility                         | Container Query            |

---

## 100dvh vs 100vh: The Critical Difference

### The Mobile Browser Address Bar Problem

Mobile browsers have a dynamic address bar that expands and collapses as the user scrolls.
This affects the viewport height in real-time.

- **`100vh`**: Fixed at the full screen height, ignoring the address bar.
  When the address bar is visible, the bottom of the `100vh` element is cut off.
  This causes **layout overflow** and scroll bars.

- **`100dvh`**: Dynamic viewport height. Adjusts in real-time as the address bar shows/hides.
  The element always fits exactly in the visible area.

### Visual Comparison

```
┌─────────────────────────────┐
│        Address Bar           │  ← Address bar VISIBLE
│                             │
│                             │
│    100dvh = FITS HERE ✓     │  ← dvh shrinks with bar
│                             │
│    100vh = OVERFLOWS ✗      │  ← vh ignores bar, scrolls
└─────────────────────────────┘
```

### Correct Implementation

```css
/* ✅ CORRECT — Works on all mobile browsers */
.fullscreen-section {
  height: 100dvh;
  min-height: 100dvh;
  /* For sticky footer-like behavior */
  height: 100dvh;
  height: 100vh; /* Fallback — second declaration wins in supporting browsers */
}

/* ✅ CORRECT — Using min-height is more robust */
.fullscreen-section {
  min-height: 100dvh;
}

/* ✅ CORRECT — For flexbox/grid full-screen layouts */
.app-layout {
  display: flex;
  flex-direction: column;
  min-height: 100dvh;
}
.main-content {
  flex: 1;
}

/* ❌ WRONG — Causes scroll overflow on mobile */
.hero-section {
  height: 100vh;
  overflow: hidden;
}

/* ❌ WRONG — Still clips at bottom */
.hero-section {
  min-height: 100vh;
}
```

### dvh Fallback for Older Browsers

```css
/* Progressive enhancement: dvh wins, vh is fallback */
.fullscreen {
  height: 100vh;   /* Safari < 15.4, older Chrome */
  height: 100dvh;  /* Modern browsers — overrides above */
  min-height: 100vh;
  min-height: 100dvh;
}

/* Or use @supports for cleaner separation */
@supports (height: 100dvh) {
  .fullscreen {
    height: 100dvh;
    min-height: 100dvh;
  }
}
```

### JavaScript for Viewport Height (if needed)

For critical full-screen layouts that must work perfectly everywhere:

```javascript
function setFullHeight() {
  const vh = window.innerHeight * 0.01;
  document.documentElement.style.setProperty('--vh', `${vh}px`);
}

// Use --vh in CSS: height: calc(var(--vh, 1vh) * 100);
window.addEventListener('resize', setFullHeight);
setFullHeight();
```

---

## Fluid Typography with clamp()

### Why Fluid Typography?

Fluid typography scales smoothly between minimum and maximum sizes based on the viewport.
This eliminates the jarring "jump" between breakpoints.

**Fixed steps (bad):**
```
320px → 16px
768px → 18px
1024px → 24px
1440px → 32px
```
Text jumps between sizes, creating visual discontinuity.

**Fluid (good):**
```
clamp(16px, 2vw + 12px, 32px)
```
Text smoothly scales from 16px to 32px across all viewport widths.

### clamp() Implementation

```css
:root {
  /* Fluid scale using clamp() */
  --font-size-display: clamp(2.5rem, 7vw + 0.5rem, 7rem);
  --font-size-h1:       clamp(2rem, 3vw + 1rem, 4rem);
  --font-size-h2:       clamp(1.5rem, 2vw + 0.75rem, 3rem);
  --font-size-h3:       clamp(1.25rem, 1vw + 0.75rem, 2rem);
  --font-size-body-lg:  clamp(1.125rem, 0.5vw + 0.875rem, 1.25rem);
  --font-size-body:     clamp(1rem, 0.25vw + 0.875rem, 1.125rem);
  --font-size-small:    clamp(0.875rem, 0.25vw + 0.75rem, 1rem);
  --font-size-caption:  clamp(0.75rem, 0.15vw + 0.625rem, 0.875rem);
}

/* Apply fluid sizes */
h1 { font-size: var(--font-size-h1); }
h2 { font-size: var(--font-size-h2); }
p  { font-size: var(--font-size-body); }
```

### Using a Fluid Type Scale Generator

The most reliable approach is using a generator that calculates exact clamp values:

**Utopia.fyi Fluid Type Scale:**
```
https://utopia.fyi/type/calculator

Settings:
- Base size: 16px
- Scale ratio: 1.25 (Major Third)
- Min viewport: 320px
- Max viewport: 1440px

Output:
--step-0: clamp(1rem, 0.875rem + 0.625vw, 1.125rem)
--step-1: clamp(1.25rem, 1.125rem + 0.625vw, 1.40625rem)
--step-2: clamp(1.5625rem, 1.375rem + 0.938vw, 1.7578125rem)
--step-3: clamp(1.953125rem, 1.75rem + 1.016vw, 2.1972656rem)
--step-4: clamp(2.4414063rem, 2.1875rem + 1.27vw, 2.746582rem)
--step-5: clamp(3.0517578rem, 2.75rem + 1.508vw, 3.4332275rem)
--step-6: clamp(3.8146973rem, 3.4375rem + 1.886vw, 4.291534rem)
```

---

## Image Responsiveness

### The `<picture>` Element

Always use `<picture>` with multiple sources for modern image formats and responsive sizing.

```html
<picture>
  <!-- AVIF: Best compression, newest format -->
  <source
    srcset="
      image-400.avif   400w,
      image-800.avif   800w,
      image-1200.avif 1200w,
      image-1600.avif 1600w
    "
    sizes="(max-width: 640px) 100vw, (max-width: 1024px) 80vw, 1200px"
    type="image/avif"
  >

  <!-- WebP: Good compression, broad support -->
  <source
    srcset="
      image-400.webp   400w,
      image-800.webp   800w,
      image-1200.webp 1200w,
      image-1600.webp 1600w
    "
    sizes="(max-width: 640px) 100vw, (max-width: 1024px) 80vw, 1200px"
    type="image/webp"
  >

  <!-- Fallback: JPEG or PNG -->
  <img
    src="image-800.jpg"
    alt="Descriptive alt text"
    width="800"
    height="600"
    loading="lazy"
    decoding="async"
  >
</picture>
```

### srcset and sizes Explained

**srcset:** List of image URLs with their intrinsic widths.
```
image-400.jpg 400w  → "This image is 400px wide"
image-800.jpg 800w  → "This image is 800px wide"
```

**sizes:** How much of the viewport the image occupies at different breakpoints.
```
sizes="
  (max-width: 640px)  100vw,   /* Full width on mobile */
  (max-width: 1024px) 80vw,   /* 80% width on tablet */
  1200px                        /* 1200px on desktop */
"
```

### Image Widths to Generate

| Viewport Range | Generate Widths |
|---------------|----------------|
| 375px mobile  | 400w, 800w     |
| 768px tablet  | 800w, 1200w    |
| 1024px+ desktop | 1200w, 1600w, 2400w |

### AVIF/WebP Generation with Sharp

```javascript
import sharp from 'sharp';

const sizes = [400, 800, 1200, 1600];

for (const width of sizes) {
  // AVIF
  await sharp('source.jpg')
    .resize(width)
    .avif({ quality: 80 })
    .toFile(`image-${width}.avif`);

  // WebP
  await sharp('source.jpg')
    .resize(width)
    .webp({ quality: 85 })
    .toFile(`image-${width}.webp`);

  // JPEG fallback
  await sharp('source.jpg')
    .resize(width)
    .jpeg({ quality: 85, progressive: true })
    .toFile(`image-${width}.jpg`);
}
```

### LCP Image Optimization

The above-the-fold hero image needs special treatment:

```html
<!-- Hero image: eager loading, no lazy -->
<img
  src="hero-1200.avif"
  alt="Hero description"
  width="1200"
  height="600"
  loading="eager"
  decoding="sync"
  fetchpriority="high"
>
```

```css
/* Prevent layout shift (CLS) with aspect-ratio */
.hero-image-wrapper {
  aspect-ratio: 16 / 9;
  width: 100%;
  overflow: hidden;
}
.hero-image-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}
```

---

## Touch Targets

### WCAG Requirement: 44x44px Minimum

Every interactive element must be at least 44x44 pixels for touch accessibility.
This accounts for finger size (typically 8–10mm / 44–48px diameter).

### Implementation

```css
/* Base: minimum 44px touch target */
.touch-target {
  min-width: 44px;
  min-height: 44px;
}

/* Link targets */
a {
  display: inline-flex;
  align-items: center;
  min-height: 44px;
  padding: 0.5rem 1rem;
}

/* Button targets */
button {
  min-width: 44px;
  min-height: 44px;
  padding: 0.75rem 1.5rem;
}

/* Icon-only buttons */
.icon-button {
  width: 44px;
  height: 44px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
}

/* Form inputs */
input, select, textarea {
  min-height: 44px;
  padding: 0.5rem 0.75rem;
}
```

### Touch Target Spacing

Targets should have at least 24px of space between them to prevent accidental taps:

```css
.button-group {
  display: flex;
  gap: 0.75rem; /* 12px minimum, 24px recommended */
  flex-wrap: wrap;
}

/* For tight layouts, use invisible padding */
.tight-nav-link {
  position: relative;
  padding: 1rem; /* Visible padding */
  padding: calc(1rem + 6px); /* Touch area extends 6px in each direction */
}
```

### CSS Only Solution (if you can't add markup)

```css
/* Expand the tap area without expanding the visual element */
.expand-touch-target {
  position: relative;
}

.expand-touch-target::before {
  content: '';
  position: absolute;
  inset: -8px; /* Extends touch area by 8px in all directions */
  /* Note: Does not affect layout, only pointer events */
}
```

---

## Responsive Layout Patterns

### Grid Layouts

```css
/* Auto-fit grid that adapts to container width */
.auto-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
}

/* With container queries for true component reusability */
@supports (container-type: inline-size) {
  .card-wrapper {
    container-type: inline-size;
    container-name: card;
  }

  .card {
    display: grid;
    grid-template-columns: 1fr;
  }

  @container card (min-width: 400px) {
    .card {
      grid-template-columns: auto 1fr;
    }
  }
}
```

### Flexbox Patterns

```css
/* Stack on mobile, row on desktop */
.stack-on-mobile {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

@media (min-width: 768px) {
  .stack-on-mobile {
    flex-direction: row;
    align-items: center;
  }
}

/* Auto-wrap with gap */
.button-row {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  justify-content: flex-start;
}

/* Center everything, left-align on larger screens */
.text-center-mobile {
  text-align: center;
}

@media (min-width: 768px) {
  .text-center-mobile {
    text-align: left;
  }
}
```

### Asymmetric Responsive Layouts

```css
/* Asymmetric hero: stacked mobile, side-by-side desktop */
.hero {
  display: grid;
  grid-template-columns: 1fr;
  gap: var(--space-8);
  align-items: center;
}

@media (min-width: 768px) {
  .hero {
    grid-template-columns: 1fr 1.2fr;
    gap: var(--space-16);
  }
}

/* Asymmetric content: indented on desktop */
.content-section {
  max-width: 65ch;
  margin-inline: auto;
  padding-inline: var(--space-6);
}

@media (min-width: 1024px) {
  .content-section {
    margin-inline: 0;
    padding-left: clamp(3rem, 10vw, 12rem); /* Asymmetric indent */
  }
}
```

---

## Never Design Desktop-Only

### The Mobile-First Reality Check

- **67%+ of web traffic** comes from mobile devices (statista.com)
- **Google's index** is mobile-first
- **Awwwwards judges** use their phones

Designing desktop-first and squeezing in mobile support produces broken mobile experiences.
Design mobile-first and expanding to desktop produces robust experiences on all devices.

### Anti-Patterns That Signal Desktop-Only Thinking

| Anti-Pattern                      | Why It's Wrong                        |
|-----------------------------------|---------------------------------------|
| `max-width: 1440px` with no mobile | Centers content, ignores mobile       |
| Horizontal scroll for navigation  | Catastrophic on mobile                |
| Fixed pixel widths everywhere     | Breaks on every viewport size         |
| Hover-only interactions            | Touch devices can't hover             |
| Small touch targets                | Below 44px, fails accessibility      |
| Decorative images no alt text     | Screen reader inaccessible           |
| Video autoplay without controls   | Annoying on mobile data              |
| Fixed sidebar navigation           | Hidden on mobile without hamburger   |

### Responsive Navigation Patterns

```css
/* Mobile: hamburger menu */
.nav {
  position: fixed;
  inset: 0;
  background: var(--color-bg);
  transform: translateX(-100%);
  transition: transform 0.3s ease;
  z-index: 100;
}

.nav.is-open {
  transform: translateX(0);
}

/* Desktop: horizontal nav */
@media (min-width: 1024px) {
  .nav {
    position: static;
    transform: none;
    background: transparent;
    display: flex;
    flex-direction: row;
  }
}
```

---

## Testing Responsive Design

### Browser DevTools

1. **Chrome DevTools Device Toolbar:** Toggle device emulation
2. **Firefox Responsive Design Mode:** More realistic mobile emulation
3. **Edge DevTools:** Windows-specific testing

### Real Device Testing Priority

| Priority | Device                        | Why                             |
|----------|-------------------------------|---------------------------------|
| 1        | iPhone Safari (latest)        | Largest Awwwwards audience      |
| 2        | Android Chrome                | Largest global market share      |
| 3        | iPad Safari                   | Tablet users                    |
| 4        | Chrome desktop               | Developer/testing baseline      |

### Viewport Width Testing Checklist

| Width  | Device Simulated         | Check                                    |
|--------|-------------------------|------------------------------------------|
| 320px  | Small iPhone SE         | Smallest common viewport                 |
| 375px  | iPhone 12/13/14         | Modern iPhone baseline                   |
| 390px  | iPhone 12 Pro Max       | Larger iPhone                             |
| 428px  | iPhone 14 Pro Max      | Widest iPhone                             |
| 768px  | iPad Mini/portrait      | Tablet breakpoint                        |
| 1024px | iPad landscape          | Tablet desktop                            |
| 1280px | Small laptop            | Most common laptop viewport              |
| 1440px | Desktop                | Standard desktop                          |
| 1920px | Wide monitor           | Edge case — text shouldn't get too wide  |

### CLS (Cumulative Layout Shift) Testing

```javascript
// Measure CLS with PerformanceObserver
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (!entry.hadRecentInput) {
      console.log('CLS:', entry.value);
    }
  }
});

observer.observe({ type: 'layout-shift', buffered: true });
```

**CLS Targets:**
- Good: < 0.1
- Needs improvement: 0.1 – 0.25
- Poor: > 0.25
