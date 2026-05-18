# Typography Deep Dive

> "Typography is what language looks like." — Matthew Carter

This reference covers font selection philosophy, type scale definition, line height tuning,
fluid scaling with `clamp()`, variable font usage, and the critical descender clearance problem.

---

## Font Selection Philosophy

### The Template Trap: Inter, Roboto, Open Sans

Using system fonts or "safe" Google Fonts is the single fastest way to signal "generic template."
Awwwwards judges see hundreds of sites using Inter. Roboto appears on every Material Design knockoff.
Open Sans is the font of corporate intranet.

**The Awwwwards standard:** Typography should be a deliberate brand choice, not a default.

### Characteristics of Award-Winning Type

SOTD winners typically share these type traits:

1. **Distinctive personality** — A font that could only belong to this brand
2. **Optical size awareness** — Variable fonts that adjust stroke width at small sizes
3. **High x-height** (optional) — Improves legibility at small sizes
4. **Purposeful weight range** — Wide weight spectrum for variable font animation
5. **Web-optimized** — Has a variable `.woff2` variant with Latin subset

### Recommended Fonts by Category

**Headline/Display Fonts (high personality):**
| Font           | Best For               | Weights        | Variable | Source                    |
|----------------|------------------------|----------------|-----------|---------------------------|
| Syne           | Bold, geometric, tech  | 400–800        | Yes       | Google Fonts              |
| Clash Display  | Modern editorial       | 500–700        | Yes       | Commercial (Fontshare)    |
| Bebas Neue     | Bold, condensed impact | 400            | No        | Google Fonts              |
| Fraunces       | Serif warmth, quirky   | 100–900        | Yes       | Google Fonts              |
| DM Serif       | Elegant, editorial     | 400            | No        | Google Fonts              |
| Cabinet Grotesk| Contemporary grotesque | 300–800        | Yes       | Commercial                |
| Tiempos Headline | Premium editorial    | 400–700        | No        | Commercial                |

**Body/UI Fonts (readable, pairs with headlines):**
| Font           | Best For               | Weights        | Variable | Source                    |
|----------------|------------------------|----------------|-----------|---------------------------|
| Space Grotesk  | Technical, modern      | 300–700        | Yes       | Google Fonts              |
| Plus Jakarta Sans | Clean, versatile    | 200–800        | Yes       | Google Fonts              |
| Outfit         | Geometric, friendly    | 100–900        | Yes       | Google Fonts              |
| Archivo        | Strong, readable       | 100–1000       | Yes       | Google Fonts              |
| Satoshi        | Contemporary, premium   | 300–900        | Yes       | Commercial (Fontshare)     |
| Aktiv Grotesk  | Corporate, premium     | 400–700        | No        | Commercial                |

**Variable Font Animation (weight interpolation):**

Variable fonts enable smooth weight transitions impossible with static fonts:

```css
.heading-animated {
  font-family: 'Syne', sans-serif;
  font-variation-settings: 'wght' 400;
  transition: font-variation-settings 0.4s cubic-bezier(0.16, 1, 0.3, 1);
}
.heading-animated:hover {
  font-variation-settings: 'wght' 800;
}
```

---

## Type Scale

### Base Size System

Start with a base of 16px (never less). Build scale from there.

```
Scale ratio: 1.25 (Major Third) — OR — 1.333 (Perfect Fourth)

Using 1.25:
16 → 20 → 25 → 31 → 39 → 49 → 61 → 76 → 95 → 119px

Using 1.333:
16 → 21 → 28 → 37 → 50 → 66 → 88 → 117 → 156px

Using modular scale: https://www.modularscale.com/
```

### Role-Based Scale with Fluid Ranges

| Role     | Min (mobile, 320px) | Max (desktop, 1440px) | Clamp Expression                |
|----------|---------------------|----------------------|---------------------------------|
| Display  | 40px                | 112px                | `clamp(2.5rem, 7vw + 1rem, 7rem)`   |
| H1       | 32px                | 64px                 | `clamp(2rem, 3vw + 1rem, 4rem)`      |
| H2       | 24px                | 48px                 | `clamp(1.5rem, 2vw + 0.75rem, 3rem)` |
| H3       | 20px                | 32px                 | `clamp(1.25rem, 1vw + 0.75rem, 2rem)` |
| Body L   | 18px                | 20px                 | `clamp(1.125rem, 0.25vw + 1rem, 1.25rem)` |
| Body     | 16px                | 18px                 | `clamp(1rem, 0.25vw + 0.875rem, 1.125rem)` |
| Small    | 14px                | 16px                 | `clamp(0.875rem, 0.25vw + 0.75rem, 1rem)` |
| Caption  | 12px                | 14px                 | `clamp(0.75rem, 0.25vw + 0.625rem, 0.875rem)` |
| Overline | 10px                | 12px                 | `clamp(0.625rem, 0.15vw + 0.5rem, 0.75rem)` |

