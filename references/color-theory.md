# Color Theory

Intentional color systems that communicate brand personality.

---

## Color Psychology Quick Reference

| Hue | Associations | Best For |
|-----|-------------|----------|
| **Red** | Energy, urgency, passion | CTAs, alerts, food, entertainment |
| **Orange** | Friendly, creative, affordable | Brands wanting approachability |
| **Yellow** | Optimism, clarity, warmth | Creative industries, warnings |
| **Green** | Growth, health, stability | Finance, sustainability, wellness |
| **Blue** | Trust, professionalism, calm | Tech, finance, healthcare |
| **Purple** | Luxury, creativity, mystery | Beauty, premium brands, crypto |
| **Pink** | Playful, modern, feminine | Beauty, lifestyle, youth brands |
| **Brown** | Earthy, reliable, vintage | Food, outdoors, craftsmanship |
| **Black** | Sophistication, luxury, power | Premium brands, fashion |
| **White** | Clean, minimal, pure | Healthcare, tech, luxury |

---

## Parametric Palette Generation

### The Hadnoir Method

```typescript
interface PaletteParams {
  baseHue: number;        // 0-360, primary brand color
  harmony: 'analogous' | 'complementary' | 'triadic' | 'split' | 'monochromatic';
  saturation: number;     // 0-1, vibrancy
  lightnessRange: number; // 0-1, contrast amount
  warmth: number;         // -1 to 1, cool vs warm shift
}

function generatePalette(params: PaletteParams) {
  const { baseHue, harmony, saturation, lightnessRange } = params;
  
  // Calculate harmony hues
  const hues = {
    analogous: [baseHue, (baseHue + 30) % 360, (baseHue - 30 + 360) % 360],
    complementary: [baseHue, (baseHue + 180) % 360],
    triadic: [baseHue, (baseHue + 120) % 360, (baseHue + 240) % 360],
    split: [baseHue, (baseHue + 150) % 360, (baseHue + 210) % 360],
    monochromatic: [baseHue]
  };
  
  const paletteHues = hues[harmony];
  
  return {
    primary:   `hsl(${paletteHues[0]}, ${saturation * 100}%, 50%)`,
    secondary: `hsl(${paletteHues[1] || paletteHues[0]}, ${saturation * 80}%, 55%)`,
    accent:    `hsl(${paletteHues[2] || (paletteHues[0] + 180) % 360}, ${saturation * 100}%, 60%)`,
    background:`hsl(${baseHue}, ${saturation * 10}%, ${100 - lightnessRange * 50}%)`,
    surface:   `hsl(${baseHue}, ${saturation * 8}%,  ${100 - lightnessRange * 35}%)`,
    muted:     `hsl(${baseHue}, ${saturation * 15}%, 45%)`,
    text:      lightnessRange > 0.5 ? '#0a0a0a' : '#fafafa',
    'text-muted': lightnessRange > 0.5 ? '#525252' : '#a3a3a3'
  };
}
```

### Usage Examples

```typescript
// Luxury brand (deep, rich)
const luxury = generatePalette({
  baseHue: 260,        // Deep purple
  harmony: 'analogous',
  saturation: 0.4,     // Muted, sophisticated
  lightnessRange: 0.7  // Dark overall
});

// Tech startup (bright, energetic)
const tech = generatePalette({
  baseHue: 210,        // Blue
  harmony: 'complementary',
  saturation: 0.8,
  lightnessRange: 0.3  // Light overall
});

// Wellness brand (natural, calm)
const wellness = generatePalette({
  baseHue: 160,        // Seafoam green
  harmony: 'analogous',
  saturation: 0.3,
  lightnessRange: 0.2
});
```

---

## CSS Variable Architecture

```css
:root {
  /* Core semantic colors */
  --color-primary: hsl(220, 65%, 50%);
  --color-secondary: hsl(250, 60%, 55%);
  --color-accent: hsl(40, 90%, 60%);
  
  /* Surface colors */
  --color-background: hsl(220, 20%, 95%);
  --color-surface: hsl(220, 15%, 100%);
  --color-surface-elevated: hsl(220, 15%, 100%);
  
  /* Text colors */
  --color-text: hsl(220, 30%, 10%);
  --color-text-muted: hsl(220, 20%, 45%);
  --color-text-inverted: hsl(220, 20%, 95%);
  
  /* State colors */
  --color-success: hsl(150, 60%, 45%);
  --color-warning: hsl(40, 90%, 55%);
  --color-error: hsl(0, 70%, 55%);
  --color-info: hsl(210, 70%, 55%);
  
  /* Interactive states */
  --color-hover: hsl(220, 65%, 45%);
  --color-active: hsl(220, 65%, 40%);
  --color-focus: hsl(220, 65%, 50%, 0.3);
  
  /* Borders */
  --color-border: hsl(220, 20%, 85%);
  --color-border-subtle: hsl(220, 20%, 90%);
}

/* Dark mode */
[data-theme="dark"] {
  --color-background: hsl(220, 30%, 8%);
  --color-surface: hsl(220, 25%, 12%);
  --color-surface-elevated: hsl(220, 25%, 15%);
  --color-text: hsl(220, 20%, 95%);
  --color-text-muted: hsl(220, 15%, 60%);
  --color-border: hsl(220, 20%, 20%);
  --color-border-subtle: hsl(220, 20%, 15%);
}
```

