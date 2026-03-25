# CSS Performance — Deep Dive

CSS is render-blocking by default. The browser can't paint until it downloads and parses the CSSOM. Smart CSS delivery eliminates this bottleneck and keeps the main thread free for JavaScript.

---

## Critical CSS

Critical CSS is the minimum set of styles needed to render above-the-fold content. Inline it. Everything else gets deferred.

### Extracting Critical CSS

```bash
# Using penthouse
bunx penthouse --url https://yoursite.com --css styles.css --output critical.css

# Using critical (Node)
const critical = require('critical');
critical.generate({
  inline: true,
  base: 'dist/',
  src: 'index.html',
  target: 'index-critical.html',
  width: 1300,
  height: 900
});
```

### Manual Critical CSS Extraction

```html
<head>
  <!-- Inline critical CSS — renders immediately, no network request -->
  <style>
    /* Only what's needed for above-the-fold */
    body { margin: 0; font-family: system-ui, sans-serif; }
    .hero { min-height: 100vh; display: flex; align-items: center; }
    .hero h1 { font-size: clamp(2rem, 5vw, 4rem); font-weight: 700; }
    /* Nav, above-fold images, initial layout */
  </style>

  <!-- Non-critical CSS — loaded after page renders -->
  <link
    rel="preload"
    href="styles.css"
    as="style"
    onload="this.onload=null;this.rel='stylesheet'"
  >
  <!-- Fallback for no-JS environments -->
  <noscript><link rel="stylesheet" href="styles.css"></noscript>
</head>
```

### Critical CSS Patterns

```css
/* Hero section — MUST be critical */
.hero {
  display: grid;
  place-items: center;
  min-height: 100vh;
  background: #0a0a0a;
  color: #fff;
}

.hero h1 {
  font-size: clamp(2.5rem, 8vw, 6rem);
  font-weight: 800;
  line-height: 1.1;
  letter-spacing: -0.02em;
}

/* Hide below-fold elements in critical CSS to prevent FOUC */
[data-critical="hidden"] { visibility: hidden; }
[data-critical="hidden"].loaded { visibility: visible; }
```

---

## Defer Non-Critical CSS

### The media="print" Trick

```html
<!-- Step 1: Load as print stylesheet (non-blocking) -->
<link
  rel="stylesheet"
  href="styles.css"
  media="print"
  onload="this.media='all'"
>

<!-- Step 2: Fallback for no-JS -->
<noscript>
  <link rel="stylesheet" href="styles.css">
</noscript>
```

### The preload Trick (Better)

```html
<!-- Step 1: Preload but don't apply -->
<link
  rel="preload"
  href="styles.css"
  as="style"
  onload="this.rel='stylesheet'"
>

<!-- Step 2: Fallback -->
<noscript>
  <link rel="stylesheet" href="styles.css">
</noscript>
```

### Modern Bundler Approach (Vite)

```js
// vite.config.js
import { defineConfig } from 'vite';
import vitePlugin from 'vite-plugin-css-injected-by-js';

export default defineConfig({
  plugins: [
    // Injects CSS as JS strings — eliminates render-blocking link tags
    cssInjectedByJs()
  ]
});
```

---

## Avoiding @import

`@import` in CSS is render-blocking and causes a cascade:

```css
/* BAD — creates serial loading chain */
@import url('fonts.css');
@import url('animations.css');
@import url('theme.css');
```

```
Browser: Parse base.css → Fetch fonts.css → Parse fonts.css →
         Fetch animations.css → Parse animations.css → Render
```

```css
/* GOOD — separate link tags, parallel downloads */
```

If you must use `@import`, put it inside a `<link rel="stylesheet">` — not at the top of a CSS file. The top-of-file `@import` is the worst pattern.

---

## CSS Containment

CSS containment isolates layout, style, and paint calculations to specific DOM subtrees. Prevents a change in one area from triggering recalculations everywhere.

### contain: layout

