# Scroll Patterns — Deep Dive

Comprehensive reference for scroll-triggered animations. Covers Lenis setup,
reveal types, horizontal galleries, staggered content, and mobile fallbacks.

---

## Lenis Setup

Lenis provides smooth scroll that integrates with GSAP's ticker for unified
timing. It's the foundation of all Antigravity scroll animations.

### Installation & Core Setup

```bash
bun add lenis
```

```js
// lenis.js — initialize once, export globally
import Lenis from '@studio-freight/lenis';

const lenis = new Lenis({
  duration: 1.2,
  easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)), // exponential out
  orientation: 'vertical',
  gestureOrientation: 'vertical',
  smoothWheel: true,
  smoothTouch: false, // HARD STOP — see SKILL.md hard stops
  touchMultiplier: 2,
  infinite: false,
});

// Sync Lenis with GSAP ticker
gsap.ticker.add((time) => {
  lenis.raf(time * 1000);
});
gsap.ticker.lagSmoothing(0);

// Expose for external access
window.lenis = lenis;

export default lenis;
```

### Lenis + ScrollTrigger Integration

```js
// Update ScrollTrigger on Lenis scroll
lenis.on('scroll', ScrollTrigger.update);

// For horizontal scroll sections, pause Lenis during pin
ScrollTrigger.create({
  trigger: '.horizontal-gallery',
  start: 'top top',
  end: 'bottom bottom',
  onEnter: () => lenis.stop(),
  onLeave: () => lenis.stop(),
  onEnterBack: () => lenis.stop(),
  onLeaveBack: () => lenis.stop(),
});
```

### Destroying Lenis (page transitions)

```js
// Call before page transition leave
lenis.destroy();

// Call after page transition enter
lenis = new Lenis({ /* options */ });
gsap.ticker.add((time) => lenis.raf(time * 1000));
```

---

## Reveal Type 1: Fade-Up

The most versatile and universally appropriate reveal. Use for body text,
captions, secondary content, and anything where scale isn't necessary.

```js
// GSAP — individual elements
gsap.from('.fade-up', {
  y: 50,
  opacity: 0,
  duration: 0.8,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.fade-up',
    start: 'top 88%',
    toggleActions: 'play none none reverse',
  },
});

// GSAP — staggered group (see Staggered Content section)
gsap.from('.fade-up-group > *', {
  y: 60,
  opacity: 0,
  duration: 0.8,
  ease: 'power4.out',
  stagger: 0.1,
  scrollTrigger: {
    trigger: '.fade-up-group',
    start: 'top 80%',
  },
});
```

```css
/* CSS-only Tier 1 fallback */
.fade-up {
  opacity: 0;
  transform: translateY(40px);
  transition: opacity 0.6s ease, transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}
.fade-up.is-visible {
  opacity: 1;
  transform: translateY(0);
}
```

---

## Reveal Type 2: Scale

For images, cards, and high-impact moments. Scale reveals draw the eye.
Often combined with fade-up for maximum impact.

```js
// Image scale reveal — from slightly smaller, grows to full size
gsap.from('.scale-reveal', {
  scale: 0.92,
  opacity: 0,
  duration: 1.0,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.scale-reveal',
    start: 'top 85%',
  },
});

// Card scale reveal with fade
gsap.from('.card-scale', {
  scale: 0.85,
  opacity: 0,
  y: 40,
  duration: 0.9,
  ease: 'power4.out',
  stagger: 0.12,
  scrollTrigger: {
    trigger: '.card-grid',
    start: 'top 75%',
  },
});
```

---

## Reveal Type 3: Clip-Path Reveal

The most visually striking reveal. Content "wipes in" from a direction.
Extremely effective for images, hero sections, and full-bleed backgrounds.