---

## Texture & Depth

### Grain Overlays

```css
/* Subtle film grain */
.texture-grain::before {
  content: '';
  position: fixed;
  inset: 0;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.8' numOctaves='4' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
  opacity: 0.03;
  pointer-events: none;
  z-index: 9999;
}

/* Noise background */
.bg-noise {
  background: 
    linear-gradient(to bottom, var(--color-background), var(--color-surface)),
    url("data:image/svg+xml,...");
  background-blend-mode: overlay;
}
```

### Mesh Gradients

```css
/* Aurora-like gradient */
.mesh-gradient {
  background: 
    radial-gradient(at 40% 20%, hsla(280,80%,70%,0.3) 0px, transparent 50%),
    radial-gradient(at 80% 0%, hsla(200,80%,60%,0.3) 0px, transparent 50%),
    radial-gradient(at 0% 50%, hsla(340,80%,70%,0.3) 0px, transparent 50%),
    radial-gradient(at 80% 50%, hsla(160,80%,60%,0.3) 0px, transparent 50%),
    radial-gradient(at 0% 100%, hsla(260,80%,70%,0.3) 0px, transparent 50%);
  background-color: var(--color-background);
}
```

### Glass Morphism

```css
.glass {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

/* Dark mode adjustment */
[data-theme="dark"] .glass {
  background: rgba(0, 0, 0, 0.3);
  border-color: rgba(255, 255, 255, 0.1);
}
```

---

## Contrast & Accessibility

### WCAG Requirements

| Level | Normal Text | Large Text | UI Components |
|-------|-------------|------------|---------------|
| AA | 4.5:1 | 3:1 | 3:1 |
| AAA | 7:1 | 4.5:1 | 3:1 |

### Quick Contrast Check

```css
/* High contrast (safe) */
--text-on-light: #0a0a0a;  /* On white: 19:1 */
--text-on-dark: #fafafa;   /* On black: 19:1 */

/* Medium contrast (check carefully) */
--text-muted-light: #525252; /* On white: 7:1 */
--text-muted-dark: #a3a3a3;  /* On black: 8:1 */
```

### Never Use

| Combination | Contrast | Issue |
|-------------|----------|-------|
| Gray-400 on white | 3:1 | Fails AA for normal text |
| Yellow on white | 1.1:1 | Invisible |
| Red on blue | ~2:1 | Hard to read, colorblind issues |
| Light gray on slightly lighter gray | ~1.5:1 | Completely invisible |

---

## Color System by Industry

### SaaS / Tech
```css
/* Trust, clarity, focus */
--hue-primary: 210;
--saturation: 0.7;
--accent: 180; /* Teal for actions */
```

### Finance / Banking
```css
/* Trust, stability, growth */
--hue-primary: 210;
--saturation: 0.6;
--accent: 150; /* Green for positive */
```

### Healthcare
```css
/* Clean, calm, professional */
--hue-primary: 190;
--saturation: 0.5;
--accent: 160; /* Calming green/teal */
```

### Fashion / Luxury
```css
/* Sophistication, exclusivity */
--hue-primary: 0;    /* Black/white base */
--saturation: 0;
--accent: 30;        /* Gold or specific brand */
```

### Food / Restaurant
```css
/* Appetite, warmth, comfort */
--hue-primary: 25;
--saturation: 0.8;
--accent: 45; /* Warm gold/yellow */
```

### Entertainment / Gaming
```css
/* Energy, excitement */
--hue-primary: 280; /* Purple */
--saturation: 0.8;
--accent: 320; /* Magenta */
```

---

## The "Anti-AI-Slop" Palette Rules

### Forbidden
- Purple-to-pink gradients on white backgrounds
- #3B82F6 (Tailwind blue) as primary
- Pure black (#000) and pure white (#fff) as the only colors
- Random bright accent with no connection to primary

### Required
- Slightly off-black for text (#0a0a0a instead of #000)
- Slightly off-white for backgrounds (#fafafa instead of #fff)
- At least one subtle texture or depth element
- Intentional color harmony (not random)
