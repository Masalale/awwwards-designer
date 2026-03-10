# Aesthetic Foundations: Design System & Premium Fundamentals

**Colors are user-owned — this file does not provide color guidance.** Wait for the user to supply the palette. Do not invent, derive, or fill color variables.

---

## Typography System: Golden Ratio (Φ = 1.618)

All sizes calculated using the golden ratio for mathematical harmony. Includes responsive scaling with `clamp()` for fluid typography across all viewport sizes.

### Complete Type Scale with Clamp Values

```css
:root {
  /* Golden Ratio Scale */
  --ratio: 1.618;

  /* Base unit (16px = 1rem) */
  --base: 1rem;

  /* Calculate all sizes using ratio */
  /* Step up: value * 1.618 */
  /* Step down: value / 1.618 */

  /* Responsive sizes: clamp(mobile, vw-relative, desktop) */
  --font-body: clamp(1rem, 1.5vw, 1.125rem);
  --font-lead: clamp(1.25rem, 1.875vw, 1.406rem);
  --font-subheading: clamp(1.625rem, 3vw, 2.25rem);
  --font-heading: clamp(2.625rem, 5vw, 3.5rem);
  --font-display: clamp(4.25rem, 8vw, 5.75rem);
  --font-hero: clamp(6.854rem, 12vw, 9.5rem);

  /* Micro sizes (body variations) */
  --font-micro: clamp(0.75rem, 1vw, 0.875rem);
  --font-small: clamp(0.875rem, 1.25vw, 1rem);

  /* Line heights: tighter at larger sizes */
  --lh-body: 1.6;
  --lh-lead: 1.5;
  --lh-subheading: 1.35;
  --lh-heading: 1.2;
  --lh-display: 1.1;
  --lh-hero: 1.05;

  /* Letter spacing */
  --ls-normal: 0;
  --ls-tight: -0.02em;
  --ls-wide: 0.02em;
  --ls-caps: 0.05em;
  --ls-light: 0.01em;
}

/* Apply base typography */
html {
  font-size: 16px;
}

body {
  font-family: var(--font-sans);
  font-size: var(--font-body);
  line-height: var(--lh-body);
  color: var(--color-text);
  background: var(--color-background);
}

/* Semantic text elements */
p {
  font-size: var(--font-body);
  line-height: var(--lh-body);
  margin-bottom: 1.5rem;
}

p.lead {
  font-size: var(--font-lead);
  line-height: var(--lh-lead);
  color: var(--color-text-secondary);
}

h1 {
  font-family: var(--font-serif);
  font-size: var(--font-hero);
  line-height: var(--lh-hero);
  font-weight: 600;
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
  margin-bottom: 1rem;
}

h2 {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 500;
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
  margin-bottom: 0.75rem;
}

h3 {
  font-family: var(--font-sans);
  font-size: var(--font-heading);
  line-height: var(--lh-heading);
  font-weight: 600;
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
  margin-bottom: 0.5rem;
}

h4 {
  font-family: var(--font-sans);
  font-size: var(--font-subheading);
  line-height: var(--lh-subheading);
  font-weight: 600;
  margin-bottom: 0.5rem;
}

h5, h6 {
  font-family: var(--font-sans);
  font-size: var(--font-body);
  line-height: var(--lh-body);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: var(--ls-caps);
  margin-bottom: 0.5rem;
}

/* Display class for special moments */
.display {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 600;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
}

/* Subheading class */
.subheading {
  font-family: var(--font-sans);
  font-size: var(--font-subheading);
  line-height: var(--lh-subheading);
  font-weight: 600;
  letter-spacing: var(--ls-normal);
}

/* Micro text */
.micro {
  font-family: var(--font-sans);
  font-size: var(--font-micro);
  line-height: 1.4;
  text-transform: uppercase;
  letter-spacing: var(--ls-caps);
  color: var(--color-text-tertiary);
}

/* Monospace for code/technical */
code, pre {
  font-family: var(--font-mono);
  font-size: var(--font-small);
  line-height: 1.5;
  background: var(--color-background-secondary);
  padding: 0.5rem 1rem;
  border-radius: 4px;
}
```