```js
// Wipe from left — image reveals left to right
gsap.from('.clip-left', {
  clipPath: 'inset(0 100% 0 0)', // clipped: fully hidden right side
  duration: 1.0,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.clip-left',
    start: 'top 80%',
  },
});

// Wipe from bottom — content reveals upward
gsap.from('.clip-bottom', {
  clipPath: 'inset(100% 0 0 0)',
  duration: 0.9,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.clip-bottom',
    start: 'top 85%',
  },
});

// Circular reveal — hero images, portfolio items
gsap.from('.clip-circle', {
  clipPath: 'circle(0% at 50% 50%)',
  duration: 1.2,
  ease: 'power3.out',
  scrollTrigger: {
    trigger: '.clip-circle',
    start: 'top 80%',
  },
});
```

```css
/* CSS clip-path — simpler variant */
.clip-text {
  clip-path: inset(0 100% 0 0);
  transition: clip-path 0.8s cubic-bezier(0.16, 1, 0.3, 1);
}
.clip-text.is-visible {
  clip-path: inset(0 0% 0 0);
}
```

**⚠️ DESCENDER SAFETY:** All display text (>48px font-size) using clip-path
must have `overflow: visible` and `padding-bottom: 0.1em`. See
`references/text-animation.md` for the full DESCENDER SAFETY PROTOCOL.

---

## Reveal Type 4: Parallax

Parallax creates depth by moving elements at different rates during scroll.
Use sparingly and purposefully — not for decoration.

```js
// Background image parallax — moves slower than scroll
gsap.to('.parallax-bg', {
  yPercent: 30,
  ease: 'none',
  scrollTrigger: {
    trigger: '.parallax-section',
    start: 'top bottom',
    end: 'bottom top',
    scrub: true,
  },
});

// Foreground element — moves faster than scroll (subtle)
gsap.to('.parallax-fore', {
  yPercent: -15,
  ease: 'none',
  scrollTrigger: {
    trigger: '.parallax-section',
    start: 'top top',
    end: 'bottom top',
    scrub: 0.5,
  },
});

// Text parallax — headline moves up as section enters
gsap.to('.parallax-text', {
  y: -80,
  ease: 'none',
  scrollTrigger: {
    trigger: '.parallax-text',
    start: 'top bottom',
    end: 'bottom top',
    scrub: 1,
  },
});
```

**Performance note:** Parallax on large images is expensive. Use `will-change: transform`
on `.parallax-bg` only during the active scroll range. Remove it after:
```js
// Add will-change during scrub
ScrollTrigger.create({
  trigger: '.parallax-bg',
  start: 'top bottom',
  end: 'bottom top',
  onEnter: () => element.style.setProperty('will-change', 'transform'),
  onLeaveBack: () => element.style.removeProperty('will-change'),
});
```

---

## Reveal Type 5: Horizontal Wipe

Text or content that wipes horizontally on scroll. Great for section titles,
lists, or timelines. Requires careful setup to avoid overflow issues.

```js
// Horizontal text wipe — uses clip-path + x translation
gsap.from('.h-wipe', {
  x: '100%',
  clipPath: 'inset(0 0 0 0)', // already visible
  duration: 0.8,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.h-wipe',
    start: 'top 85%',
  },
});

// Cleaner approach: animate a pseudo-element overlay
gsap.from('.h-wipe-wrapper::after', {
  scaleX: 1,
  transformOrigin: 'right',
  duration: 0.7,
  ease: 'power4.inOut',
  scrollTrigger: {
    trigger: '.h-wipe-wrapper',
    start: 'top 80%',
  },
});
```

---

## Reveal Type 6: Circular Reveal

A radial wipe from a specific point. Often used for hero backgrounds,
portfolio grid items, or modal openings. Creates a premium "focus" effect.

```js
// Circular reveal from center
gsap.from('.circle-reveal', {
  clipPath: 'circle(0% at 50% 50%)',
  duration: 1.0,
  ease: 'power3.out',
  scrollTrigger: {
    trigger: '.circle-reveal',
    start: 'top 80%',
  },
});

// Circular reveal from corner — great for images
gsap.from('.circle-corner', {
  clipPath: 'circle(0% at 0% 0%)', // top-left origin
  duration: 1.1,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.circle-corner',
    start: 'top 85%',
  },
});

// Staggered circular reveal for grid
gsap.from('.circle-grid > *', {
  clipPath: 'circle(0% at 50% 50%)',
  duration: 0.8,
  ease: 'power3.out',
  stagger: {
    each: 0.08,
    from: 'random',
  },
  scrollTrigger: {
    trigger: '.circle-grid',
    start: 'top 80%',
  },
});
```

