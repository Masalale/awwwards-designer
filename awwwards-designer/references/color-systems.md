# Color Systems Deep Dive

> "Color is a power which directly influences the soul." — Wassily Kandinsky

This reference covers color token architecture (3-layer system), light/dark mode implementation,
WCAG contrast requirements, OKLCH color spaces, and animation-friendly color systems.

---

## Token Architecture: 3-Layer System

A robust color system uses three distinct layers. Never skip layers or mix them.

```
┌─────────────────────────────────────────────────────┐
│  Layer 1: Primitives                                │
│  Raw values. NEVER use directly in components.      │
│  --primitive-gray-50: #f9fafb                       │
│  --primitive-blue-500: #3b82f6                      │
└──────────────────────┬──────────────────────────────┘
                       │ consumed by
┌──────────────────────▼──────────────────────────────┐
│  Layer 2: Semantics                                 │
│  Intent-based. USE THESE in all components.        │
│  --color-bg-primary: var(--primitive-gray-50)      │
│  --color-text-primary: var(--primitive-gray-900)  │
│  --color-accent: var(--primitive-blue-500)         │
└──────────────────────┬──────────────────────────────┘
                       │ consumed by
┌──────────────────────▼──────────────────────────────┐
│  Layer 3: Component-specific tokens                 │
│  Reference semantics. Optional convenience layer.   │
│  --color-button-bg: var(--color-accent)            │
│  --color-nav-text: var(--color-text-secondary)     │
└─────────────────────────────────────────────────────┘
```

### Why Three Layers?

1. **Primitives** — Enable systematic generation (e.g., generate all shades from one base)
2. **Semantics** — Allow theme switching (swap dark/light by changing one layer)
3. **Components** — Prevent token sprawl, ensure consistency across the codebase

### Primitive Palette Structure

```css
:root {
  /* Gray Scale — 50 (lightest) to 950 (darkest) */
  --primitive-gray-50: #f9fafb;
  --primitive-gray-100: #f3f4f6;
  --primitive-gray-200: #e5e7eb;
  --primitive-gray-300: #d1d5db;
  --primitive-gray-400: #9ca3af;
  --primitive-gray-500: #6b7280;
  --primitive-gray-600: #4b5563;
  --primitive-gray-700: #374151;
  --primitive-gray-800: #1f2937;
  --primitive-gray-900: #111827;
  --primitive-gray-950: #030712;

  /* Blue Accent Scale */
  --primitive-blue-50: #eff6ff;
  --primitive-blue-100: #dbeafe;
  --primitive-blue-200: #bfdbfe;
  --primitive-blue-300: #93c5fd;
  --primitive-blue-400: #60a5fa;
  --primitive-blue-500: #3b82f6;
  --primitive-blue-600: #2563eb;
  --primitive-blue-700: #1d4ed8;
  --primitive-blue-800: #1e40af;
  --primitive-blue-900: #1e3a8a;
  --primitive-blue-950: #172554;

  /* Accent colors (brand-specific) — example with violet */
  --primitive-violet-50: #f5f3ff;
  --primitive-violet-100: #ede9fe;
  --primitive-violet-200: #ddd6fe;
  --primitive-violet-300: #c4b5fd;
  --primitive-violet-400: #a78bfa;
  --primitive-violet-500: #8b5cf6;
  --primitive-violet-600: #7c3aed;
  --primitive-violet-700: #6d28d9;
  --primitive-violet-800: #5b21b6;
  --primitive-violet-900: #4c1d95;

  /* Success / Warning / Error */
  --primitive-green-500: #22c55e;
  --primitive-green-600: #16a34a;
  --primitive-red-500: #ef4444;
  --primitive-red-600: #dc2626;
  --primitive-amber-500: #f59e0b;
  --primitive-amber-600: #d97706;
}
```

### Semantic Token Layer

