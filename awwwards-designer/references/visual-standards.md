# Visual Standards

> **DESIGN.md is the authority.** After Phase 3, `extract_design_context` produces a DESIGN.md containing fonts, color tokens, spacing, and component rules. That file overrides everything here. Use these standards only when writing the Stitch brief (Phase 2) or when DESIGN.md has a gap.

---

## Typography

### Distinctive Over Safe
Guide toward: **Syne**, **Space Grotesk**, **Fraunces**, **Clash Display**, **Bebas Neue**, **Plus Jakarta Sans**, **Outfit**, **Archivo**. Avoid Inter, Roboto, Open Sans.

Variable fonts preferred for animation-friendly weight interpolation.

### Fluid Type Scale with `clamp()`

```css
--font-size-display: clamp(2.5rem, 7vw + 1rem, 7rem);
--font-size-h1:       clamp(2rem, 3vw + 1rem, 4rem);
--font-size-h2:       clamp(1.5rem, 2vw + 0.75rem, 3rem);
--font-size-body:     clamp(1rem, 0.25vw + 0.875rem, 1.125rem);
```

### Descender Safety
`overflow: visible` + `padding-bottom: 0.18em` minimum on text ≥ 48px. Measure per font via Canvas API.

---

## Color: 3-Layer Token Architecture

```
Primitive → Semantic → Component
Raw hex   → Intent   → Reference
```

Never use primitives directly in components. Always reference semantic tokens.

```css
/* Layer 1: Primitives — never use directly */
--primitive-gray-50:  #f9fafb;
--primitive-blue-500: #3b82f6;

/* Layer 2: Semantics — USE THESE */
--color-bg-primary:     var(--primitive-gray-50);
--color-text-primary:   var(--primitive-gray-900);
--color-accent:        var(--primitive-blue-500);

/* Layer 3: Components */
.button-primary {
  background: var(--color-accent);
}
```

### WCAG Contrast
- Body text ≥ 4.5:1 (Gray-600 #4b5563 or darker on white)
- Large text ≥ 3:1
- Never below these thresholds

---

## Layout & Spacing

### Spacing Scale (4px/8px)
```css
--space-1: 0.25rem;  --space-2: 0.5rem;  --space-4: 1rem;
--space-6: 1.5rem;   --space-8: 2rem;    --space-12: 3rem;
--space-16: 4rem;    --space-24: 6rem;   --space-32: 8rem;
```

### Container
- `max-width: 1024px`, `margin-inline: auto`, `padding-inline: var(--space-6)`

### 100dvh NOT 100vh (Hard Stop)
```css
.fullscreen { height: 100dvh; }   /* ✅ Correct */
.fullscreen { height: 100vh; }    /* ❌ Mobile overflow */
```

### Asymmetric Layouts
Don't center everything. Intentional asymmetry creates visual interest.

---

## Icons

- **Lucide only** — No Heroicons, Font Awesome, or custom SVGs unless brand-specific
- **Stroke width: always 1.5px**
- **Size scale**: 16 / 20 / 24 / 32px
- **Use `currentColor`** for dark mode compatibility

---

## See Also

- `references/typography.md` — Font pairing, type scale math, descender measurement
- `references/color-systems.md` — 3-layer tokens, dark mode, OKLCH
- `references/responsive-design.md` — Breakpoints, container queries, touch targets
- `references/accessibility.md` — WCAG 2.1 AA, focus, ARIA, reduced motion
