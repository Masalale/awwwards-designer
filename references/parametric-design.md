# Parametric Design Foundations

The mathematical backbone of Hadnoir DNA V4.

## The Golden Ratio (Φ = 1.618)

Use Φ for all spatial relationships:
- **Spacing scale:** xs=0.382rem, sm=0.618rem, base=1rem, md=1.618rem, lg=2.618rem, xl=4.236rem
- **Typography scale:** 1rem × Φ^n (1, 1.618, 2.618, 4.236, 6.854)
- **Container widths:** 100%/Φ, 100%/Φ² for sidebar layouts
- **Grid gaps:** Always multiples of 0.618rem

## Color Mathematics

### HSL Parametric Palette Generation

```typescript
// Base parameters
const baseHue = 220;        // Primary brand hue
const harmony = 'analogous'; // 'complementary' | 'triadic' | 'split'
const saturation = 0.65;    // 0-1, brand vibrancy
const lightnessRange = 0.4; // How much contrast between light/dark

// Generated palette
const palette = {
  primary:   `hsl(${baseHue}, ${saturation * 100}%, 50%)`,
  secondary: `hsl(${(baseHue + 30) % 360}, ${saturation * 100}%, 55%)`,
  accent:    `hsl(${(baseHue + 180) % 360}, ${saturation * 120}%, 60%)`,
  background:`hsl(${baseHue}, ${saturation * 20}%, ${100 - lightnessRange * 50}%)`,
  surface:   `hsl(${baseHue}, ${saturation * 15}%, ${100 - lightnessRange * 30}%)`,
  muted:     `hsl(${baseHue}, ${saturation * 10}%, 50%)`,
};
```

### Texture Generation

Use noise overlays for depth:
```css
--noise: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");

.texture-grain::before {
  content: '';
  position: absolute;
  inset: 0;
  background: var(--noise);
  opacity: 0.03;
  pointer-events: none;
}
```

## Rhythm & Spacing System

### The Hadnoir Spacing Scale

| Token | Value | Use Case |
|-------|-------|----------|
| `space-xs` | 0.382rem | Tight gaps, icon padding |
| `space-sm` | 0.618rem | Component internal padding |
| `space-base` | 1rem | Default spacing unit |
| `space-md` | 1.618rem | Section internal padding |
| `space-lg` | 2.618rem | Between related sections |
| `space-xl` | 4.236rem | Between major sections |
| `space-2xl` | 6.854rem | Page-level spacing |
| `space-3xl` | 11.09rem | Hero/proeminent separations |

### Asymmetric Grid

Use uneven divisions for visual interest:
```css
.asymmetric-grid {
  display: grid;
  grid-template-columns: 1fr 1.618fr; /* Φ ratio */
  gap: var(--space-lg);
}

.broken-grid {
  display: grid;
  grid-template-columns: 2fr 1fr 1.5fr;
  gap: var(--space-md);
}
```

## Typography Mathematics

### Fluid Type Scale

```css
/* Clamp approach for fluid typography */
--text-xs: clamp(0.64rem, 0.05vw + 0.63rem, 0.68rem);
--text-sm: clamp(0.8rem, 0.17vw + 0.76rem, 0.94rem);
--text-base: clamp(1rem, 0.34vw + 0.91rem, 1.25rem);
--text-lg: clamp(1.25rem, 0.61vw + 1.1rem, 1.67rem);
--text-xl: clamp(1.56rem, 1vw + 1.31rem, 2.22rem);
--text-2xl: clamp(1.95rem, 1.56vw + 1.56rem, 2.96rem);
--text-3xl: clamp(2.44rem, 2.38vw + 1.85rem, 3.95rem);
--text-4xl: clamp(3.05rem, 3.54vw + 2.17rem, 5.26rem);
```

### Line Height Ratios

- **Display text (headlines):** 0.85-0.95 (tight, impactful)
- **Body text:** 1.5-1.75 (readable)
- **Captions/micro:** 1.2-1.4 (compact)

## Motion Physics

### Easing Functions

| Name | Curve | Use Case |
|------|-------|----------|
| `expo-out` | `cubic-bezier(0.16, 1, 0.3, 1)` | Entrances, reveals |
| `expo-in` | `cubic-bezier(0.7, 0, 0.84, 0)` | Exits, dismissals |
| `elastic` | `cubic-bezier(0.68, -0.55, 0.265, 1.55)` | Playful bounces |
| `smooth` | `cubic-bezier(0.4, 0, 0.2, 1)` | General transitions |
| `dramatic` | `cubic-bezier(0.87, 0, 0.13, 1)` | Hero moments |

### Duration Scale

| Duration | Use Case |
|----------|----------|
| 100-150ms | Micro-interactions (hover, focus) |
| 200-300ms | UI transitions (modal, drawer) |
| 400-600ms | Page elements (entrances) |
| 800-1200ms | Hero reveals, major moments |
| 1200ms+ | Cinematic sequences |

### Stagger Patterns

```typescript
// Fibonacci stagger for natural feel
const staggerDelays = [0, 100, 100, 200, 300, 500, 800]; // ms

// Equal stagger for uniform feel
const equalStagger = (index: number, base: number = 50) => index * base;

// Decelerating stagger (fast start, slow end)
const decelStagger = (index: number) => Math.sqrt(index) * 100;
```

## Responsive Breakpoints

Use fluid breakpoints based on content, not devices:

```css
/* Named breakpoints */
--breakpoint-xs: 20rem;   /* 320px - minimal phones */
--breakpoint-sm: 30rem;   /* 480px - large phones */
--breakpoint-md: 48rem;   /* 768px - tablets */
--breakpoint-lg: 64rem;   /* 1024px - laptops */
--breakpoint-xl: 90rem;   /* 1440px - desktops */
--breakpoint-2xl: 120rem; /* 1920px - large screens */
```

## Z-Index Scale

```css
--z-base: 0;
--z-dropdown: 10;
--z-sticky: 20;
--z-fixed: 30;
--z-modal-backdrop: 40;
--z-modal: 50;
--z-popover: 60;
--z-tooltip: 70;
--z-toast: 80;
--z-max: 100;
```