### CSS Custom Properties

```css
:root {
  /* Font Families */
  --font-display: 'Syne', sans-serif;
  --font-body: 'Space Grotesk', sans-serif;
  --font-mono: 'JetBrains Mono', monospace;

  /* Type Scale */
  --font-size-display: clamp(2.5rem, 7vw + 1rem, 7rem);
  --font-size-h1: clamp(2rem, 3vw + 1rem, 4rem);
  --font-size-h2: clamp(1.5rem, 2vw + 0.75rem, 3rem);
  --font-size-h3: clamp(1.25rem, 1vw + 0.75rem, 2rem);
  --font-size-body-lg: clamp(1.125rem, 0.25vw + 1rem, 1.25rem);
  --font-size-body: clamp(1rem, 0.25vw + 0.875rem, 1.125rem);
  --font-size-small: clamp(0.875rem, 0.25vw + 0.75rem, 1rem);
  --font-size-caption: clamp(0.75rem, 0.25vw + 0.625rem, 0.875rem);
  --font-size-overline: clamp(0.625rem, 0.15vw + 0.5rem, 0.75rem);

  /* Line Heights */
  --leading-display: 0.95;
  --leading-h1: 1.05;
  --leading-h2: 1.15;
  --leading-h3: 1.25;
  --leading-body: 1.6;
  --leading-body-lg: 1.55;
  --leading-caption: 1.4;

  /* Letter Spacing */
  --tracking-tight: -0.03em;
  --tracking-normal: 0em;
  --tracking-wide: 0.05em;
  --tracking-wider: 0.1em;
  --tracking-widest: 0.2em;
}
```

---

## Line Height

### Role-Based Line Height Rules

| Role     | Line Height | Rationale                                         |
|----------|-------------|---------------------------------------------------|
| Display  | 0.9 – 1.1   | Tight for impact. Large type reads differently.   |
| H1       | 1.0 – 1.2   | Large but still a headline, not a paragraph.      |
| H2       | 1.15 – 1.3  | Section titles, still considered display.          |
| H3       | 1.2 – 1.4   | Sub-headings, transition to body.                 |
| Body     | 1.5 – 1.7   | Comfortable reading. Larger if line length is long. |
| Caption  | 1.4 – 1.5   | Small text needs slightly tighter leading.        |

### Line Length Considerations

Line height should increase as line length increases:

| Characters per line | Recommended Line Height |
|---------------------|-------------------------|
| 45–75 (optimal)     | 1.5 – 1.6              |
| 75–85                | 1.6 – 1.7              |
| 85–100 (wide)        | 1.7 – 1.8              |

**Max-width for comfortable line length:**
```css
.prose {
  max-width: 65ch; /* Characters, not pixels — always correct */
}
```

---

## Letter Spacing

### Spacing by Size and Weight

| Style              | Tracking    | Use Case                                  |
|--------------------|-------------|-------------------------------------------|
| Display, large     | -0.03em     | Large headings feel tighter               |
| H1–H3, uppercase   | -0.02em     | Normalize wide caps                       |
| Body text          | 0em         | Default. Never add tracking to body.      |
| Small/caption      | 0.02em      | Slight openness aids readability          |
| Overline/label     | 0.15–0.2em  | UPPERCASE labels, 10–14px                  |

### CSS Implementation

```css
.overline {
  font-size: var(--font-size-overline);
  letter-spacing: var(--tracking-widest);
  text-transform: uppercase;
  font-weight: 600;
}

.display-heading {
  font-size: var(--font-size-display);
  letter-spacing: var(--tracking-tight);
}
```

---

## Variable Font Selection

### Why Variable Fonts?

1. **Single file, multiple weights** — Better performance than multiple font files
2. **Weight animation** — Smooth interpolation between weights (impossible with static fonts)
3. **Optical sizing** — Some variable fonts adjust stroke width at different sizes automatically
4. **Custom axes** — Some fonts have custom axes (e.g., `CASL` for casual, `SOFT` for softness)

### Google Fonts Variable Font Quick Reference

