# Font Loading — Deep Dive

Web fonts are one of the most common sources of both LCP delay and CLS. A misconfigured font stack causes invisible text, layout shifts, and render-blocking requests. Get this right and your CLS score will thank you.

---

## The Font Loading Problem

Default font behavior: browser downloads font → renders text. This causes:
1. **Flash of Invisible Text (FOIT)** — Text invisible during font load (bad for LCP)
2. **Flash of Unstyled Text (FOUT)** — Fallback font visible, then swaps (causes CLS)
3. **Render blocking** — Browser can't render text until font is available (slow FCP)

---

## font-display

The `font-display` property controls how the browser handles text during font load.

```css
@font-face {
  font-family: 'MyFont';
  src: url('myfont.woff2') format('woff2');
  font-display: swap; /* Key setting */
}
```

| Value | Behavior | FOUT? | FOIT? | Best For |
|-------|---------|-------|-------|----------|
| `swap` | Fallback → swap in | Yes | No | Body text, headings |
| `optional` | Use fallback only | No | No | Body text (accepts FOUT) |
| `fallback` | Short wait → fallback | Yes | Brief | Body text |
| `block` | Block up to 3s → fallback | No | Yes | Never use (blocks rendering) |
| `auto` | Browser default | Varies | Varies | Never use explicitly |

**Recommendation: `font-display: swap` for everything.** Accept the brief FOUT. It's better than invisible text or blocking.

---

## Preloading Critical Fonts

```html
<head>
  <!-- Preload WOFF2 only — never preload WOFF or TTF -->
  <link
    rel="preload"
    href="/fonts/heading.woff2"
    as="font"
    type="font/woff2"
    crossorigin
  >
</head>
```

```css
@font-face {
  font-family: 'HeadingFont';
  src: url('/fonts/heading.woff2') format('woff2');
  font-weight: 700;
  font-display: swap;
}
```

### Critical Path Font Subsetting

Only preload what you need in the critical path. If you have 5 font weights but only load 2 for above-fold content, preload only those 2.

```html
<!-- Only preload the 2 weights needed above fold -->
<link rel="preload" href="/fonts/Inter-400.woff2" as="font" crossorigin>
<link rel="preload" href="/fonts/Inter-700.woff2" as="font" crossorigin>
```

### Preconnect to Font Origins

```html
<head>
  <!-- Preconnect — establish connection early -->
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link rel="preconnect" href="https://fonts.googleapis.com" crossorigin>

  <!-- Only if using Google Fonts (prefer self-hosting) -->
  <link rel="preload" href="..." as="font" crossorigin>
</head>
```

---

## Self-Hosting Fonts

**Self-hosting is always better than Google Fonts.** Why?
- Eliminates DNS lookup + connection to `fonts.googleapis.com` / `fonts.gstatic.com`
- One fewer render-blocking chain
- Full control over font files and subsetting
- No third-party tracking

### The Google Fonts Round-Trip Problem

```
User → Google Fonts CSS → Google Fonts WOFF2 → Render text
         ↑ 1 RTT          ↑ Another RTT
```

With self-hosting:
```
User → Your CDN → Render text
         ↑ 1 RTT
```

### Self-Hosting with Fontsource

```bash
bun add @fontsource/inter
```

```css
/* In your CSS entry point */
@import '@fontsource/inter/400.css';
@import '@fontsource/inter/700.css';

/* Or in your HTML */
<link rel="stylesheet" href="/node_modules/@fontsource/inter/400.css">
```

### Self-Hosting Manual

```bash
# Download WOFF2 from Google Fonts (via fontsource or google-webfonts-helper)
wget https://fonts.gstatic.com/s/inter/v18/UcCO3FwrK3iLTeHuS_nVMrMxCp50SjIw2boKoduKmMEVuLyfAZ9hjp-Ek-_EeA.woff2

# Place in /public/fonts/
```

```css
@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter-400.woff2') format('woff2');
  font-weight: 400;
  font-style: normal;
  font-display: swap;
}

@font-face {
  font-family: 'Inter';
  src: url('/fonts/inter-700.woff2') format('woff2');
  font-weight: 700;
  font-style: normal;
  font-display: swap;
}
```

---

## Font Subsetting

### What to Subset

| Scope | Character Count | Example |
|-------|----------------|---------|
| Latin only | ~100-200 chars | a-z, A-Z, 0-9, punctuation |
| Extended Latin | ~300-400 chars | Latin + accented characters |
| Full | 10,000+ chars | All Unicode glyphs |

### Subsetting with Glyphhanger

```bash
# Install glyphhanger
bunx glyphhanger --subset=fonts/MyFont.woff2 --whitelist=ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789\ .,\!\? --
```

### Subsetting with pyftsubset (Python)

```bash
# Install fonttools
pip install fonttools brotli zopfli

pyftsubset fonts/MyFont.woff2 \
  --unicodes="U+0020-007E" \
  --output-file=fonts/MyFont-subset.woff2
```

### Content-Aware Subsetting

Generate the character set from your actual content:

```bash
# Extract all unique characters from your HTML
cat dist/index.html | grep -o '[[:alnum:][:punct:][:space:]]' | sort -u | tr -d '\n'
```

