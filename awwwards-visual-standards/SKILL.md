---
name: awwwards-visual-standards
description: >
  Visual design standards for the awwwards-designer workflow. Contains typography
  systems, color token architecture, layout rhythm, iconography, and accessibility
  baseline. Consulted during Phase 2 to inform the Stitch brief. After Phase 3,
  DESIGN.md is the sole authority on all visual decisions — this skill does not
  override it. Use these standards to guide what goes into the Stitch prompt, not
  to second-guess what Stitch produced.
---

# Awwwards Visual Standards

> **DESIGN.md is the authority.** After Phase 3 (Stitch MCP), `extract_design_context` produces a DESIGN.md containing the fonts, color tokens, spacing, and component rules for this specific project. That file overrides everything in this skill. Do not apply these standards to override DESIGN.md decisions. Apply them only when writing the Stitch brief (Phase 2) or when DESIGN.md has a gap that needs filling.

> The difference between a template and an award-winning site lives in these rules.

---

## Table of Contents

- [Typography](#typography) · [Color](#color) · [Layout & Spacing](#layout--spacing) · [Icons](#icons) · [Hard Stops](#hard-stops) · [Quick Reference](#quick-reference)
- Reference files: `references/typography.md` · `references/color-systems.md` · `references/responsive-design.md` · `references/accessibility.md`

---

## Typography

### Distinctive Over Safe

SOTD winners use typography as a primary differentiator. For the Stitch brief, guide toward distinctive display fonts: **Syne**, **Space Grotesk**, **Fraunces**, **Clash Display**, **Bebas Neue**, **Plus Jakarta Sans**, **Outfit**, **Archivo**. For body text, readability and brand fit take precedence — any font can be right in context. If DESIGN.md specifies fonts, those are correct by definition. Do not override.

Variable fonts preferred for animation-friendly weight interpolation.

### Fluid Type Scale with clamp()

Never use fixed `px` for headings. Always use `clamp()` for fluid scaling:

```css
:root {
  --font-size-display: clamp(2.5rem, 7vw + 1rem, 7rem);  /* 40→112px */
  --font-size-h1:       clamp(2rem, 3vw + 1rem, 4rem);   /* 32→64px  */
  --font-size-h2:       clamp(1.5rem, 2vw + 0.75rem, 3rem); /* 24→48px */
  --font-size-h3:       clamp(1.25rem, 1vw + 0.75rem, 2rem);
  --font-size-body-lg:  clamp(1.125rem, 0.25vw + 1rem, 1.25rem);
  --font-size-body:     clamp(1rem, 0.25vw + 0.875rem, 1.125rem);
  --font-size-caption:  clamp(0.75rem, 0.25vw + 0.625rem, 0.875rem);

  --leading-display: 0.95;
  --leading-h1: 1.05;
  --leading-body: 1.6;
  --tracking-tight: -0.03em;
  --tracking-widest: 0.2em; /* overline/label */
}
```

**Font loading:**
```html
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preload" href="font.woff2" as="font" type="font/woff2" crossorigin>
<style>
  @font-face {
    font-family: 'Syne';
    src: url('/fonts/syne-variable.woff2') format('woff2-variations');
    font-weight: 400 800;
    font-display: swap;
  }
</style>
```

### Descender Safety (Critical!)

Text ≥ 48px must have `overflow: visible` + `padding-bottom` to prevent clipping of `g`, `j`, `p`, `q`, `y`.

**Measure per font (Canvas API):**
```javascript
const canvas = document.createElement('canvas');
const ctx = canvas.getContext('2d');
ctx.font = '800 100px Syne';
const descender = ctx.measureText('gjpqy').actualBoundingBoxDescent;
// Syne: ~22px at 100px. Fraunces: ~18px. Bebas Neue: 0px (all-caps).
```

**Safe implementation:**
```css
.display-text {
  font-size: clamp(2.5rem, 7vw + 1rem, 7rem);
  overflow: visible;                    /* CRITICAL */
  padding-bottom: 0.12em;               /* ~12% clearance — adjust per font */
  line-height: 0.95;
}
```

---

## Color

### 3-Layer Token Architecture

```
Primitive → Semantic → Component
Raw hex   → Intent   → Reference
Never use primitives in components.
```

```css
/* Layer 1: Primitives (raw values — never use directly in components) */
:root {
  --primitive-gray-50:  #f9fafb;
  --primitive-gray-900: #111827;
  --primitive-blue-500:  #3b82f6;
  --primitive-blue-600:  #2563eb;
}

/* Layer 2: Semantics (USE THESE in components) */
:root {
  --color-bg-primary:     var(--primitive-gray-50);
  --color-text-primary:   var(--primitive-gray-900);
  --color-text-secondary: var(--primitive-gray-600);
  --color-accent:        var(--primitive-blue-500);
  --color-accent-hover:  var(--primitive-blue-600);
  --color-border:         var(--primitive-gray-200);
}

/* Layer 3: Components (convenience aliases) */
.button-primary {
  background: var(--color-accent);
  color: var(--color-text-inverse);
}
```

### Dark Mode

```css
:root {
  --color-bg-primary:   #ffffff;
  --color-text-primary: #111827;
}
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg-primary:   #0a0a0a;
    --color-text-primary: #f9fafb;
  }
}
/* OR class-based: [data-theme="dark"] */
```

### WCAG Contrast

| Combination              | Ratio | Standard    |
|--------------------------|-------|-------------|
| Gray-900 (#111827) on white | 16.1:1 | AAA        |
| Gray-600 (#4b5563) on white | 7.0:1  | AAA        |
| Gray-500 (#6b7280) on white | 4.5:1  | AA ⚠️ (risky — too close) |
| Blue-600 (#2563eb) on white | 4.6:1  | AA         |
| White on gray-900        | 16.1:1 | AAA        |
| White on blue-600        | 4.6:1  | AA         |

**Rule:** Never below 4.5:1 body text, never below 3:1 large text. Use `#4b5563` or darker for body text.

### Animation Color (HSL/OKLCH)

```css
/* HSL for simple transitions */
.hover-accent {
  background: hsl(220, 70%, 50%);
  transition: background 0.3s ease;
}
.hover-accent:hover {
  background: hsl(220, 70%, 60%);
}

/* OKLCH for perceptually uniform gradients — no muddy midpoints */
.hero-gradient {
  background: linear-gradient(
    135deg,
    oklch(55% 0.25 250) 0%,   /* Blue */
    oklch(60% 0.25 340) 100%  /* Pink */
  );
}
```

---

## Layout & Spacing

### 4px/8px Spacing Scale

```css
:root {
  --space-1: 0.25rem;  /* 4px  */
  --space-2: 0.5rem;   /* 8px  */
  --space-4: 1rem;      /* 16px */
  --space-6: 1.5rem;   /* 24px */
  --space-8: 2rem;     /* 32px */
  --space-12: 3rem;    /* 48px */
  --space-16: 4rem;    /* 64px */
  --space-24: 6rem;    /* 96px */
  --space-32: 8rem;    /* 128px */
}
```

### 100dvh NOT 100vh (Hard Stop!)

`100vh` excludes the mobile browser address bar, causing layout overflow.
`100dvh` (dynamic viewport height) adjusts in real-time.

```css
/* ✅ CORRECT */
.fullscreen { height: 100dvh; min-height: 100dvh; }

/* ❌ WRONG — causes scroll overflow on mobile */
.fullscreen { height: 100vh; }
```

### Container & Asymmetry

```css
.container {
  width: 100%;
  max-width: 1024px;
  margin-inline: auto;
  padding-inline: var(--space-6);
}
@media (max-width: 640px) { .container { padding-inline: var(--space-4); } }

/* Asymmetric layouts — don't center everything */
.featured-section {
  padding-left: clamp(1rem, 8vw, 10rem);
  border-left: 1px solid var(--color-border);
}
```

---

## Icons

### Lucide Only — 1.5px Stroke

All icons MUST use Lucide. No Heroicons, Font Awesome, or custom SVGs unless brand-specific.

```bash
bun add lucide-react       # React
bun add lucide-vue-next    # Vue
```

```jsx
// Size scale: 16 / 20 / 24 / 32px
// Stroke: ALWAYS 1.5px — never deviate
import { ArrowRight, Menu, Mail } from 'lucide-react';

<ArrowRight size={24} strokeWidth={1.5} />
<Menu size={20} strokeWidth={1.5} />

// For dark mode, use currentColor
<ArrowRight size={24} strokeWidth={1.5} color="currentColor" />
```

---

## Hard Stops

| Rule                    | Wrong                       | Correct                      |
|-------------------------|-----------------------------|------------------------------|
| Viewport height         | `height: 100vh`             | `height: 100dvh`             |
| Text overflow clip      | `overflow: hidden` on text  | `overflow: visible` + padding |
| Icon library            | Heroicons, Font Awesome     | Lucide, 1.5px stroke only    |
| Body text contrast      | Gray-500 on white (4.5:1)  | Gray-600+ on white (7:1+)    |
| Font choice             | Inter, Roboto, Open Sans    | Distinctive fonts (see list) |
| Responsive images       | Single `<img>`             | `<picture>` with AVIF/WebP   |
| Touch targets           | < 44×44px                   | ≥ 44×44px                    |
| Semantic HTML           | `<div onclick>` for buttons | `<button>`, `<a href>`        |
| Reduced motion          | Ignored                     | `@media (prefers-reduced-motion)` |

---

## Quick Reference

### Do / Don't

| Do ✅                              | Don't ❌                              |
|-----------------------------------|--------------------------------------|
| `clamp()` for fluid text          | Fixed `px` for headings              |
| `100dvh` for full-screen sections  | `100vh` (causes mobile overflow)     |
| Lucide icons, 1.5px stroke         | Mixed icon sets, inconsistent stroke |
| `overflow: visible` + padding-bottom on large text | `overflow: hidden` clips descenders |
| Gray-600+ for body text (7:1+)   | Gray-500 for body text (4.5:1 — risky) |
| Semantic HTML (`<button>`, `<a>`) | `<div onclick>` for interactions     |

### Common Mistakes & Fixes

| Problem                            | Fix                                               |
|------------------------------------|---------------------------------------------------|
| Clipped descenders (g, y, p, q)   | `overflow: visible` + `padding-bottom: 0.08–0.12em` |
| Mobile scroll overflow             | Replace `100vh` with `100dvh`                    |
| Gray-500 text unreadable           | Upgrade to gray-600 (#4b5563) or darker           |
| Icons clash in dark mode           | Use `stroke="currentColor"` on all SVGs          |
| LCP image slow to load             | `<picture>` with AVIF/WebP, `fetchpriority="high"`, preload |

---

## Reference Files

| File                           | Deep Dive On                           |
|--------------------------------|----------------------------------------|
| `references/typography.md`     | Font pairing, type scale math, descender measurement, fluid type |
| `references/color-systems.md`  | 3-layer tokens, dark mode, OKLCH, WCAG contrast table |
| `references/responsive-design.md` | Mobile-first breakpoints, container queries, 100dvh, touch targets |
| `references/accessibility.md`  | WCAG 2.1 AA checklist, focus indicators, reduced-motion, ARIA |

---

## Ship Checklist

- [ ] Typography: Distinctive fonts, fluid `clamp()`, descender clearance measured
- [ ] Colors: 3-layer tokens, dark mode, all combos ≥ 4.5:1
- [ ] Layout: `100dvh`, spacing scale, intentional asymmetry
- [ ] Icons: Lucide only, 1.5px stroke, consistent sizes
- [ ] Images: `<picture>`, AVIF/WebP, `srcset`/`sizes`, `fetchpriority="high"` on hero
- [ ] Accessibility: Focus visible, reduced-motion, semantic HTML, 44px touch targets
- [ ] Performance: Fonts preloaded, `font-display: swap`, CLS < 0.1