---

## Premium Font Recommendations

### By Use Case

**Editorial / Luxury:**
- Editorial New (serif) — Elegant, premium, distinctive
- Freight Display (serif) — High-impact, architectural
- Canela (serif) — Modern luxury feel
- Lyon (serif) — Contemporary elegance
- Descender clearance: 0.18em - 0.22em

**Technical / Digital:**
- PP Neue Machina (sans) — Technical precision
- Söhne Mono (monospace) — Clean, modern
- IBM Plex Mono (monospace) — Professional, open
- Descender clearance: 0.15em - 0.18em

**High-Impact Sans:**
- Druk (sans) — Bold, confident
- Aktiv Grotesk Extended (sans) — Modern, contemporary
- Suisse Int'l (sans) — Versatile, legible
- Descender clearance: 0.10em - 0.14em

**Body / UI:**
- Söhne (sans) — Versatile, premium
- IBM Plex Sans (sans) — Open source, professional
- PP Sans (sans) — Contemporary, balanced
- Descender clearance: 0.12em - 0.16em

**Variable Fonts (for animation):**
- Fraunces (serif) — Variable weight, optical size
- Recursive (sans) — Wide weight and width variation
- iA Writer Mono (mono) — Slant axis for emphasis

### Font Pairing Formula

**Premium pairing rule:** Serif for headlines + Sans for body
- Primary: Editorial New (headlines)
- Secondary: Söhne (body, UI)
- Accent: PP Neue Machina Mono (accent text, code)

---

## Icon System

**Lucide is the only icon library used in this skill.** No Font Awesome, no Heroicons, no Phosphor, no inline SVG from random sources. One coherent system, always.

### Setup

```html
<!-- Vanilla HTML — CDN -->
<script src="https://unpkg.com/lucide@latest"></script>
<script>lucide.createIcons();</script>

<!-- Usage -->
<i data-lucide="arrow-right" class="icon"></i>
```

```jsx
// React / Astro
import { ArrowRight, Menu, X, ChevronDown } from 'lucide-react';

<ArrowRight size={20} strokeWidth={1.5} />
```

### Sizing & Weight Rules

```css
.icon {
  /* Always set size explicitly — never inherit */
  width: 20px;
  height: 20px;
  stroke-width: 1.5; /* Default — visually balanced */
  flex-shrink: 0;    /* Prevent icon from squishing in flex layouts */
}

/* For large decorative icons (hero, feature sections) */
.icon-lg {
  width: 40px;
  height: 40px;
  stroke-width: 1; /* Lighter for large sizes */
}

/* For small utilitarian icons (inline, badges) */
.icon-sm {
  width: 16px;
  height: 16px;
  stroke-width: 2; /* Heavier for small sizes — maintains visual presence */
}
```

### Rules

- Stroke weight follows size: larger icons use `stroke-width: 1`, smaller icons use `stroke-width: 2`
- Use icons sparingly — navigation, close marks, directional arrows. Never as explanations for unclear button labels
- Never emoji as interface icons
- If Lucide doesn't have the icon you need: draw a minimal inline SVG matching Lucide's system (`stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`, no fill, `viewBox="0 0 24 24"`)

---

## Line Height & Spacing Rules

### Detailed Line Height Guidelines

```css
/* Body text: generous for readability */
body {
  line-height: 1.6;   /* Comfortable for extended reading */
  margin-bottom: 1.5rem;
}

p + p {
  margin-top: 0;      /* Prevent double margins */
}

/* Subheading: slightly tighter */
.subheading {
  line-height: 1.35;  /* Tighter, more intentional */
}

/* Heading: tight for premium feel */
h2, h3 {
  line-height: 1.2;   /* Tight, confident */
}

/* Display: very tight */
.display {
  line-height: 1.1;   /* Extreme, premium, premium feel */
}

/* Hero: absolute minimum */
h1 {
  line-height: 1.05;  /* Aggressive, powerful */
}
```

