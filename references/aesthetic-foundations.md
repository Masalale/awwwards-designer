# Aesthetic Foundations: Design System & Premium Fundamentals

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

### Taste Principles

**Stroke weight follows size.** As icons get larger, reduce stroke width. As icons get smaller, increase it. This preserves optical weight consistency — the same visual "thickness" at all sizes.

**Icons as accents, not crutches.** A premium site uses icons sparingly. An arrow to indicate direction, a close mark on a modal, a menu icon on mobile. If you're using icons to explain what a button does, the button label isn't clear enough.

**Never emoji as interface icons.** Emoji rendering is inconsistent across OS and theme modes. A 🏠 on macOS and a 🏠 on Android are visually different objects. Lucide's house icon is identical everywhere.

**Custom icon gap.** If Lucide doesn't have a specific icon you need, draw a minimal inline SVG that matches Lucide's system: `stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`, no fill, viewBox `0 0 24 24`. This keeps the visual system intact rather than introducing a foreign object.

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

### Visual Line Height Testing

```
Body (1.6):       "The quick brown fox jumps over the lazy dog"
                   With generous spacing for comfortable reading.
                   Multiple paragraphs feel well-spaced.

Heading (1.2):    "The Quick Brown Fox"
                  Tighter, more controlled feeling.

Display (1.1):    "Extraordinary Design"
                 Very tight, premium, impactful.

Hero (1.05):      "Extraordinary Design Mastery"
               Extreme tightness, powerful, bold.
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

## 6 Luxury Color Palettes

Each palette includes primary, secondary, accent, and supporting colors. Copy these directly into your project.

### Palette 1: Midnight Opulence

**Vibe:** Dark luxury, mysterious, high-end technology

```css
:root {
  --color-midnight-bg: #0A0A0F;
  --color-midnight-text: #E8E4DC;
  --color-midnight-accent: #C4A882;
  --color-midnight-secondary: #6B4F2E;
  --color-midnight-success: #4CAF50;
  --color-midnight-warning: #FFC107;
  --color-midnight-error: #FF6B6B;
}

body.midnight {
  background: var(--color-midnight-bg);
  color: var(--color-midnight-text);
}

.accent.midnight {
  color: var(--color-midnight-accent);
}
```

**Usage:** Luxury tech, fintech, premium SaaS, jewelry brands

---

### Palette 2: Golden Hour Elite

**Vibe:** Warm, precious, timeless elegance

```css
:root {
  --color-golden-bg: #1A1209;
  --color-golden-text: #F5EDD6;
  --color-golden-accent: #D4A843;
  --color-golden-secondary: #8B6F47;
  --color-golden-tertiary: #C4985C;
  --color-golden-highlight: #FFF8E7;
}

body.golden {
  background: var(--color-golden-bg);
  color: var(--color-golden-text);
}

.hero.golden {
  background: linear-gradient(
    135deg,
    var(--color-golden-bg) 0%,
    #2A1F14 100%
  );
}
```

**Usage:** Luxury watches, premium wine, heritage brands, high-end fashion

---

### Palette 3: Emerald Sophistication

**Vibe:** Refined, natural, premium wellness

```css
:root {
  --color-emerald-bg: #0D1A14;
  --color-emerald-text: #E8F0EB;
  --color-emerald-accent: #4A8C6F;
  --color-emerald-primary: #2D5F49;
  --color-emerald-secondary: #5A9F7F;
  --color-emerald-light: #B8D4CC;
}

body.emerald {
  background: var(--color-emerald-bg);
  color: var(--color-emerald-text);
}

.cta.emerald {
  background: var(--color-emerald-primary);
  color: var(--color-emerald-text);
  border: 1px solid var(--color-emerald-accent);
}
```

**Usage:** Luxury wellness, sustainability, organic brands, environmental agencies

---

### Palette 4: Obsidian Chrome

**Vibe:** Cold precision, technical, cutting-edge

```css
:root {
  --color-obsidian-bg: #0F0F14;
  --color-obsidian-text: #E4E8F0;
  --color-obsidian-accent: #8BA3C4;
  --color-obsidian-primary: #3D5A7F;
  --color-obsidian-secondary: #5A7BA3;
  --color-obsidian-highlight: #A0C8FF;
}