---

## Variable Fonts

Variable fonts combine multiple weights, widths, and styles into a single file. One variable font replaces 4-10 static font files.

### Static vs Variable

```
Static: inter-300.woff2 + inter-400.woff2 + inter-700.woff2 + inter-900.woff2
        = 4 requests, ~200-400KB total

Variable: Inter-Variable.woff2
        = 1 request, ~100-200KB total
```

### Using Variable Fonts

```css
@font-face {
  font-family: 'InterVariable';
  src: url('/fonts/Inter-Variable.woff2') format('woff-variations');
  font-weight: 100 900; /* Full weight range */
  font-display: swap;
}

/* Use any weight */
h1 { font-weight: 800; }
.body { font-weight: 400; }
.caption { font-weight: 300; }
```

### Variable Font Axes

| Axis Tag | Name | Example |
|----------|------|---------|
| wght | Weight | 100–900 |
| wdth | Width | 75–125 |
| ital | Italic | 0–1 |
| slnt | Slant | -12–0 |
| opsz | Optical Size | 8–144 |

```css
/* Optical size — larger text gets slightly different metrics */
.body-text { font-variation-settings: 'opsz' 16; }
.heading { font-variation-settings: 'opsz' 48; }
```

---

## Font Metric Stability (CLS Prevention)

The #1 cause of CLS after images is **font swap causing layout shift**. When the fallback font metrics (x-height, cap height, character width) differ from the web font, text reflows when the web font loads.

### The Problem

```
Fallback font: "Times New Roman" → Renders at 16px
Web font: "Inter" → Renders at 16px

BUT: x-height differs, cap height differs, character widths differ
→ Text reflows → CLS spike
```

### size-adjust — Fix Glyph Metrics

```css
@font-face {
  font-family: 'Inter-fallback';
  src: local('Arial');
  font-display: swap;
  /* Adjust so fallback metrics match Inter */
  size-adjust: 103%;
  ascent-override: 95%;
  descent-override: 20%;
}
```

### Generating Override Values

Use [Fontaine](https://github.com/unjs/fontaine) (automated) or [next/font](https://nextjs.org/docs/app/building-your-application/optimizing/fonts):

```js
// Fontaine (for Vite/Node)
import { createFontMetricsFallback } from 'fontaine';

const { metrics, fallback } = createFontMetricsFallback(
  'Inter',
  '/fonts/Inter-Variable.woff2',
  { weight: '400' }
);

// Metrics are auto-calculated
```

### The Complete CLS-Prevention Font Stack

```css
@font-face {
  font-family: 'MyFont-fallback';
  src: local('Arial');
  font-display: swap;
  size-adjust: 104%;        /* Match x-height */
  ascent-override: 93%;     /* Match cap-height */
  descent-override: 23%;    /* Match baseline */
  line-gap-override: 0%;    /* Match leading */
}

/* Primary with fallback chain */
.primary-text {
  font-family: 'Inter', 'Inter-fallback', 'Arial', sans-serif;
}
```

---

## CSS Custom Properties for Font Loading

```css
:root {
  /* Define the font stack once */
  --font-sans: 'Inter', 'Inter-fallback', system-ui, sans-serif;
  --font-display: 'HeadingFont', 'Georgia', serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;

  /* Font metric adjustments (generated by Fontaine) */
  --font-sans-fallback-size-adjust: 103%;
  --font-sans-fallback-ascent: 93%;
  --font-sans-fallback-descent: 23%;
}

@font-face {
  font-family: 'Inter-fallback';
  src: local('Arial');
  font-display: swap;
  size-adjust: var(--font-sans-fallback-size-adjust);
  ascent-override: var(--font-sans-fallback-ascent);
  descent-override: var(--font-sans-fallback-descent);
}
```

---

## Font Loading Checklist

```plaintext
□ WOFF2 only (never WOFF, never TTF, never OTF)
□ font-display: swap on every @font-face
□ Preload critical font files (<link rel="preload">)
□ Preconnect to font origins (<link rel="preconnect">)
□ Self-host fonts (avoid Google Fonts round-trip)
□ Subset fonts to required character ranges
□ Use variable fonts to reduce request count
□ size-adjust + ascent-override + descent-override for metric stability
□ Local font fallback with matching metrics (Arial or system-ui)
□ CSS custom properties for font stack consistency
□ Only preload fonts needed above the fold
□ defer non-critical font weights with FontFace API
□ Use Fontsource for easy self-hosted Google Fonts
□ Set Cache-Control: immutable for versioned font files
```

---

## Font Loading API (Advanced)

```js
// Load fonts dynamically with FontFace API
async function loadFonts() {
  try {
    await document.fonts.load('400 16px Inter');
    await document.fonts.ready;
    console.log('Fonts loaded and ready');
  } catch (e) {
    console.warn('Font loading failed:', e);
  }
}

// CSS font loading with link preload
// This approach gives full control
const fontLink = document.createElement('link');
fontLink.rel = 'preload';
fontLink.as = 'font';
fontLink.href = '/fonts/Inter-400.woff2';
fontLink.type = 'font/woff2';
fontLink.crossOrigin = 'anonymous';
document.head.appendChild(fontLink);
```