---

## Horizontal Scroll Gallery

One of the most impressive scroll interactions. The user scrolls vertically
but content moves horizontally. Requires careful GSAP ScrollTrigger pin setup.

### Core Pattern: Pin + Horizontal Scrub

```js
// Horizontal scroll gallery
const sections = gsap.utils.toArray('.h-scroll-item');

const hScrollTween = gsap.to(sections, {
  xPercent: -100 * (sections.length - 1),
  ease: 'none',
  scrollTrigger: {
    trigger: '.h-scroll-container',
    pin: true,
    scrub: 1,
    start: 'top top',
    end: () => '+=' + (sections.length - 1) * window.innerWidth,
    anticipatePin: 1, // prevents jump on pin
    invalidateOnRefresh: true,
  },
});

// Optional: fade in first and last items as they enter/exit
gsap.fromTo('.h-scroll-item:first-child',
  { opacity: 0.5 },
  {
    opacity: 1,
    ease: 'none',
    scrollTrigger: {
      trigger: '.h-scroll-container',
      start: 'top top',
      end: 'top+=10% top',
      scrub: true,
    },
  }
);
```

```html
<div class="h-scroll-container">
  <div class="h-scroll-wrapper">
    <section class="h-scroll-item">Slide 1</section>
    <section class="h-scroll-item">Slide 2</section>
    <section class="h-scroll-item">Slide 3</section>
  </div>
</div>
```

```css
.h-scroll-container {
  overflow: hidden;
  height: 100vh;
}
.h-scroll-wrapper {
  display: flex;
  height: 100%;
  will-change: transform;
}
.h-scroll-item {
  flex: 0 0 100vw;
  width: 100vw;
  height: 100%;
}
```

### Horizontal Gallery with Progress Indicator

```js
// Progress bar during horizontal scroll
gsap.to('.h-progress-fill', {
  scaleX: 1,
  ease: 'none',
  scrollTrigger: {
    trigger: '.h-scroll-container',
    start: 'top top',
    end: () => '+=' + (sections.length - 1) * window.innerWidth,
    scrub: 0.3,
  },
});
```

### Cleanup (page transitions)

```js
// Kill horizontal scroll trigger on unmount
const hScrollTrigger = ScrollTrigger.getAll().find(t =>
  t.vars.trigger?.classList?.contains('h-scroll-container')
);
if (hScrollTrigger) hScrollTrigger.kill();
```

---

## Staggered Content Reveals

Stagger creates rhythm and guides attention through content in sequence.
Always stagger in a logical order: headline → subhead → body → images → CTAs.

### Text + Image Stagger

```js
// Orchestrated reveal: title → subtitle → image → body → CTA
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '.stagger-section',
    start: 'top 80%',
  },
});

tl.from('.stagger-title', {
    y: 50,
    opacity: 0,
    duration: 0.8,
    ease: 'power4.out',
  })
  .from('.stagger-subtitle', {
    y: 40,
    opacity: 0,
    duration: 0.6,
    ease: 'power4.out',
  }, '-=0.5') // overlap by 0.5s
  .from('.stagger-image', {
    scale: 0.9,
    opacity: 0,
    duration: 0.9,
    ease: 'power4.out',
  }, '-=0.4')
  .from('.stagger-body', {
    y: 30,
    opacity: 0,
    duration: 0.6,
    ease: 'power4.out',
  }, '-=0.5')
  .from('.stagger-cta', {
    y: 20,
    opacity: 0,
    duration: 0.5,
    ease: 'power4.out',
  }, '-=0.3');
```

### Card Grid Stagger