---

## Letter Spacing Guidelines

```css
/* Standard: no adjustment */
p, body {
  letter-spacing: var(--ls-normal);  /* 0 */
}

/* Tight: premium display text */
.display, h1, h2 {
  letter-spacing: var(--ls-tight);   /* -0.02em */
}

/* ALL CAPS: always add spacing */
.caps, h5, h6 {
  text-transform: uppercase;
  letter-spacing: var(--ls-caps);    /* 0.05em */
  font-weight: 700;
  font-size: 0.875em;
}

/* Light weight fonts: add slight spacing */
.light {
  font-weight: 300;
  letter-spacing: var(--ls-light);   /* 0.01em */
}

/* Monospace: tight for code */
code {
  letter-spacing: 0;
}
```

### Letter Spacing Rule

- Normal weight (400-500): no adjustment
- Bold weight (600+): tight (-0.02em)
- Light weight (<400): light space (+0.01em)
- ALL CAPS: always wider (+0.05em)
- Display/hero: tight (-0.02em to -0.03em)

---

---

## Quick Start: Base CSS Variables

Copy this into your project. **Color variables are left blank — the user provides their own colors. Do not attempt to invent, derive, or fill them.** Wait for the user to supply the palette before applying any color to the design.

```css
/* ============================================
   AESTHETIC FOUNDATIONS: GLOBAL CSS
   Colour variables are intentionally blank.
   Colors are owned by the user — wait for them.
   ============================================ */

:root {
  /* ── COLOURS: Provided by user — leave blank until supplied ── */
  --bg:         ; /* Primary background */
  --bg-alt:     ; /* Secondary background (sections, cards) */
  --text:       ; /* Primary text — must be 7:1+ contrast on --bg */
  --text-muted: ; /* Secondary text — must be 4.5:1+ contrast on --bg */
  --accent:     ; /* Brand accent — used in 20% of design or less */

  /* ── TYPOGRAPHY: Golden Ratio ── */
  --font-body:       clamp(1rem, 1.5vw, 1.125rem);
  --font-lead:       clamp(1.25rem, 1.875vw, 1.406rem);
  --font-subheading: clamp(1.625rem, 3vw, 2.25rem);
  --font-heading:    clamp(2.625rem, 5vw, 3.5rem);
  --font-display:    clamp(4.25rem, 8vw, 5.75rem);
  --font-hero:       clamp(6.854rem, 12vw, 9.5rem);
  --font-micro:      clamp(0.75rem, 1vw, 0.875rem);
  --font-small:      clamp(0.875rem, 1.25vw, 1rem);

  /* ── LINE HEIGHTS ── */
  --lh-body:       1.6;
  --lh-lead:       1.5;
  --lh-subheading: 1.35;
  --lh-heading:    1.2;
  --lh-display:    1.1;
  --lh-hero:       1.05;

  /* ── LETTER SPACING ── */
  --ls-normal: 0;
  --ls-tight:  -0.02em;
  --ls-wide:   0.02em;
  --ls-caps:   0.05em;

  /* ── FONT FAMILIES: Select based on brand — see Premium Font Recommendations ── */
  --font-serif: 'Editorial New', Georgia, serif;
  --font-sans:  'Söhne', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-mono:  'PP Neue Machina Mono', 'Courier New', monospace;

  /* ── DESCENDER SAFETY ── */
  --descender-clearance: 0.18em; /* Adjust per font — measure with canvas API */

  /* ── SPACING SCALE (8px base) ── */
  --sp-xs:  4px;
  --sp-sm:  8px;
  --sp-md:  12px;
  --sp-base: 16px;
  --sp-lg:  20px;
  --sp-xl:  24px;
  --sp-2xl: 32px;
  --sp-3xl: 40px;
  --sp-4xl: 48px;
  --sp-5xl: 60px;
  --sp-6xl: 80px;
  --sp-7xl: 120px;

  /* ── ANIMATION TIMING ── */
  --t-micro: 150ms;
  --t-fast:  200ms;
  --t-std:   300ms;
  --t-slow:  600ms;
  --t-macro: 1000ms;

  /* ── EASING ── */
  --ease-out:    cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-back:   cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* RESET */
*, *::before, *::after {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html {
  font-size: 16px;
}

body {
  font-family: var(--font-sans);
  font-size: var(--font-body);
  line-height: var(--lh-body);
  color: var(--text);
  background: var(--bg);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  overflow-x: hidden;
}

/* TYPOGRAPHY */
h1 {
  font-family: var(--font-serif);
  font-size: var(--font-hero);
  line-height: var(--lh-hero);
  font-weight: 600;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding-bottom */
  margin-bottom: var(--sp-base);
}

h2 {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 500;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible;
  margin-bottom: var(--sp-lg);
}

h3 {
  font-family: var(--font-sans);
  font-size: var(--font-heading);
  line-height: var(--lh-heading);
  font-weight: 600;
  padding-bottom: var(--descender-clearance);
  overflow: visible;
  margin-bottom: var(--sp-md);
}

h4 {
  font-family: var(--font-sans);
  font-size: var(--font-subheading);
  line-height: var(--lh-subheading);
  font-weight: 600;
  margin-bottom: var(--sp-md);
}

h5, h6 {
  font-family: var(--font-sans);
  font-size: var(--font-body);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: var(--ls-caps);
  margin-bottom: var(--sp-base);
}

p {
  margin-bottom: var(--sp-2xl);
}

p + p { margin-top: 0; }

.lead {
  font-size: var(--font-lead);
  line-height: var(--lh-lead);
  color: var(--text-muted);
}

.display {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 600;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible;
}

.micro {
  font-family: var(--font-sans);
  font-size: var(--font-micro);
  line-height: 1.4;
  text-transform: uppercase;
  letter-spacing: var(--ls-caps);
  color: var(--text-muted);
}

/* BUTTONS — base only, no colours: user supplies palette */
button, .btn {
  display: inline-flex;
  align-items: center;
  gap: var(--sp-sm);
  padding: var(--sp-sm) var(--sp-2xl);
  font-family: var(--font-sans);
  font-size: var(--font-body);
  font-weight: 600;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  text-decoration: none;
  transition: background var(--t-fast) var(--ease-out),
              transform var(--t-fast) var(--ease-out),
              opacity var(--t-fast) var(--ease-out);
  /* Background and colour: set from palette, not here */
}

button:hover, .btn:hover {
  transform: translateY(-2px);
}

button:active, .btn:active {
  transform: translateY(0);
  opacity: 0.9;
}

/* SECTIONS */
section {
  padding: var(--sp-7xl) var(--sp-6xl);
}

@media (max-width: 1024px) {
  section { padding: var(--sp-5xl) var(--sp-4xl); }
}

@media (max-width: 640px) {
  section { padding: var(--sp-4xl) var(--sp-3xl); }
}

/* RESPONSIVE TYPOGRAPHY */
@media (max-width: 768px) {
  h1 { font-size: var(--font-display); }
  h2 { font-size: var(--font-heading); }
}
```

---

## Using These Foundations

1. **Colors are user-owned.** Leave all color variables blank until the user provides them. Do not invent, derive, or fill them.
2. Select fonts from the **Premium Font Recommendations** above — match to brand voice
3. Verify contrast ratios at [contrast.tools](https://contrast.tools) once the user provides colors
4. Measure `--descender-clearance` for your chosen font using the canvas API (see `references/descender-safety.md`)
5. Test on 375px mobile before declaring the foundations done
