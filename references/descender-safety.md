# Descender Safety Protocol

# Descender Safety Protocol

## The Canvas Measurement Technique

Don't estimate descender depth. Measure it.

```javascript
/**
 * Measure the actual descender depth for a font at a given size.
 * Returns pixels of descent below the baseline.
 */
function measureDescender(fontFamily, fontSize, text = 'gy') {
  const canvas = document.createElement('canvas');
  canvas.width = 500;
  canvas.height = 200;

  const ctx = canvas.getContext('2d');
  ctx.fillStyle = '#000';
  ctx.font = `${fontSize}px ${fontFamily}`;

  // TextMetrics object contains actual bounding box
  const metrics = ctx.measureText(text);

  // actualBoundingBoxDescent = pixels below baseline
  const descent = metrics.actualBoundingBoxDescent;

  console.log(`${fontFamily} @ ${fontSize}px descender: ${descent}px`);

  return descent;
}

// Usage:
measureDescender('pp-neue-machina', 100);    // Returns ~18px
measureDescender('druk', 100);                // Returns ~10px
measureDescender('editorial-new', 100);       // Returns ~20px
measureDescender('freight-display', 100);     // Returns ~22px
```

**How to use this:**
1. Run this function in the browser console on your live site
2. Pass the actual font family, size, and text you're using
3. The return value is the real pixel depth of the descender
4. Add 20% padding buffer: if descender is 18px, use 22px clearance

---

## The --descender-clearance CSS System

Create a global CSS custom property system for descender clearance. Measure each font family once, then reuse the values everywhere.

```css
:root {
  /* ===========================
     Font-specific descender clearance values
     Measured via canvas API, includes 20% safety buffer
     =========================== */

  /* Serif/Editorial fonts (larger descenders) */
  --descender-editorial-new: 0.20em;
  --descender-freight-display: 0.22em;
  --descender-canela: 0.18em;

  /* Premium sans (medium descenders) */
  --descender-pp-neue-machina: 0.18em;
  --descender-druk: 0.10em;
  --descender-sohne: 0.12em;
  --descender-aktiv-grotesk: 0.14em;

  /* Tech/monospace (conservative) */
  --descender-pp-sans-mono: 0.15em;
  --descender-ibm-plex-mono: 0.16em;

  /* Fallback for unmeasured fonts */
  --descender-fallback: 0.15em;

  /* Active font clearance — set this per project */
  --descender-clearance: var(--descender-editorial-new);
}

/* ===========================
   Apply clearance to all display text
   =========================== */

/* Headings — overflow:visible lets descenders render into padding freely */
h1, h2, h3, h4, h5, h6 {
  padding-bottom: var(--descender-clearance);
  overflow: visible;   /* NOT clip — clip ignores padding and cuts glyphs */
}

/* Display classes */
[class*="display"],
[class*="hero"],
[class*="headline"],
[class*="title"] {
  padding-bottom: var(--descender-clearance);
  overflow: visible;
}

/* Larger body text (>48px) */
p[class*="lead"],
p[class*="lg"],
p[class*="xl"] {
  padding-bottom: var(--descender-clearance);
  overflow: visible;
}

/* Typography animation wrappers */
.split-text-line,
[class*="split"],
[class*="animate-text"] {
  padding-bottom: var(--descender-clearance);
  overflow: visible;
}
```

**Critical: `overflow: clip` vs `overflow: hidden` vs `overflow: visible`:**
- `overflow: clip` **does NOT respect `padding-bottom`** — it clips at the content box edge, making your padding useless. Despite being lighter weight, it will still cut descenders.
- `overflow: hidden` respects padding but creates a new block formatting context (affects margin collapse)
- `overflow: visible` — **the correct choice for text elements** — lets descenders breathe completely. Use `padding-bottom` to reserve space from the layout perspective, and let the glyph render into that padding freely.

**Bottom line for text elements:** Use `overflow: visible` + `padding-bottom: 0.18em`. Never use `overflow: clip` on a text element that contains italic or descending glyphs.

**For container sections (`.hero`, etc):** Use `overflow: hidden` (not `clip`) so that `padding` is respected and children can render into it.

---

## Split-Text Animation Rules (SplitType + GSAP)

When using SplitType with GSAP to animate text, descender clipping is guaranteed unless you follow these rules.

### Rule 1: Every Line Wrapper Gets Padding

SplitType creates this structure:

```html
<div class="split-text">
  <div class="split-text-line">
    <span class="split-text-char">H</span>
    <span class="split-text-char">e</span>
    <!-- ... -->
  </div>
  <div class="split-text-line">
    <!-- second line -->
  </div>
</div>
```

The `.split-text-line` div has `overflow: hidden` and `height: calculated-line-height`. This is where clipping happens.

**Fix:** Apply descender padding to every line:

```css
.split-text-line {
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding and cuts descenders */
}
```

### Rule 2: Calculate Actual Descender Before Animation

Don't use a generic 0.15em for every font. Measure the actual descender for your specific font at your specific size.