```js
// Grid stagger — 2D stagger (rows then columns feel)
gsap.from('.card-grid > *', {
  y: 60,
  opacity: 0,
  duration: 0.7,
  ease: 'power4.out',
  stagger: {
    each: 0.08,
    from: 'start', // 'start' = left-to-right, top-to-bottom
                   // 'end' = right-to-left
                   // 'random' = chaotic but visually interesting
                   // { x: 0, y: 1 } = grid-ordered
  },
  scrollTrigger: {
    trigger: '.card-grid',
    start: 'top 80%',
  },
});
```

### Image Gallery Stagger

```js
// Masonry/grid image stagger — use from: 'random' for organic feel
gsap.from('.image-grid img', {
  scale: 0.8,
  opacity: 0,
  duration: 1.0,
  ease: 'power3.out',
  stagger: {
    each: 0.06,
    from: 'random',
  },
  scrollTrigger: {
    trigger: '.image-grid',
    start: 'top 80%',
  },
});
```

---

## Scroll-Velocity Effects

Visual responses based on how fast the user scrolls. Creates a sense of
"weight" and physicality. Use sparingly — these can feel gimmicky.

### Speed-Based Scale

```js
// Elements compress slightly during fast scroll
let lastScrollY = 0;
let velocity = 0;

lenis.on('scroll', ({ scroll, limit, velocity: v }) => {
  velocity = v;

  // Apply subtle scale based on scroll velocity
  gsap.to('.velocity-scale', {
    scale: 1 - Math.min(Math.abs(velocity) * 0.02, 0.05),
    duration: 0.3,
    overwrite: 'auto',
  });
});
```

### Directional Parallax Layers

```js
// Multiple layers moving at different speeds based on scroll direction
// Down scroll: layers move up at different rates
// Up scroll: layers move down

let scrollDir = 1; // 1 = down, -1 = up

lenis.on('scroll', ({ scroll, limit, velocity }) => {
  scrollDir = velocity >= 0 ? 1 : -1;
});

const layers = document.querySelectorAll('.parallax-layer');
layers.forEach((layer, i) => {
  const speed = (i + 1) * 0.05; // each layer slightly faster
  gsap.to(layer, {
    y: () => scrollDir * 100 * speed,
    ease: 'none',
    scrollTrigger: {
      trigger: '.parallax-container',
      start: 'top bottom',
      end: 'bottom top',
      scrub: 0.5,
    },
  });
});
```

---

## Mobile Fallbacks

Scroll-heavy animations often need simplified versions on mobile to maintain
60fps. Implement feature detection, not device detection.

### Responsive Scroll Animation Strategy

```js
// Check for reduced-motion AND low-end device
const isLowEnd = navigator.hardwareConcurrency <= 4 ||
                 !window.matchMedia('(min-width: 768px)').matches;
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

if (!prefersReducedMotion && !isLowEnd) {
  // Full scroll animations
  initScrollAnimations();
} else if (!prefersReducedMotion) {
  // Simplified: only fade-up, no parallax, no horizontal scroll
  initSimplifiedScroll();
}

// Progressive enhancement: load as you go
function initSimplifiedScroll() {
  gsap.from('.section-reveal', {
    opacity: 0,
    y: 30,
    duration: 0.5,
    ease: 'power2.out',
    scrollTrigger: {
      trigger: '.section-reveal',
      start: 'top 90%',
      once: true,
    },
  });
}
```

### Mobile-Specific CSS

```css
/* Disable parallax on mobile */
@media (max-width: 767px) {
  .parallax-bg,
  .parallax-fore {
    transform: none !important;
  }

  /* Simplify clip-path animations */
  .clip-complex {
    clip-path: none !important;
  }
}

/* Reduced motion — remove all scroll animations */
@media (prefers-reduced-motion: reduce) {
  .scroll-reveal,
  .parallax-* {
    transform: none !important;
    opacity: 1 !important;
    clip-path: none !important;
  }
}
```

### Performance Budget for Mobile

- Max 3 simultaneous ScrollTrigger instances on mobile
- No horizontal scroll galleries on mobile (convert to vertical stack)
- Images: lazy-load all below-fold images
- Use `loading="lazy"` and `decoding="async"` on all images
- Target: <3s LCP on 4G throttle