| Font             | Axes Available                        | Best For                 |
|------------------|---------------------------------------|--------------------------|
| Syne             | `wght` (400–800)                      | Bold display, tech       |
| Space Grotesk    | `wght` (300–700)                      | Body + headings          |
| Fraunces         | `wght` (100–900), `SOFT` (0–100), `WONK` (0–1) | Quirky serifs       |
| Outfit           | `wght` (100–900)                      | Clean geometric body      |
| Plus Jakarta Sans| `wght` (200–800)                      | Modern versatile         |
| Archivo          | `wght` (100–1000)                     | Strong, bold body        |
| JetBrains Mono   | `wght` (100–800)                      | Code, monospace           |

### Variable Font Loading

```html
<!-- 1. Preconnect first -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<!-- 2. Variable font with all weights in one file -->
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400..800&display=swap" rel="stylesheet">

<!-- 3. Static font (only if variable not available) -->
<link href="https://fonts.googleapis.com/css2?family=Bebas+Neue&display=swap" rel="stylesheet">
```

```css
/* Variable font with animation */
@font-face {
  font-family: 'Syne';
  src: url('/fonts/Syne-Variable.woff2') format('woff2-variations');
  font-weight: 400 800;
  font-style: normal;
  font-display: swap;
}

/* Animation-friendly heading */
@keyframes weightPulse {
  0%, 100% { font-variation-settings: 'wght' 400; }
  50% { font-variation-settings: 'wght' 800; }
}
```

---

## Font Loading Performance

### Font-Display Strategy

| Value        | Behavior                                        | Best For                          |
|--------------|-------------------------------------------------|-----------------------------------|
| `swap`       | Show fallback immediately, swap when loaded     | Body text (default)               |
| `optional`   | Use fallback if font loads slowly               | Decorative fonts (performance)    |
| `block`      | Invisible text up to 3s, then swap             | Critical headlines (avoid)        |
| `auto`       | Browser default                                 | Never explicitly                  |

```css
@font-face {
  font-family: 'Syne';
  src: url('/fonts/syne-variable.woff2') format('woff2-variations');
  font-weight: 400 800;
  font-display: swap; /* Always use swap for body */
}
```

### Preloading Critical Fonts

```html
<!-- Preload the most important font (usually the display/hero font) -->
<link rel="preload" href="/fonts/syne-variable.woff2" as="font" type="font/woff2" crossorigin>
```

### Font Subsetting

Reduce font file size by subsetting to Latin characters only:

```html
<!-- Google Fonts with Latin subset -->
<link href="https://fonts.googleapis.com/css2?family=Syne:wght@400..800&subset=latin&display=swap" rel="stylesheet">
```

**For self-hosted fonts:** Use `glyphhanger` or `fonttools` to subset:
```bash
bunx glyphhanger --subset=font.woff2 --whitelist=latin
```

---

## Descender Clearance: The Hidden Problem

### The Issue

At large font sizes (≥ 48px equivalent), descender characters (`g`, `j`, `p`, `q`, `y`)
are often clipped by `overflow: hidden` on parent containers or `text-overflow: ellipsis`.

This is especially problematic in:
- Hero headlines with text animation
- Sticky headers
- Cards with fixed-height text containers
- Text inside SVG or clip-path masks

### Canvas API Measurement Method

Measure actual descender depth per font at a reference size:

```javascript
function measureDescender(fontFamily, fontSize = 100) {
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');
  ctx.font = `800 ${fontSize}px ${fontFamily}`;
  
  const metrics = ctx.measureText('gjpqyG');
  const ascent = metrics.actualBoundingBoxAscent;
  const descent = metrics.actualBoundingBoxDescent;
  
  // Descender extends below baseline (positive value = goes down)
  const descenderDepth = descent;
  const clearanceNeeded = (descenderDepth / fontSize) * 100; // as percentage of font-size
  
  return {
    fontFamily,
    fontSize,
    ascent,
    descent,
    clearanceAsPercent: clearanceNeeded,
  };
}

// Usage
console.log(measureDescender('Syne', 100));
// { fontFamily: 'Syne', fontSize: 100, descent: 22, clearanceAsPercent: 22% }

console.log(measureDescender('Fraunces', 100));
// { fontFamily: 'Fraunces', fontSize: 100, descent: 18, clearanceAsPercent: 18% }
```

### Common Descender Values (Measured at 100px)