```javascript
// At component mount, measure once
function calculateDescenderClearance(element, fontFamily, fontSize) {
  const descent = measureDescender(fontFamily, fontSize);
  // Convert pixels to em: 18px @ 100px = 0.18em
  const clearanceEm = (descent * 1.2) / fontSize; // 1.2 = 20% buffer

  // Set CSS custom property on the element
  element.style.setProperty('--descender-clearance', `${clearanceEm.toFixed(2)}em`);
}

// Usage
const textElement = document.querySelector('.hero-title');
calculateDescenderClearance(textElement, 'editorial-new', 120);
```

### Rule 3: GSAP SplitType Example With Descender Safety

```javascript
import gsap from 'gsap';
import SplitType from 'split-type';

function animateHeadlineWithDescenderSafety(selector) {
  const element = document.querySelector(selector);

  // Measure descender for this specific font/size
  const computed = window.getComputedStyle(element);
  const fontSize = parseFloat(computed.fontSize);
  const fontFamily = computed.fontFamily; // extract from CSS

  // Calculate and apply clearance
  const descent = measureDescender(fontFamily, fontSize);
  const clearanceEm = (descent * 1.2) / fontSize;
  element.style.setProperty('--descender-clearance', `${clearanceEm.toFixed(2)}em`);

  // Split text
  const split = new SplitType(selector, {
    types: 'lines,words,chars',
    lineClass: 'split-text-line',
    charClass: 'split-text-char'
  });

  // Apply padding to all line wrappers — overflow:visible lets descenders breathe
  split.lines.forEach(line => {
    line.style.paddingBottom = `${clearanceEm.toFixed(2)}em`;
    line.style.overflow = 'visible'; // NOT 'clip' — clip ignores padding
  });

  // Now animate safely
  gsap.from(split.chars, {
    duration: 0.8,
    opacity: 0,
    y: 10,
    stagger: 0.05,
    ease: 'back.out'
  });
}

// Call on component mount
animateHeadlineWithDescenderSafety('.hero-title');
```

### Rule 4: Stagger Timing with Font Weight Variation

If using a variable font with wght axis, vary the timing based on character weight for more organic feel:

```javascript
gsap.from(split.chars, {
  duration: 0.8,
  opacity: 0,
  y: 10,
  stagger: (index, target) => {
    // Heavier characters animate slightly slower
    const fontWeight = parseInt(window.getComputedStyle(target).fontWeight) || 400;
    const weightFactor = fontWeight / 400; // 400 = normal, 700+ = slower
    return index * 0.05 * weightFactor;
  },
  ease: 'back.out'
});
```

---

## Hero Section Rules

Hero sections with large text are the highest risk for descender clipping.

### Never Use Overflow: Clip on Hero Container or Text Elements

```css
/* WRONG — overflow:clip ignores padding entirely, cuts descenders */
.hero {
  height: 100dvh;
  overflow: clip;             /* clip ignores padding — descenders still cut */
  overflow-clip-margin: 0.2em; /* this doesn't save you */
}

.hero h1 {
  font-size: 120px;
  overflow: clip;             /* NEVER on a text element */
  padding-bottom: 0.18em;    /* useless when overflow:clip is set */
}
```

### Correct Pattern: overflow:hidden on Container, overflow:visible on Text

```css
/* CORRECT */
.hero {
  height: 100dvh; /* dvh accounts for mobile address bar resize */
  overflow: hidden;   /* hidden (not clip) respects padding on child elements */
  position: relative;
}

.hero h1 {
  font-size: 120px;
  padding-bottom: var(--descender-clearance); /* reserves layout space */
  overflow: visible;  /* lets glyph descenders render freely into that padding */
}
```

The key insight: `overflow: clip` operates at the element's **content box** boundary and does not honour `padding-bottom`. `overflow: visible` on the text element combined with `padding-bottom` is the correct and battle-tested approach.

### Ensure Next Section Has Top Padding

If the hero contains descenders, the next section must have padding to accommodate them when they extend past the hero boundary.

```css
.section-after-hero {
  padding-top: 120px; /* Space for potential descender overflow */
  /* Or use CSS custom property */
  padding-top: var(--section-padding-top, 120px);
}
```

### If Using Clip-Path on Hero

If you're creating a fancy clip-path shape for the hero bottom edge, add margin to account for descenders:

```css
.hero {
  clip-path: polygon(0 0, 100% 0, 100% 85%, 50% 100%, 0 85%);
  margin-bottom: 60px; /* Descender clearance */
}

.hero h1 {
  padding-bottom: var(--descender-clearance);
}
```

---

## The Mandatory Visual Check Sequence

Before declaring any site with display text (>48px) complete, run this checklist:

### Step 1: Render at Scale
Open the live site on a desktop browser. Navigate to the page with large headings (hero, section titles, quotes).

### Step 2: Use Test String
In the browser DevTools, find the first headline (h1 or large display text). Right-click → Inspect. The element should contain or be replaced with this test string:

```
Typography Gg Yy Qq Pp
```

You can manually type this into a headline temporarily, or add it as a data attribute that you toggle on/off with CSS:

```html
<h1 class="hero-title" data-test="true">
  Typography Gg Yy Qq Pp
</h1>
```

```css
h1[data-test="true"]::before {
  content: "Typography Gg Yy Qq Pp";
}
```

### Step 3: Check Bottom Edge

Look closely at the bottom edge of the text. Specifically:
- Is the tail of 'g' fully visible?
- Is the tail of 'y' fully visible?
- Is the descender of 'q' fully visible?
- Is the descender of 'p' fully visible?

If ANY letter is cut off, stop and increase `--descender-clearance` by 0.02em.

### Step 4: Repeat at Multiple Sizes

Check at:
- Desktop (1920px wide)
- Tablet (768px wide)
- Mobile (375px wide)

Font sizes may scale with clamp(), so check at all breakpoints.

### Step 5: Check in Different Browsers

- Chrome
- Safari (if Mac available)
- Firefox

They may render differently due to metric table selection. If any browser clips, adjust clearance upward to the most conservative value.

### Step 6: Screenshot and Verify

Take a screenshot of each headline in each viewport. Keep these screenshots. If a site is flagged in review for descender clipping, pull up these screenshots to verify you tested.

### Step 7: Mobile-Specific Check

On actual mobile device (not browser resize):
- Render headline at mobile scale
- Check descenders
- They may look different due to rendering differences

### Step 8: Declare Done

Only after all checks pass can you declare text implementation complete. Add this comment to your CSS:

```css
/*
 * Descender Safety: VERIFIED
 * Tested @ 100px, 120px, 72px scales
 * Browsers: Chrome, Safari, Firefox
 * Devices: Desktop 1920px, Tablet 768px, Mobile 375px
 * All descenders (g,y,q,p) visible and unclipped
 * Last verified: 2025-03-02
 */
```

---

## Mobile Considerations

At smaller font sizes (body text, 16-24px), descenders are less visually noticeable, but split-text containers still clip if the line wrapper is too short.

### Mobile Text Scaling with Clamp

If using clamp() for responsive typography:

```css
h1 {
  font-size: clamp(2.625rem, 5vw, 3.5rem);
  /* At 375px mobile: 2.625rem = 42px
     At 1920px desktop: 3.5rem = 56px
     Descender scales with font size */
  padding-bottom: var(--descender-clearance);
  /* If clearance is 0.20em at large size, at mobile it's 0.20em * 42px = 8.4px
     Still safe but less buffer */
}
```

If your descender clearance is measured at desktop size, test that it still works at mobile. If mobile text looks tighter, increase clearance by 0.02em.

### Touch-Friendly Test

On mobile, use your finger (not cursor) to hover over text to see the actual rendering on a touch device. Rendering may differ from desktop due to browser optimization.

---

## Advanced: Custom Descender Measurement Per Font

If you're using 3+ different premium fonts, create a font-specific measurement once and store it:

```javascript
// fonts-config.js
export const FONT_METRICS = {
  'editorial-new': {
    descenderClearance: '0.20em',
    descenderPixels: 20, // at 100px size
    category: 'serif'
  },
  'pp-neue-machina': {
    descenderClearance: '0.18em',
    descenderPixels: 18,
    category: 'sans'
  },
  'druk': {
    descenderClearance: '0.10em',
    descenderPixels: 10,
    category: 'sans'
  },
  'sohne': {
    descenderClearance: '0.12em',
    descenderPixels: 12,
    category: 'sans'
  },
  'freight-display': {
    descenderClearance: '0.22em',
    descenderPixels: 22,
    category: 'serif'
  }
};

// Then in your CSS or component
import { FONT_METRICS } from './fonts-config.js';

function applyDescenderSafety(element, fontFamily) {
  const metrics = FONT_METRICS[fontFamily];
  if (metrics) {
    element.style.setProperty('--descender-clearance', metrics.descenderClearance);
  }
}
```

This prevents re-measuring every project and ensures consistency.

---

## Checklist: Descender Safety Before Launch

- [ ] Measured actual descender depth for each font family used (canvas API)
- [ ] Created --descender-clearance CSS custom properties for each font
- [ ] Applied padding-bottom to all headings, display text, split-text lines
- [ ] Used `overflow: visible` on all text/heading elements (NOT `overflow: clip` — clip ignores padding)
- [ ] Used `overflow: hidden` (not `clip`) on hero container sections so child padding is respected
- [ ] Tested visual check sequence with "Typography Gg Yy Qq Pp" at all sizes
- [ ] Checked in Chrome, Safari, Firefox
- [ ] Verified on mobile, tablet, desktop viewports
- [ ] Confirmed actual device rendering (not just browser resize)
- [ ] Screenshots taken and saved for reference
- [ ] No descenders clipped anywhere on the site
- [ ] Added descender-safety verification comment to CSS

Descender clipping is 100% preventable. It only happens if you skip this protocol. Don't skip it.