```css
/* Isolate this component's layout from the rest of the page */
.card {
  contain: layout;
}
```

**Use on:** Cards, list items, widget containers, anything that frequently updates or renders dynamically.

### contain: paint

```css
/* Prevent this element from being painted outside its bounds */
.modal-backdrop {
  contain: paint;
}

/* Paint containment creates a stacking context */
.overlay {
  contain: strict; /* layout + paint + style + size */
}
```

### Containment Values

| Value | What It Contains |
|-------|-----------------|
| `layout` | Layout isolation (defensive) |
| `paint` | Paint containment (no overflow) |
| `style` | Counter/list-style containment |
| `size` | Size containment (child can't affect parent) |
| `strict` | All of the above |
| `content` | Everything except size |

### Containment + Dynamic Content

```css
/* Container with fixed height for dynamic content */
.list-container {
  contain: layout style;
  content-visibility: auto; /* Skip rendering off-screen */
  contain-intrinsic-size: 0 400px; /* Estimated height for scrollbar */
}
```

---

## content-visibility

The `content-visibility` property lets the browser skip rendering work for off-screen content entirely.

```css
/* Auto — browser skips rendering when off-screen */
.section-below-fold {
  content-visibility: auto;
  contain-intrinsic-size: 0 600px; /* Estimated height */
}

/* Visible — normal rendering (default) */
.above-fold {
  content-visibility: visible;
}

/* Hidden — element skipped entirely (like display:none) */
.debug-panel {
  content-visibility: hidden;
}
```

**Impact:** Can reduce rendering time by 50%+ on long pages. Use `contain-intrinsic-size` to prevent scrollbar jumping (CLS).

---

## will-change — The Right Way

`will-change` tells the browser to promote an element to its own compositor layer. Used correctly, it enables GPU acceleration. Used incorrectly, it wastes GPU memory and hurts performance.

### Correct Usage

```css
/* Apply JUST before animation starts */
.animated-element {
  will-change: transform, opacity;
}

/* Remove AFTER animation completes */
.animated-element.done {
  will-change: auto;
}
```

### GSAP Integration

```js
// GSAP can manage will-change automatically
gsap.to(element, {
  x: 100,
  opacity: 0,
  willChange: 'transform, opacity', // GSAP handles it
  onComplete: () => {
    gsap.set(element, { clearProps: 'will-change' });
  }
});
```

### Incorrect Usage (Don't Do This)

```css
/* WRONG — Preemptively applying will-change everywhere */
* { will-change: transform; } /* Catastrophic — allocates GPU memory for everything */

/* WRONG — Using will-change without animation */
.will-animate-someday {
  will-change: transform; /* Too early */
}

/* WRONG — will-change on too many properties */
.bad {
  will-change: top, left, width, height, transform; /* Pick ONE */
}
```

### When will-change IS Appropriate

| Scenario | Correct `will-change` |
|----------|----------------------|
| Element about to animate with `transform` | `transform` |
| Element about to fade in/out | `opacity` |
| Scroll-linked animations | `transform` |
| Hover effects that use transform | `transform` |
| Page transition containers | `transform, opacity` |

---

## GPU-Accelerated Properties

### The Safe List (Compositor-Only)

These properties run on the compositor thread — they never touch the main thread:

| Property | Use Case |
|----------|----------|
| `transform` | translate, scale, rotate, skew, matrix |
| `opacity` | Fade in/out, transitions |
| `filter` | blur, brightness, contrast, hue-rotate, drop-shadow |
| `clip-path` | Shape reveals, clip animations |
| `backdrop-filter` | Frosted glass, blurs behind elements |
| `scroll-snap` | Scroll snap points |
| `position: fixed` (static layout) | Fixed positioning (no layout dependency) |

### The Forbidden List (Never Animate)

These properties trigger layout or paint — they are expensive:

```
--- NEVER ANIMATE THESE ---
Layout properties:     width, height, padding, margin, border
Position properties:   top, left, right, bottom, inset
Font properties:       font-size, font-weight, line-height, letter-spacing, font-family
Display properties:    display, visibility
Overflow:              overflow
Background:            background-color, background-image (via URL)
Box model:             border-radius, box-shadow, border-width
Color:                  color, border-color
Shadow:                 text-shadow
Content:                content

--- USE TRANSFORM INSTEAD ---
```

### The Transform-First Rule

```css
/* WRONG — triggers layout */
.bad { left: 100px; }  /* Layout on every frame */

/* RIGHT — compositor-only */
.good { transform: translateX(100px); }

/* WRONG — animating width */
.bad { width: 100%; }

/* RIGHT — use scale from current width */
.good { transform: scaleX(1); }
```

### Composite Operations

```css
/* layer-type: auto (default) — browser decides */
/* layer-type: gpu — force GPU compositing */
/* layer-type: cpu — software compositing (avoid) */

.accelerated {
  transform: translateZ(0); /* Legacy force-GPU method */
  /* Better: */
  will-change: transform;
}
```

---

## Tree-Shaking Unused CSS

Unused CSS dead weight ships to every user. Tree-shake it.

### PurgeCSS (Recommended)

```js
// vite.config.js
import { vite-plugin-purgecss } from 'vite-plugin-purgecss';

export default defineConfig({
  plugins: [
    purgeCss({
      safelist: ['active', 'nav-open', 'gsap-*'], // Always keep these
      blocklist: ['.debug-*', '.test-*'],          // Always remove these
    })
  ]
});
```

### Manual Auditing

```bash
# Use csscss to find duplicate rules
bunx csscss dist/styles.css

# Use uncss to remove unused selectors
bunx uncss --ignore ['.no-uncss'] http://localhost:3000
```

### CSS Modules / CSS-in-JS

```js
// CSS Modules — only imported styles ship
import styles from './Card.module.css';
// Only .Card and its children styles are included
```

### Critical CSS Extraction + Defer

```js
// Using vite-plugin-critical-css
import criticalPlugin from 'vite-plugin-critical-css';

export default defineConfig({
  plugins: [
    criticalPlugin({
      critical: {
        publicPath: 'dist/css/',
        inline: true,
        extract: true
      },
      nonCritical: {
        inline: false,
        media: 'print'
      }
    })
  ]
});
```

---

## CSS Performance Checklist

```plaintext
□ Inline critical CSS in <head> (< 14KB compressed)
□ Defer non-critical CSS (media="print" + onload trick)
□ Never use @import in CSS files (creates serial chain)
□ contain: layout on frequently updating components
□ content-visibility: auto on below-fold sections
□ will-change applied just before animation, removed after
□ Only GPU-accelerated properties animated (transform, opacity, filter)
□ No layout property animations (width, height, top, left, etc.)
□ PurgeCSS / tree-shaking for unused selectors
□ CSS custom properties for consistency and reuse
□ contain: strict on modals and overlays
□ contain-intrinsic-size on content-visibility: auto elements (prevents CLS)
□ No @import at the top of CSS files
□ font-display: swap on all web fonts (also a CSS concern)
□ No unused CSS selectors shipping to production
```

---

## CSS Performance Quick Reference

```css
/* GPU acceleration shortcut */
.gpu { transform: translateZ(0); }

/* Contain everything (strict isolation) */
.isolated { contain: strict; }

/* Skip off-screen rendering */
.lazy-section { content-visibility: auto; contain-intrinsic-size: 0 500px; }

/* Animation preparation */
.ready { will-change: transform, opacity; }

/* Post-animation cleanup */
.done { will-change: auto; }

/* Image aspect ratio (CLS prevention) */
.media { aspect-ratio: 16 / 9; width: 100%; height: auto; }

/* No layout shifts on load */
.fallback-font {
  size-adjust: 103%;
  ascent-override: 95%;
  descent-override: 25%;
}
```