| Font        | Descender Depth | Clearance Needed |
|-------------|-----------------|------------------|
| Syne        | 22px            | 22% of font-size |
| Space Grotesk | 24px          | 24%              |
| Fraunces    | 18px            | 18%              |
| Clash Display | 20px          | 20%              |
| Bebas Neue  | 0px             | 0% (all-caps)    |
| DM Serif    | 16px            | 16%              |
| Plus Jakarta Sans | 24px      | 24%              |

### Safe CSS Patterns

**Pattern 1: overflow: visible + padding-bottom**
```css
.hero-heading {
  font-size: var(--font-size-display);
  overflow: visible; /* CRITICAL */
  padding-bottom: 0.18em; /* minimum clearance — measure actual descender per font via Canvas API */
  line-height: 0.95;
}
```

**Pattern 2: Padding-bottom based on measured descender**
```css
.hero-heading {
  /* For Syne at 96px max: 96px * 22% = 21px clearance */
  padding-bottom: calc(var(--font-size-display) * 0.22);
  overflow: visible;
}
```

**Pattern 3: Safe container approach**
```css
.hero-section {
  /* Add extra padding to container instead of clipping text */
  padding-block: var(--space-8);
}

.hero-heading {
  /* Safe even with overflow:hidden on parent */
  margin-block: calc(var(--space-8) * -0.3);
}
```

---

## Fluid Typography Implementation

### The Math Behind clamp()

```
clamp(min, preferred, max)

preferred = (max - min) / (maxVw - minVw) * 100vw + (min - ratio * minVw)

Where:
  min = minimum font size (px)
  max = maximum font size (px)
  minVw = viewport width at minimum (usually 320px)
  maxVw = viewport width at maximum (usually 1440px)
```

### Step-by-Step Calculation Example

For H1: 32px at 320px viewport → 64px at 1440px viewport:

```
min = 32, max = 64, minVw = 320, maxVw = 1440

slope = (max - min) / (maxVw - minVw) = (64 - 32) / (1440 - 320)
      = 32 / 1120 = 0.02857

intersection = min - slope * minVw = 32 - (0.02857 * 320)
             = 32 - 9.14 = 22.86

Result: clamp(32px, calc(2.857vw + 22.86px), 64px)
Simplified: clamp(2rem, 0.029 * 100vw + 1.43rem, 4rem)
```

### The Generator Method

Use this simpler approach — pick min, max, and viewport range:

```css
/* From Utopia.fyi: https:// utopia.fyi/css/clip/ */
h1 {
  font-size: clamp(2rem, 1rem + 3vw, 4rem);
}
/* 
  2rem = 32px at 320px
  4rem = 64px at 1440px
  Formula: clamp(min, preferred, max)
  preferred = 1rem + 3vw (grows 3px per 100px of viewport)
*/
```

### Testing Fluid Typography

```css
/* Use custom properties for easy testing */
:root {
  --test-vw: 320px; /* Change this to test different viewports */
}

/* Debug: Show current computed size */
.debug-typography::after {
  content: 'Computed: ' attr(data-size);
}
```

---

## Font Pairing Guide

### Pairing Principles

1. **Contrast, not conflict** — Pair geometric with humanist, not two of the same style
2. **Limit to 2 fonts** — Display + body is sufficient for most projects
3. **Consider x-height** — Fonts with similar x-heights pair more harmoniously
4. **Test at all sizes** — Pairing that looks good at 72px might clash at 16px

### Proven Awwwwards Pairings

| Display Font      | Body Font         | Vibe                        |
|-------------------|-------------------|-----------------------------|
| Syne              | Space Grotesk     | Bold tech-forward           |
| Fraunces          | Plus Jakarta Sans | Warm editorial              |
| Clash Display     | Satoshi           | Modern premium              |
| Bebas Neue        | Outfit            | Bold impact                 |
| DM Serif          | Archivo           | Elegant editorial           |
| Cabinet Grotesk   | Instrument Sans   | Contemporary refined        |
| Tiempos Headline  | Aktiv Grotesk     | High-end luxury             |

### Pairing Examples in CSS

```css
:root {
  /* Pairing 1: Syne + Space Grotesk */
  --font-display: 'Syne', sans-serif;
  --font-body: 'Space Grotesk', sans-serif;
  --font-weight-display: 700;
  --font-weight-body: 400;
}

h1, h2, h3 {
  font-family: var(--font-display);
  font-weight: var(--font-weight-display);
}

p, li, label, input {
  font-family: var(--font-body);
  font-weight: var(--font-weight-body);
}
```
