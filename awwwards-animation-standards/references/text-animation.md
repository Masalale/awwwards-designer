# Text Animation — Deep Dive

Complete reference for animating text with SplitType, variable fonts,
masked reveals, and distortion effects. Includes the critical DESCENDER
SAFETY PROTOCOL.

---

## SplitType Integration

SplitType splits text into `char`, `word`, and/or `line` elements that can
be animated individually. It's the foundation of all headline animations.

### Installation & Setup

```bash
bun add split-type
```

```js
import SplitType from 'split-type';

// Initialize — splits text into <span> elements
const title = new SplitType('.headline', {
  types: 'chars, words, lines', // specify what to split
  tagName: 'span',
});

// Results:
// <h1 class="headline" data-split="lines">
//   <div class="split-line">           ← line wrapper
//     <span class="split-word">         ← word wrapper
//       <span class="split-char">H</span>  ← individual chars
//       <span class="split-char">e</span>
//       ...
//     </span>
//   </div>
//   ...
// </h1>
```

### Basic Char Reveal

```js
// Fade-up reveal with stagger — the classic headline animation
const title = new SplitType('.hero-title', { types: 'chars, words' });

gsap.from(title.chars, {
  y: 80,
  opacity: 0,
  rotateX: -90,
  transformOrigin: '50% 100%',
  duration: 0.8,
  ease: 'power4.out',
  stagger: 0.03,      // 30ms between chars
  scrollTrigger: {
    trigger: '.hero-title',
    start: 'top 80%',
  },
});
```

### Word-by-Word Reveal

```js
// Words reveal sequentially — more readable than chars for body headlines
const subhead = new SplitType('.section-title', { types: 'words' });

gsap.from(subhead.words, {
  y: 40,
  opacity: 0,
  duration: 0.6,
  ease: 'power4.out',
  stagger: 0.1,       // 100ms between words
  scrollTrigger: {
    trigger: '.section-title',
    start: 'top 80%',
  },
});
```

### Line-by-Line Reveal

```js
// Lines reveal with clip-path — cinematic reveal effect
const hero = new SplitType('.hero-headline', { types: 'lines' });

gsap.from(hero.lines, {
  clipPath: 'inset(0 0 100% 0)',
  duration: 1.0,
  ease: 'power4.out',
  stagger: 0.15,
  scrollTrigger: {
    trigger: '.hero-headline',
    start: 'top 80%',
  },
});
```

### SplitType + GSAP Timeline (Choreographed)

```js
// Three-phase reveal: chars → lines wipe → opacity settle
const headline = new SplitType('.reveal-headline', { types: 'chars, lines' });

const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '.reveal-headline',
    start: 'top 80%',
  },
});

// Phase 1: Characters fade up
tl.from(headline.chars, {
  y: 60,
  opacity: 0,
  rotateZ: 5,
  duration: 0.6,
  ease: 'power4.out',
  stagger: 0.02,
});

// Phase 2: Lines "settle" with a slight scale
tl.from(headline.lines, {
  scaleY: 1.1,
  transformOrigin: 'bottom',
  duration: 0.4,
  ease: 'power2.out',
}, '-=0.2');

// Phase 3: Full opacity pass to clean up any artifacts
tl.to(headline.chars, {
  opacity: 1,
  y: 0,
  rotateZ: 0,
  duration: 0.3,
  ease: 'power2.out',
}, '-=0.1');
```

### SplitType Cleanup (Required!)

```js
// After page transition or component unmount
function destroySplit() {
  document.querySelectorAll('.split-type').forEach(el => {
    el.revert(); // SplitType method to restore original text
  });
}

// Listen for page leave
document.addEventListener('pageLeave', destroySplit);
```

---

## Variable Font Animation

Variable fonts expose axes (like `wght` for weight) that can be animated
smoothly between values. Powerful for display text, no need for multiple font files.

### Weight Axis Animation (wght)

```js
// Animate weight from thin to bold on scroll
const title = document.querySelector('.var-font-title');

// CSS variable font variation settings
title.style.fontVariationSettings = '"wght" 100';

gsap.to(title, {
  fontVariationSettings: '"wght" 900',
  ease: 'none',
  scrollTrigger: {
    trigger: title,
    start: 'top center',
    end: 'bottom center',
    scrub: 1, // smooth interpolation tied to scroll
  },
});
```

```css
/* CSS setup for variable font */
@font-face {
  font-family: 'Inter';
  src: url('/fonts/Inter-Variable.woff2') format('woff2-variations');
  font-weight: 100 900; /* define the range */
}

.var-font-title {
  font-family: 'Inter', sans-serif;
  font-variation-settings: 'wght' 400;
  font-weight: 400; /* also set font-weight as fallback */
}
```

### Width Axis Animation (wdth)