body.obsidian {
  background: var(--color-obsidian-bg);
  color: var(--color-obsidian-text);
}

.button.obsidian {
  background: var(--color-obsidian-primary);
  border: 1px solid var(--color-obsidian-accent);
}
```

**Usage:** Tech companies, AI brands, software platforms, hardware brands

---

### Palette 5: Warm Concrete

**Vibe:** Grounded, industrial-luxury, architectural

```css
:root {
  --color-concrete-bg: #1C1814;
  --color-concrete-text: #F0EDE8;
  --color-concrete-accent: #C8B4A0;
  --color-concrete-primary: #7A6B5E;
  --color-concrete-secondary: #9A8B7E;
  --color-concrete-warm: #D4A89A;
}

body.concrete {
  background: var(--color-concrete-bg);
  color: var(--color-concrete-text);
}

.section.concrete {
  background: linear-gradient(
    to right,
    #1C1814,
    #2A2219
  );
}
```

**Usage:** Architecture firms, design studios, real estate, hospitality

---

### Palette 6: Arctic Minimal

**Vibe:** Clean, modern, Scandinavian-inspired

```css
:root {
  --color-arctic-bg: #1A1E2A;
  --color-arctic-text: #F5F7FA;
  --color-arctic-accent: #5B9AC8;
  --color-arctic-primary: #2E4A6B;
  --color-arctic-secondary: #7BA3C8;
  --color-arctic-tertiary: #A0B5CC;
}

body.arctic {
  background: var(--color-arctic-bg);
  color: var(--color-arctic-text);
}

.card.arctic {
  background: #252B38;
  border: 1px solid var(--color-arctic-tertiary);
}
```

**Usage:** SaaS products, productivity apps, Scandinavian brands, minimalist design

---

## Layout Principles: The Golden Grid

### Broken Grid (Mathematical Misalignment)

```css
/* Container with golden ratio columns */
.grid {
  display: grid;
  grid-template-columns: 1fr 1.618fr;  /* Golden ratio */
  gap: 60px;
  padding: 120px 80px;
}

/* Intentionally off-grid elements signal sophistication */
.feature-card {
  margin-left: -20%;    /* Intentional offset */
  transform: translateY(40px);  /* Vertical tension */
}

/* Asymmetric grid */
.portfolio-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 40px;
}

.portfolio-item:nth-child(2) {
  grid-column: span 1.5;  /* Breaks perfect symmetry */
  grid-row: span 2;
}
```

### Macro Whitespace (Section Padding)

```css
/* Generous section padding creates breathing room */
section {
  padding: 120px 80px;  /* Desktop */
}

@media (max-width: 1024px) {
  section {
    padding: 80px 60px;  /* Tablet */
  }
}

@media (max-width: 640px) {
  section {
    padding: 60px 40px;  /* Mobile */
  }
}

/* Never less than minimum padding */
:root {
  --section-padding-top: 120px;
  --section-padding-bottom: 120px;
  --section-padding-mobile: 60px;
}
```

### Container Width

```css
/* Optimal reading width for body text */
main {
  max-width: 1200px;
  margin: 0 auto;
  width: 100%;
  padding: 0 40px;
}

/* Narrow width for editorial content */
.article {
  max-width: 720px;
}

/* Full bleed for hero sections */
.hero {
  width: 100vw;
  margin-left: calc(-50vw + 50%);
}
```

---

## Component Spacing Scale

A consistent 8px-based scale for all spacing decisions.

```css
:root {
  /* Spacing scale (8px base) */
  --space-xs: 4px;      /* Micro padding */
  --space-sm: 8px;      /* Small padding */
  --space-md: 12px;     /* Medium padding */
  --space-base: 16px;   /* Standard */
  --space-lg: 20px;     /* Large */
  --space-xl: 24px;     /* Extra large */
  --space-2xl: 32px;    /* 2x extra */
  --space-3xl: 40px;    /* 3x extra */
  --space-4xl: 48px;    /* 4x extra */
  --space-5xl: 60px;    /* 5x extra */
  --space-6xl: 80px;    /* 6x extra */
  --space-7xl: 120px;   /* 7x extra */
}