```css
:root {
  /* === BACKGROUND === */
  --color-bg-page:       var(--primitive-gray-50);
  --color-bg-surface:   var(--primitive-gray-100);
  --color-bg-elevated:  var(--primitive-gray-0);
  --color-bg-overlay:   var(--primitive-gray-900);
  --color-bg-inverse:   var(--primitive-gray-950);

  /* === TEXT === */
  --color-text-primary:   var(--primitive-gray-900);
  --color-text-secondary: var(--primitive-gray-600);
  --color-text-tertiary:  var(--primitive-gray-400);
  --color-text-inverse:   var(--primitive-gray-0);
  --color-text-disabled:  var(--primitive-gray-300);
  --color-text-link:      var(--primitive-blue-600);
  --color-text-link-hover: var(--primitive-blue-700);

  /* === BORDERS === */
  --color-border-default:  var(--primitive-gray-200);
  --color-border-strong:   var(--primitive-gray-300);
  --color-border-focus:    var(--primitive-blue-500);
  --color-border-inverse:  var(--primitive-gray-700);

  /* === ACCENT / BRAND === */
  --color-accent:           var(--primitive-blue-500);
  --color-accent-hover:      var(--primitive-blue-600);
  --color-accent-muted:      var(--primitive-blue-100);
  --color-accent-subtle:     var(--primitive-blue-50);

  /* === INTERACTIVE === */
  --color-interactive-primary: var(--primitive-blue-600);
  --color-interactive-hover:   var(--primitive-blue-700);
  --color-interactive-pressed: var(--primitive-blue-800);
  --color-interactive-focus-ring: var(--primitive-blue-500);

  /* === SEMANTIC === */
  --color-success:  var(--primitive-green-600);
  --color-success-bg: var(--primitive-green-500);
  --color-warning:  var(--primitive-amber-600);
  --color-error:    var(--primitive-red-600);
  --color-info:     var(--primitive-blue-600);
}
```

### Component Token Examples

```css
/* Buttons */
--button-primary-bg:       var(--color-accent);
--button-primary-bg-hover: var(--color-accent-hover);
--button-primary-text:    var(--color-text-inverse);
--button-secondary-border: var(--color-border-strong);

/* Cards */
--card-bg:         var(--color-bg-surface);
--card-border:     var(--color-border-default);
--card-shadow:     0 1px 3px rgba(0, 0, 0, 0.1);

/* Navigation */
--nav-bg:          var(--color-bg-elevated);
--nav-text:        var(--color-text-secondary);
--nav-text-active: var(--color-text-primary);
--nav-hover-bg:    var(--color-bg-surface);

/* Form inputs */
--input-bg:          var(--color-bg-elevated);
--input-border:      var(--color-border-default);
--input-border-focus: var(--color-border-focus);
--input-text:        var(--color-text-primary);
--input-placeholder: var(--color-text-tertiary);
```

---

## Light Mode Palette

### Light Mode Color Strategy

Light mode should feel crisp and spacious. Key principles:

1. **Background hierarchy** — Use 2–3 background shades (page, surface, elevated) for depth
2. **Text hierarchy** — 3 text levels (primary, secondary, tertiary) with clear contrast steps
3. **Avoid pure black** — `--primitive-gray-900` (#111827) reads softer than #000 on light backgrounds
4. **Subtle borders** — Borders should be visible but not harsh. `--primitive-gray-200` (#e5e7eb)

### Full Light Mode Palette

```css
:root,
:root[data-theme="light"] {
  /* Surfaces — layered depth */
  --color-bg-page:     #ffffff;
  --color-bg-surface:  #f9fafb;
  --color-bg-raised:   #ffffff;
  --color-bg-overlay:  #111827;
  --color-bg-sunken:   #f3f4f6;

  /* Text — three levels */
  --color-text-primary:   #111827;  /* 16.1:1 on white — AAA */
  --color-text-secondary: #4b5563;  /* 7.0:1 on white — AAA */
  --color-text-tertiary:  #9ca3af;  /* 3.0:1 on white — only for decorative/disabled */
  --color-text-inverse:   #ffffff;

  /* Accent — primary brand color */
  --color-accent:           #3b82f6;  /* 4.6:1 on white — AA */
  --color-accent-hover:     #2563eb;
  --color-accent-muted:     #dbeafe;
  --color-accent-subtle:    #eff6ff;

  /* Borders */
  --color-border-default:  #e5e7eb;
  --color-border-strong:    #d1d5db;
  --color-border-focus:     #3b82f6;

  /* Semantic */
  --color-success:  #16a34a;
  --color-warning:  #d97706;
  --color-error:    #dc2626;
  --color-info:     #2563eb;
}
```

---

## Dark Mode

### Dark Mode Considerations

1. **Don't just invert** — Dark mode is not a photo negative. Colors behave differently in dark environments.
2. **Reduce saturation** — Highly saturated colors are jarring in dark mode. Desaturate by 10–20%.
3. **Elevate surfaces** — Dark backgrounds use lighter grays for raised elements (opposite of light mode).
4. **Preserve accent vibrancy** — Brand accents can remain saturated; they're accent, not background.
5. **Test on actual dark theme** — sRGB on a bright phone in a dark room is very different from a dark room on a dim monitor.

### Full Dark Mode Palette

```css
@media (prefers-color-scheme: dark) {
  :root {
    /* Surfaces — lighter on top (inverted hierarchy from light mode) */
    --color-bg-page:     #0a0a0a;
    --color-bg-surface:  #111827;
    --color-bg-raised:   #1f2937;
    --color-bg-overlay:  #f9fafb;
    --color-bg-sunken:   #030712;

    /* Text — softer whites */
    --color-text-primary:   #f9fafb;  /* ~21:1 on #0a0a */
    --color-text-secondary: #9ca3af;  /* ~7:1 on #0a0a */
    --color-text-tertiary:  #6b7280;  /* ~4.5:1 on #0a0a */
    --color-text-inverse:   #111827;

    /* Accent — slightly desaturated but still vibrant */
    --color-accent:           #60a5fa;  /* ~5.2:1 on dark bg */
    --color-accent-hover:     #93c5fd;
    --color-accent-muted:     #1e3a8a;
    --color-accent-subtle:    #172554;

    /* Borders — lighter in dark mode for visibility */
    --color-border-default:  #374151;
    --color-border-strong:   #4b5563;
    --color-border-focus:     #60a5fa;

    /* Semantic — keep colors vivid enough to communicate meaning */
    --color-success:  #22c55e;
    --color-warning:  #f59e0b;
    --color-error:    #ef4444;
    --color-info:     #60a5fa;
  }
}
```

### Class-Based Dark Mode Toggle

```css
/* Default: light mode via CSS custom properties */
:root {
  --color-bg-page: #ffffff;
  --color-text-primary: #111827;
  /* ... */
}

/* Dark mode override */
[data-theme="dark"] {
  --color-bg-page: #0a0a0a;
  --color-text-primary: #f9fafb;
  /* ... */
}
```

```javascript
// Toggle function
function toggleTheme() {
  const html = document.documentElement;
  const current = html.getAttribute('data-theme');
  html.setAttribute('data-theme', current === 'dark' ? 'light' : 'dark');
}
```

---

## WCAG Contrast Reference Table

### Contrast Ratios for Common Color Combinations

| Foreground | Background | Ratio  | WCAG AA | WCAG AAA |
|------------|------------|--------|---------|----------|
| #111827 (gray-900) | #ffffff   | 16.1:1 | ✅ AA   | ✅ AAA   |
| #1f2937 (gray-800) | #ffffff   | 13.8:1 | ✅ AA   | ✅ AAA   |
| #374151 (gray-700) | #ffffff   | 9.0:1  | ✅ AA   | ✅ AAA   |
| #4b5563 (gray-600) | #ffffff   | 7.0:1  | ✅ AA   | ✅ AAA   |
| #6b7280 (gray-500) | #ffffff   | 4.5:1  | ✅ AA   | ❌       |
| #9ca3af (gray-400) | #ffffff   | 3.0:1  | ⚠️ Large| ❌       |
| #3b82f6 (blue-500) | #ffffff   | 3.0:1  | ⚠️ Large| ❌       |
| #2563eb (blue-600) | #ffffff   | 4.6:1  | ✅ AA   | ❌       |
| #1d4ed8 (blue-700) | #ffffff   | 5.9:1  | ✅ AA   | ❌       |
| #ffffff            | #111827   | 16.1:1 | ✅ AA   | ✅ AAA   |
| #ffffff            | #1f2937   | 13.8:1 | ✅ AA   | ✅ AAA   |
| #ffffff            | #2563eb   | 4.6:1  | ✅ AA   | ❌       |
| #ffffff            | #dc2626   | 4.6:1  | ✅ AA   | ❌       |
| #ffffff            | #16a34a   | 4.5:1  | ✅ AA   | ❌       |
| #d1d5db (gray-300) | #111827   | 7.2:1  | ✅ AA   | ✅ AAA   |
| #9ca3af (gray-400) | #111827   | 4.6:1  | ✅ AA   | ❌       |

### WCAG 2.1 Requirements Summary

| Level | Normal Text (< 18pt / < 14pt bold) | Large Text (≥ 18pt / ≥ 14pt bold) |
|-------|-------------------------------------|------------------------------------|
| AA    | 4.5:1 minimum                      | 3.0:1 minimum                      |
| AAA   | 7.0:1 minimum                      | 4.5:1 minimum                      |
| UI Components | 3.0:1 minimum (against adjacent color)              |

### Gray-500 Warning

`#6b7280` (gray-500) on `#ffffff` is **exactly 4.5:1** — the minimum AA threshold.
This is too risky for body text because:
- Browser rendering differences can reduce actual contrast
- Subpixel antialiasing affects perceived contrast
- It passes technically but fails practically

**Safe choice:** Use `#4b5563` (gray-600) or darker for body text. Reserve gray-500 for captions only.

---

## Color for Animation

### HSL: Hue, Saturation, Lightness

HSL is the most intuitive color space for animation. Adjust any axis independently.

```css
:root {
  --accent-hue: 220;
  --accent-sat: 70%;
  --accent-light: 50%;
  --accent: hsl(var(--accent-hue), var(--accent-sat), var(--accent-light));
}

/* Smooth color transitions */
.animated-accent {
  background: hsl(220, 70%, 50%);
  transition: background 0.3s ease;
}
.animated-accent:hover {
  background: hsl(220, 70%, 60%);
}
```

### OKLCH: perceptually uniform

OKLCH is the modern replacement for HSL. It's perceptually uniform, meaning
equal steps in lightness look equally different to the human eye.

```css
/* OKLCH syntax: oklch(L C H) */
/* L = Lightness (0–1, or 0%–100%) */
/* C = Chroma (color intensity, roughly 0–0.4) */
/* H = Hue (0–360 degrees) */

:root {
  --color-accent: oklch(55% 0.2 250);   /* Vibrant blue */
  --color-accent-hover: oklch(60% 0.22 250);
  --color-accent-muted: oklch(90% 0.05 250);
}

/* Smooth gradient with OKLCH — no muddy midpoints */
.gradient-hero {
  background: linear-gradient(
    135deg,
    oklch(55% 0.25 250) 0%,   /* Blue */
    oklch(65% 0.25 300) 50%,  /* Purple — no hue gap */
    oklch(60% 0.25 340) 100%  /* Pink */
  );
}
```

### OKLCH vs HSL for Gradients

HSL gradients create muddy midpoints because the hue channel isn't perceptually uniform:

```
HSL: hsl(220, 70%, 50%) → hsl(280, 70%, 60%)
Midpoint: hsl(250, 70%, 55%) — looks grayish/muddy

OKLCH: oklch(55% 0.2 250) → oklch(65% 0.2 280)
Midpoint: oklch(60% 0.2 265) — stays vibrant throughout
```

### Color Transitions for Hover States

```css
/* Button hover — smooth lift + color shift */
.button {
  background: oklch(50% 0.15 250);
  border: 1px solid oklch(60% 0.15 250);
  transition:
    background 0.2s ease,
    border-color 0.2s ease,
    transform 0.2s ease,
    box-shadow 0.2s ease;
}
.button:hover {
  background: oklch(55% 0.18 250);
  border-color: oklch(65% 0.18 250);
  transform: translateY(-1px);
  box-shadow: 0 4px 12px oklch(50% 0.2 250 / 0.3);
}
```

---

## CSS Custom Properties Implementation

### Dark Mode with CSS Custom Properties

```css
/* File: tokens/colors.css */

/* ============================================
   1. PRIMITIVE TOKENS (raw values)
   ============================================ */
:root {
  /* Grays */
  --primitive-white:  #ffffff;
  --primitive-gray-50: #f9fafb;
  --primitive-gray-100: #f3f4f6;
  --primitive-gray-200: #e5e7eb;
  --primitive-gray-300: #d1d5db;
  --primitive-gray-400: #9ca3af;
  --primitive-gray-500: #6b7280;
  --primitive-gray-600: #4b5563;
  --primitive-gray-700: #374151;
  --primitive-gray-800: #1f2937;
  --primitive-gray-900: #111827;
  --primitive-black:  #000000;

  /* Brand */
  --primitive-blue-50:  #eff6ff;
  --primitive-blue-500: #3b82f6;
  --primitive-blue-600: #2563eb;
  --primitive-blue-700: #1d4ed8;
}

/* ============================================
   2. SEMANTIC TOKENS (light mode default)
   ============================================ */
:root {
  --color-bg:           var(--primitive-white);
  --color-bg-subtle:    var(--primitive-gray-50);
  --color-text:         var(--primitive-gray-900);
  --color-text-muted:   var(--primitive-gray-600);
  --color-border:       var(--primitive-gray-200);
  --color-accent:       var(--primitive-blue-500);
  --color-accent-hover: var(--primitive-blue-600);
}

/* ============================================
   3. SEMANTIC TOKENS (dark mode)
   ============================================ */
@media (prefers-color-scheme: dark) {
  :root {
    --color-bg:           var(--primitive-gray-950);
    --color-bg-subtle:    var(--primitive-gray-900);
    --color-text:         var(--primitive-gray-50);
    --color-text-muted:   var(--primitive-gray-400);
    --color-border:       var(--primitive-gray-700);
    --color-accent:       var(--primitive-blue-400);
    --color-accent-hover: var(--primitive-blue-300);
  }
}

/* ============================================
   4. COMPONENT TOKENS (reference semantics)
   ============================================ */
:root {
  --button-bg:          var(--color-accent);
  --button-bg-hover:    var(--color-accent-hover);
  --button-text:        var(--primitive-white);
  --card-bg:            var(--color-bg-subtle);
  --card-border:        var(--color-border);
  --input-bg:           var(--color-bg);
  --input-border:       var(--color-border);
  --input-focus-ring:   var(--color-accent);
}
```

### Usage in Components

```css
/* Components ONLY reference semantic tokens */
.button {
  background: var(--button-bg);
  color: var(--button-text);
  border: 1px solid var(--button-border);
  border-radius: 0.375rem;
  padding: 0.5rem 1rem;
  font-weight: 500;
  cursor: pointer;
  transition: background 0.2s ease;
}

.button:hover {
  background: var(--button-bg-hover);
}

.button:focus-visible {
  outline: 2px solid var(--input-focus-ring);
  outline-offset: 2px;
}

.card {
  background: var(--card-bg);
  border: 1px solid var(--card-border);
  border-radius: 0.5rem;
  padding: 1.5rem;
}
```

---

## Color Accessibility

### Always Test These Combinations

For every color system, verify at minimum:

1. **Primary text on background** — `--color-text` on `--color-bg`
2. **Secondary text on background** — `--color-text-muted` on `--color-bg`
3. **Accent on background** — `--color-accent` on `--color-bg`
4. **Accent on white** — `--color-accent` on white (for buttons on light cards)
5. **Inverse text on accent** — white text on `--color-accent` (button text)
6. **All semantic colors** — success/warning/error on their backgrounds

### Contrast Tools

- **WebAIM Contrast Checker:** https://webaim.org/resources/contrastchecker/
- **Accessible Colors (generate palettes):** https://accessiblepalette.com/
- **Stark (Figma plugin):** Contrast checking directly in design files
- **axe DevTools:** Browser extension for automated accessibility testing

### Non-Text Color (Charts, Graphs, Status Indicators)

Non-text color must pass 3:1 against adjacent colors AND be supplemented with shape, pattern, or text:

```css
/* Bad: color alone conveys status */
.status-error { color: red; }
.status-success { color: green; }

/* Good: color + icon + text */
.status {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.25rem 0.5rem;
  border-radius: 9999px;
  font-size: 0.875rem;
  font-weight: 500;
}
.status-error {
  background: oklch(90% 0.15 25);
  color: oklch(45% 0.2 25);
}
.status-error svg { fill: currentColor; }
.status-success {
  background: oklch(90% 0.15 145);
  color: oklch(45% 0.2 145);
}
```

### Focus Indicator Colors

Focus rings must have sufficient contrast (3:1 against both the background and the element):

```css
/* Good: high contrast focus ring */
:focus-visible {
  outline: 2px solid var(--primitive-blue-500); /* 4.6:1 on white */
  outline-offset: 2px;
}

/* Bad: low contrast focus ring */
:focus-visible {
  outline: 1px solid var(--primitive-gray-300); /* 2.5:1 on white — fails */
}
```