```js
// Condensed ↔ expanded — great for dramatic headlines
gsap.to('.expanded-text', {
  fontVariationSettings: '"wdth" 100',  // condensed
  duration: 1,
  ease: 'power2.inOut',
  scrollTrigger: {
    trigger: '.expanded-text',
    start: 'top 80%',
  },
});
```

### Multiple Axes Combined

```js
// Simultaneous weight + width animation
gsap.to('.morph-text', {
  fontVariationSettings: '"wght" 900, "wdth" 75, "slnt" -10',
  duration: 0.8,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.morph-text',
    start: 'top 80%',
  },
});
```

### Variable Font Cheat Sheet

| Axis Tag | Property | Common Range | Use |
|----------|----------|-------------|-----|
| `wght` | font-weight | 100–900 | Boldness, emphasis |
| `wdth` | font-stretch | 75–125 | Condensed/expanded |
| `ital` | font-style | 0–1 | Italic transition |
| `slnt` | font-style slant | -12–0 | Slant angle |
| `opsz` | optical sizing | 8–144 | Detail scaling |
| `GRAD` | grade | -50–150 | Weight without size change |

---

## Masked Text Reveals

Text masks create dramatic reveals where content appears through a clipping shape.
Two main techniques: `clip-path` (GPU-accelerated) and `mask-image` (CSS gradients).

### Clip-Path Masked Reveal

```js
// Text wipes in from below — the most common masked reveal
const title = document.querySelector('.masked-title');

gsap.from('.masked-title', {
  clipPath: 'inset(0 0 100% 0)', // fully clipped from bottom
  duration: 0.8,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.masked-title',
    start: 'top 80%',
  },
});
```

```css
/* With a parent container as the mask */
.masked-container {
  overflow: hidden;
}

.masked-title {
  /* No overflow clipping here — container handles it */
}
```

### Gradient Mask Reveal

```css
/* Text fades in through a gradient mask */
.masked-text {
  mask-image: linear-gradient(to bottom, transparent 0%, black 20%, black 80%, transparent 100%);
  mask-size: 100% 300%;
  mask-position: 0 0;
  animation: reveal-mask 1s cubic-bezier(0.16, 1, 0.3, 1) forwards;
}

@keyframes reveal-mask {
  to {
    mask-position: 0 100%;
  }
}
```

### SVG Text Mask

```html
<svg class="svg-mask" viewBox="0 0 400 100" preserveAspectRatio="none">
  <defs>
    <clipPath id="textClip">
      <text x="0" y="80" font-size="80" font-family="sans-serif">
        MASKED
      </text>
    </clipPath>
  </defs>
  <rect class="mask-rect" clip-path="url(#textClip)" fill="#000" />
</svg>
```

```js
// Animate the rect reveal
gsap.to('.mask-rect', {
  scaleX: 0,
  transformOrigin: 'right',
  duration: 1.2,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.svg-mask',
    start: 'top 80%',
  },
});
```

---

## Text Distortion Effects

High-impact effects for hero sections and key moments. Use sparingly —
they can be distracting in regular content.

### Character Scramble

```js
// Characters rapidly scramble through random chars before settling
function scrambleText(element, finalText, duration = 0.8) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  const finalChars = finalText.split('');
  let iteration = 0;

  const interval = setInterval(() => {
    element.textContent = finalChars.map((char, index) => {
      if (index < iteration) return finalChars[index];
      return chars[Math.floor(Math.random() * chars.length)];
    }).join('');

    iteration += 1 / (duration * 30); // frames based on duration

    if (iteration >= finalChars.length) {
      element.textContent = finalText;
      clearInterval(interval);
    }
  }, 1000 / 60); // 60fps
}

// Scramble on scroll
scrambleText(document.querySelector('.scramble'), 'SCRAMBLED TEXT', 1.2);

gsap.from('.scramble', {
  opacity: 0,
  duration: 0.3,
  scrollTrigger: {
    trigger: '.scramble',
    start: 'top 80%',
    onEnter: () => scrambleText(document.querySelector('.scramble'), 'SCRAMBLED TEXT', 1.0),
  },
});
```

### Text Wave Effect

```js
// Characters move in a wave pattern — great for hover or scroll
const title = new SplitType('.wave-text', { types: 'chars' });

gsap.to(title.chars, {
  y: -20,
  rotateZ: 5,
  duration: 0.4,
  ease: 'power2.out',
  stagger: {
    each: 0.03,
    from: 'center', // start from center, ripple outward
  },
  scrollTrigger: {
    trigger: '.wave-text',
    start: 'top 80%',
  },
});
```

### Glitch Effect