/* Apply consistently */
.button {
  padding: var(--space-sm) var(--space-lg);  /* 8px 20px */
  border-radius: 4px;
  font-size: var(--font-body);
}

.card {
  padding: var(--space-2xl);                /* 32px all around */
  margin-bottom: var(--space-3xl);          /* 40px below */
}

.section {
  gap: var(--space-4xl);                    /* 48px between items */
  padding: var(--space-7xl) var(--space-6xl);  /* 120px vertical, 80px horizontal */
}
```

---

## Animation Timing Scale

Consistent timing creates cohesive motion language.

```css
:root {
  /* Timing scale (milliseconds) */
  --timing-micro: 150ms;      /* Hover feedback, micro-interactions */
  --timing-fast: 200ms;       /* Quick state changes */
  --timing-standard: 300ms;   /* Primary interaction timing */
  --timing-section: 600ms;    /* Section reveals, entrance animations */
  --timing-macro: 1000ms;     /* Page-level transitions */
  --timing-slow: 1200ms;      /* Cinematic reveals */

  /* Easing functions */
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-back: cubic-bezier(0.34, 1.56, 0.64, 1);
  --ease-elastic: cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

/* Apply to transitions and animations */
.interactive {
  transition: opacity var(--timing-standard) var(--ease-out),
              transform var(--timing-standard) var(--ease-out);
  /* Never use 'transition: all' — it causes layout thrashing */
}

.hero {
  animation: fadeInUp var(--timing-section) var(--ease-out);
}

@keyframes fadeInUp {
  0% {
    opacity: 0;
    transform: translateY(40px);
  }
  100% {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Timing Rules

- **Hover/focus feedback:** 150-200ms (immediate-feeling)
- **Button press:** 200-300ms (responsive)
- **Section reveals on scroll:** 400-800ms (noticeable but not slow)
- **Page transitions:** 300-600ms (smooth but fast)
- **Cinematic moments:** 1000-1500ms (let users appreciate)

---

## Quick Start: Copy-Paste Global CSS

This is production-ready CSS. Copy into your `global.css` or main stylesheet:

```css
/* ============================================
   AESTHETIC FOUNDATIONS: GLOBAL CSS
   Copy this entire file to your project
   ============================================ */

/* TYPOGRAPHY & SPACING VARIABLES */
:root {
  /* Golden Ratio Typography */
  --font-body: clamp(1rem, 1.5vw, 1.125rem);
  --font-lead: clamp(1.25rem, 1.875vw, 1.406rem);
  --font-subheading: clamp(1.625rem, 3vw, 2.25rem);
  --font-heading: clamp(2.625rem, 5vw, 3.5rem);
  --font-display: clamp(4.25rem, 8vw, 5.75rem);
  --font-hero: clamp(6.854rem, 12vw, 9.5rem);

  /* Line Heights */
  --lh-body: 1.6;
  --lh-subheading: 1.35;
  --lh-heading: 1.2;
  --lh-display: 1.1;
  --lh-hero: 1.05;

  /* Letter Spacing */
  --ls-normal: 0;
  --ls-tight: -0.02em;
  --ls-caps: 0.05em;

  /* Font Families (change to your selected fonts) */
  --font-serif: 'Editorial New', Georgia, serif;
  --font-sans: 'Söhne', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
  --font-mono: 'PP Neue Machina Mono', 'Courier New', monospace;

  /* Descender Safety */
  --descender-clearance: 0.18em;

  /* Colors (Midnight Opulence palette) */
  --color-bg: #0A0A0F;
  --color-text: #E8E4DC;
  --color-accent: #C4A882;
  --color-secondary: #6B4F2E;

  /* Spacing Scale (8px base) */
  --space-xs: 4px;
  --space-sm: 8px;
  --space-md: 12px;
  --space-base: 16px;
  --space-lg: 20px;
  --space-xl: 24px;
  --space-2xl: 32px;
  --space-3xl: 40px;
  --space-4xl: 48px;
  --space-5xl: 60px;
  --space-6xl: 80px;
  --space-7xl: 120px;

  /* Animation Timing */
  --timing-micro: 150ms;
  --timing-fast: 200ms;
  --timing-standard: 300ms;
  --timing-section: 600ms;
  --timing-macro: 1000ms;

  /* Easing */
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-back: cubic-bezier(0.34, 1.56, 0.64, 1);
}

/* RESET & BASE STYLES */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

html {
  font-size: 16px;
  scroll-behavior: smooth;
}

body {
  font-family: var(--font-sans);
  font-size: var(--font-body);
  line-height: var(--lh-body);
  color: var(--color-text);
  background: var(--color-bg);
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

/* TYPOGRAPHY */
h1 {
  font-family: var(--font-serif);
  font-size: var(--font-hero);
  line-height: var(--lh-hero);
  font-weight: 600;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
  margin-bottom: var(--space-base);
}

h2 {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 500;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
  margin-bottom: var(--space-lg);
}

h3 {
  font-family: var(--font-sans);
  font-size: var(--font-heading);
  line-height: var(--lh-heading);
  font-weight: 600;
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
  margin-bottom: var(--space-md);
}

h4 {
  font-family: var(--font-sans);
  font-size: var(--font-subheading);
  line-height: var(--lh-subheading);
  font-weight: 600;
  margin-bottom: var(--space-md);
}

h5, h6 {
  font-family: var(--font-sans);
  font-size: var(--font-body);
  line-height: var(--lh-body);
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: var(--ls-caps);
  margin-bottom: var(--space-base);
}

p {
  margin-bottom: var(--space-2xl);
}

p + p {
  margin-top: 0;
}

.lead {
  font-size: var(--font-lead);
  line-height: 1.5;
  color: var(--color-secondary);
}

.display {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 600;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
}

/* LINKS */
a {
  color: var(--color-accent);
  text-decoration: none;
  transition: opacity var(--timing-fast) var(--ease-out);
}

a:hover {
  opacity: 0.8;
}

a:active {
  opacity: 0.6;
}

/* LISTS */
ul, ol {
  margin-left: var(--space-3xl);
  margin-bottom: var(--space-2xl);
}

li {
  margin-bottom: var(--space-base);
}

/* CODE */
code {
  font-family: var(--font-mono);
  font-size: 0.9em;
  background: var(--color-secondary);
  padding: var(--space-xs) var(--space-sm);
  border-radius: 4px;
}

pre {
  font-family: var(--font-mono);
  background: var(--color-secondary);
  padding: var(--space-2xl);
  overflow-x: auto;
  border-radius: 8px;
  margin-bottom: var(--space-3xl);
}

/* BUTTONS */
button, .button {
  display: inline-flex;
  align-items: center;
  gap: var(--space-sm);
  padding: var(--space-sm) var(--space-2xl);
  font-family: var(--font-sans);
  font-size: var(--font-body);
  font-weight: 600;
  color: var(--color-bg);
  background: var(--color-accent);
  border: none;
  border-radius: 4px;
  cursor: pointer;
  transition: background var(--timing-fast) var(--ease-out),
              transform var(--timing-fast) var(--ease-out),
              opacity var(--timing-fast) var(--ease-out);
  /* Never use 'transition: all' — it causes layout thrashing */
}

button:hover, .button:hover {
  background: var(--color-secondary);
  transform: translateY(-2px);
}

button:active, .button:active {
  transform: translateY(0);
  opacity: 0.9;
}

/* SECTIONS */
section {
  padding: var(--space-7xl) var(--space-6xl);
}

@media (max-width: 1024px) {
  section {
    padding: var(--space-5xl) var(--space-4xl);
  }
}

@media (max-width: 640px) {
  section {
    padding: var(--space-4xl) var(--space-3xl);
  }
}

/* RESPONSIVE */
@media (max-width: 768px) {
  h1 {
    font-size: var(--font-display);
  }

  h2 {
    font-size: var(--font-heading);
  }
}
```

---

## Using These Foundations

1. **Copy the global CSS** into your main stylesheet
2. **Customize the color palette** to match your brand
3. **Select your fonts** and update `--font-serif`, `--font-sans`, `--font-mono`
4. **Update `--descender-clearance`** based on your font (measure with canvas API)
5. **Test on all devices** and adjust spacing/sizing as needed

These foundations are battle-tested and production-ready. They form the basis for every Awwwards-winning design.