```js
// Random offset + clip displacement — the classic digital glitch
function glitchText(element, iterations = 10) {
  const tl = gsap.timeline({
    onComplete: () => {
      gsap.set(element, { x: 0, skewX: 0, clipPath: 'none' });
    },
  });

  for (let i = 0; i < iterations; i++) {
    tl.to(element, {
      x: () => Math.random() * 20 - 10,
      skewX: () => Math.random() * 10 - 5,
      duration: 0.05,
      ease: 'none',
    })
    .to(element, {
      clipPath: `inset(${Math.random() * 20}% 0)`,
      duration: 0.02,
    }, '<')
    .to(element, {
      x: 0,
      skewX: 0,
      clipPath: 'none',
      duration: 0.01,
    });
  }

  return tl;
}

// Trigger on section enter
glitchText(document.querySelector('.glitch-text'));

gsap.from('.glitch-text', {
  scrollTrigger: {
    trigger: '.glitch-text',
    start: 'top 80%',
    onEnter: () => glitchText(document.querySelector('.glitch-text')),
  },
});
```

### Per-word Fade + Scale

```js
// Each word fades and scales independently — elegant, readable
const body = new SplitType('.body-reveal', { types: 'words' });

gsap.from(body.words, {
  opacity: 0,
  scale: 0.9,
  duration: 0.5,
  ease: 'power4.out',
  stagger: 0.05,
  scrollTrigger: {
    trigger: '.body-reveal',
    start: 'top 85%',
  },
});
```

---

## DESCENDER SAFETY PROTOCOL

**⚠️ CRITICAL — This is a hard stop. All violations are auto-fails.**

Display text (>48px font-size) with descenders (g, y, p, q, j) will visually
clip during clip-path animations. The fix is two-part and mandatory.

### The Problem

```
Font: Display text, 72px
Characters: "Amazing"
Problem: The 'g' in "Amazing" has a descender that extends below the baseline.
         During clip-path animation (inset from bottom), the bottom of 'g'
         gets clipped even though the container is tall enough.
```

### The Fix: Two-Part

**Part 1: CSS — overflow + padding**

```css
/* MANDATORY for any display text >48px that uses scroll animations */
.display-text {
  overflow: visible;           /* Allow descenders to render outside bounds */
  padding-bottom: 0.18em;      /* Minimum clearance — measure actual descender per font via Canvas API */
  will-change: transform;      /* Hint GPU for transform animations */
}

/* Container also needs overflow visible */
.text-container {
  overflow: visible;
  position: relative;          /* Establish stacking context */
}

/* For clip-path reveals: the parent must NOT clip */
.clip-parent {
  overflow: visible;            /* NOT hidden! */
}
```

**Part 2: HTML — Structure**

```html
<!-- WRONG: Clip will happen -->
<div style="overflow: hidden; height: 80px;">
  <h1 class="headline">Amazing Logo</h1>
</div>

<!-- CORRECT: Descenders escape upward -->
<div class="text-container">
  <h1 class="display-text headline">Amazing Logo</h1>
</div>
```

### Full Example: Descender-Safe Scroll Reveal

```css
/* CSS */
.hero-title-wrap {
  overflow: visible;
  padding-bottom: 0.18em; /* Minimum clearance for descenders — measure per font */
}

.hero-title {
  font-size: 80px;       /* >48px — triggers descender safety */
  overflow: visible;
  font-family: 'Display Font', sans-serif;
}
```

```js
// JS — clip-path reveal on display text
gsap.from('.hero-title', {
  y: 100,
  opacity: 0,
  duration: 1.0,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.hero-title-wrap',
    start: 'top 80%',
  },
});

// If using clip-path on the wrapper:
gsap.from('.hero-title-wrap', {
  clipPath: 'inset(0 0 100% 0)',  // Safe because of overflow:visible + padding
  duration: 0.9,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.hero-title-wrap',
    start: 'top 80%',
  },
});
```

### Descender Character Reference

Characters that extend below baseline (need extra padding):
```
Lowercase:  g, y, p, q, j
Some fonts: f (at large sizes), comma, semicolon, etc.
```

Characters safe from clipping:
```
Uppercase:  A-Z (most fonts)
Lowercase:  a, b, c, d, e, h, i, k, l, m, n, o, r, s, t, u, v, w, x, z
Numbers:    0-9
Symbols:    Most
```

### Descender Safety Checklist

- [ ] All text elements >48px have `overflow: visible`
- [ ] All text elements >48px have `padding-bottom: 0.18em` minimum (measure per font via Canvas API)
- [ ] Parent containers of animated text have `overflow: visible`
- [ ] SplitType wrapper elements have `overflow: visible`
- [ ] Line wrapper elements from SplitType have `overflow: visible`
- [ ] Clip-path reveals tested with descender-heavy text (e.g., "Typography")
- [ ] Tested at multiple viewport widths — descenders can shift with fluid type

---

## Text Animation Performance

- SplitType creates many `<span>` elements. For 100-char headlines, that's ~100 DOM nodes.
  Use `will-change: transform` on char/word elements only during animation.
- Variable font animations are cheap — they're just CSS property changes.
- Avoid animating `font-size` directly. Use `transform: scale()` instead.
- For long-form text (>200 words), consider animating paragraphs as units, not words.
- Use `content-visibility: auto` on off-screen text sections to skip rendering.
