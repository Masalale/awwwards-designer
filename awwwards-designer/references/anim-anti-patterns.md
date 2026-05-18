# Anti-Patterns — The Definitive No-No List

Every pattern here is wrong. Every example shows what NOT to write and why.
These are hard failures in code review. Know them. Avoid them. Fix them on sight.

---

## 1. `transition: all` — The Cardinal Sin

The single most destructive CSS mistake. Animating all properties causes
layout thrashing, janky performance, and unpredictable behavior.

### ❌ BAD

```css
/* NEVER DO THIS */
button {
  transition: all 0.3s ease;
}

a {
  transition: all 0.2s;
}

div {
  transition: all 0.5s linear;
}
```

### ✅ CORRECT

```css
/* Only animate what you need */
button {
  transition:
    transform 0.3s cubic-bezier(0.16, 1, 0.3, 1),
    background-color 0.2s ease,
    box-shadow 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

a {
  transition: color 0.2s ease, opacity 0.2s ease;
}

div {
  transition:
    opacity 0.5s cubic-bezier(0.16, 1, 0.3, 1),
    transform 0.5s cubic-bezier(0.16, 1, 0.3, 1);
}
```

### Why It's Bad

- Animates `width`, `height`, `margin`, `padding`, `font-size`, etc. — all layout properties
- Causes reflow/repaint on every frame — destroys 60fps
- Unpredictable: hover on a `<div>` with `all` might animate `z-index`, `cursor`, `visibility`
- Makes debugging impossible — which property is causing the issue?

---

## 2. Animating Layout Properties

Animating `width`, `height`, `margin`, `top`, `left`, `font-size` triggers
expensive layout recalculations. Use `transform` instead.

### ❌ BAD

```css
/* DO NOT animate width/height */
.modal {
  transition: width 0.4s ease, height 0.4s ease, opacity 0.3s ease;
}

.modal.is-open {
  width: 500px;
  height: 400px;
}

/* DO NOT animate margin */
.card {
  transition: margin-top 0.3s ease, opacity 0.3s ease;
}

/* DO NOT animate font-size directly */
.headline {
  transition: font-size 0.3s ease;
}
```

### ✅ CORRECT

```css
/* Use transform for size changes */
.modal {
  transform: scale(0);
  transition: transform 0.4s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.3s ease;
}

.modal.is-open {
  transform: scale(1);
}

/* Use transform for position */
.card {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.3s ease;
}

.card.is-active {
  transform: translateY(-10px);
}

/* Use transform: scale() instead of font-size */
.headline {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.headline.is-enlarged {
  transform: scale(1.2); /* instead of font-size: 72px */
}
```

### Performance Impact

| Property | Triggered | Cost |
|----------|-----------|------|
| `transform` | Composite only | ~0.5ms |
| `opacity` | Composite only | ~0.5ms |
| `width`, `height` | Layout + Paint | ~10-50ms |
| `margin`, `padding` | Layout | ~5-30ms |
| `top`, `left` | Layout | ~5-30ms |
| `font-size` | Layout + Paint | ~10-40ms |

---

## 3. Blocking the Main Thread

Long-running JavaScript on the main thread causes jank, dropped frames,
and unresponsive UI. Animations must never block user input.

### ❌ BAD

```js
// Blocking animation loop — runs continuously, blocks scrolling
function animate() {
  for (let i = 0; i < 1000000; i++) {
    element.style.transform = `translateX(${i}px)`;
  }
  requestAnimationFrame(animate);
}
animate();

// Synchronous heavy computation in scroll handler
window.addEventListener('scroll', () => {
  const result = expensiveComputation(); // blocks thread for 200ms+
  updateUI(result);
});

// DOM thrashing in loop
function moveElements() {
  for (let i = 0; i < 100; i++) {
    elements[i].style.left = i * 10 + 'px'; // causes layout each iteration
  }
}
```

### ✅ CORRECT

```js
// Use RAF for animation loops — yields to browser between frames
function animate(timestamp) {
  // Lightweight per-frame updates
  element.style.transform = `translateX(${timestamp / 10}px)`;
  requestAnimationFrame(animate);
}
requestAnimationFrame(animate);

// Throttle/debounce expensive scroll handlers
import { throttle } from 'lodash-es';

window.addEventListener('scroll', throttle(() => {
  const result = getScrollPosition(); // cheap
  requestAnimationFrame(() => updateUI(result)); // non-blocking
}, 16), { passive: true });

// Batch DOM reads/writes
function moveElements() {
  // Read all first
  const positions = elements.map(el => el.dataset.index * 10);
  // Then write all
  elements.forEach((el, i) => {
    el.style.transform = `translateX(${positions[i]}px)`;
  });
  // Trigger one reflow by reading
  document.body.offsetHeight; // force reflow
}

// Web Workers for heavy computation
const worker = new Worker('compute.js');
worker.postMessage({ data: bigArray });
worker.onmessage = (e) => updateUI(e.data);
```

### Warning Signs

- "Long task" entries in Chrome DevTools Performance tab
- `getComputedStyle` inside loops
- Synchronous `XMLHttpRequest` (use fetch instead)
- Heavy array operations on large datasets without debouncing
- Canvas/WebGL rendering without `requestAnimationFrame`

---

## 4. Infinite Distracting Animations

Animations that loop forever without purpose drain battery, distract users,
and scream "amateur hour." Never animate something that doesn't need animating.

### ❌ BAD

```css
/* Floating animation that never stops */
.logo {
  animation: float 3s ease-in-out infinite;
}

@keyframes float {
  0%, 100% { transform: translateY(0); }
  50% { transform: translateY(-10px); }
}

/* Pulsing glow that never stops */
.hero-bg {
  animation: pulse 2s ease-in-out infinite;
}

/* Spinning loader that doesn't stop */
.spinner {
  animation: spin 1s linear infinite;
}

/* Scrolling marquee text */
.marquee {
  animation: marquee 20s linear infinite;
}
```

### ✅ CORRECT

```css
/* Floating only during hero section — triggered, not looping */
.hero-logo.is-floating {
  animation: float 3s ease-in-out 2; /* runs 2 times, stops */
}

/* Pulse once on load */
.hero-glow {
  animation: pulse-once 1s ease-out forwards;
}

/* Loaders MUST stop when content loads */
.spinner.is-hidden {
  animation: spin 1s linear infinite; /* paused via display:none instead */
}

/* Marquees: use only when appropriate, stop when off-screen */
.marquee {
  animation: marquee 20s linear infinite;
  animation-play-state: paused; /* start on hover or intersection */
}

.marquee:hover {
  animation-play-state: running;
}
```

### When Infinite Animation IS OK

- **Loading spinners**: User is explicitly waiting
- **Background ambience**: Only when page is NOT the active tab (use `document.visibilityState`)
- **Decorative elements that user can dismiss**: Show once, offer to dismiss

```js
// Only animate when page is visible
document.addEventListener('visibilitychange', () => {
  if (document.visibilityState === 'visible') {
    document.querySelector('.ambient-bg').style.animationPlayState = 'running';
  } else {
    document.querySelector('.ambient-bg').style.animationPlayState = 'paused';
  }
});
```

---

## 5. Parallax Without Purpose

Parallax that exists "for visual interest" without functional purpose adds
complexity, performance cost, and often feels gimmicky. If parallax doesn't
reveal, emphasize, or create narrative, don't use it.

### ❌ BAD

```js
// Parallax on decorative elements that adds nothing
document.querySelectorAll('.decorative-circle').forEach(el => {
  gsap.to(el, {
    y: () => ScrollTrigger.scroll() * 0.1,
    // No clear purpose — just "it moves"
  });
});

// Parallax on ALL elements — overkill
gsap.utils.toArray('section > *').forEach(el => {
  gsap.to(el, { y: -50, scrollTrigger: { ... } });
});

// Parallax that contradicts scroll direction — nauseating
gsap.to('.weird-element', {
  y: () => -ScrollTrigger.scroll() * 0.3, // moves up while scrolling down
});
```

### ✅ CORRECT

```js
// Parallax on a background image — creates depth hierarchy
gsap.to('.hero-bg', {
  yPercent: 30, // background moves slower = depth
  ease: 'none',
  scrollTrigger: {
    trigger: '.hero',
    start: 'top top',
    end: 'bottom top',
    scrub: true,
  },
});

// Parallax that reveals hidden content
gsap.to('.parallax-overlay', {
  yPercent: -100, // scrolls away to reveal section beneath
  scrollTrigger: {
    trigger: '.parallax-overlay',
    start: 'top top',
    end: 'bottom top',
    scrub: 1,
  },
});

// Purposeful parallax: guide attention to next section
gsap.to('.scroll-indicator', {
  y: 100,
  opacity: 0,
  scrollTrigger: {
    trigger: '.hero',
    start: 'top top',
    end: 'bottom top',
    scrub: true,
    // Indicator fades as user scrolls — guides "there's more below"
  },
});
```

### Quick Purpose Test

Ask: "What does this parallax communicate?" If the answer is "nothing," remove it.

---

## 6. Linear Easing Everywhere

Linear easing makes animations feel robotic, mechanical, and cheap.
Everything in nature has non-linear motion. Every UI animation needs easing.

### ❌ BAD

```css
/* All linear — everywhere */
.modal {
  transition: all 0.3s linear;
}

.card {
  transition: transform 0.5s linear, opacity 0.5s linear;
}

.nav-link {
  transition: color 0.2s linear;
}

/* GSAP linear — never use for user-facing animations */
gsap.to('.element', {
  x: 100,
  duration: 1,
  ease: 'none', // linear
});
```

### ✅ CORRECT

```css
/* Non-linear easing for every transition */
.modal {
  transition:
    transform 0.4s cubic-bezier(0.16, 1, 0.3, 1),
    opacity 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.card {
  transition:
    transform 0.5s cubic-bezier(0.16, 1, 0.3, 1),
    opacity 0.5s cubic-bezier(0.22, 1, 0.36, 1);
}

.nav-link {
  transition: color 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

/* GSAP — always use named eases */
gsap.to('.element', {
  x: 100,
  duration: 1,
  ease: 'power4.out', // fast start, smooth landing
});
```

### When Linear IS OK

- **Scrub-based animations**: `scrub: 1` in ScrollTrigger — linear is correct because it's tied to scroll position
- **Progress indicators**: Loading bars, timelines where uniform speed is intentional
- **CSS `linear()` function**: For specific UI patterns (sliders, volume controls)

```js
// Scrub = linear is correct
gsap.to('.progress-bar', {
  scaleX: progress,
  ease: 'none', // linear — tied 1:1 to scroll
  scrollTrigger: {
    trigger: '.scroll-progress',
    start: 'top top',
    end: 'bottom bottom',
    scrub: 0.5,
  },
});
```

---

## 7. No `prefers-reduced-motion` Support

Animations that play regardless of user preference are inaccessible and
potentially harmful. WCAG 2.1 Level AA requires respecting this preference.

### ❌ BAD

```css
/* No reduced motion handling */
.hero {
  animation: hero-entrance 1.2s ease-out;
}

.content {
  transition: all 0.5s;
}

/* Everything loops and animates, always */
.floating {
  animation: float 3s ease-in-out infinite;
}
```

### ✅ CORRECT

```css
/* Respect reduced motion at the CSS level */
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }

  /* Exception: essential motion only */
  .loading-spinner {
    animation-duration: 2s !important; /* user expects spinner */
  }
}

/* For animations that ARE essential, allow them selectively */
@media (prefers-reduced-motion: no-preference) {
  .hero {
    animation: hero-entrance 1.2s ease-out;
  }
  .floating {
    animation: float 3s ease-in-out infinite;
  }
}
```

```js
// Respect reduced motion in JavaScript
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

// Scroll animations
if (!prefersReducedMotion) {
  gsap.registerPlugin(ScrollTrigger);

  // These animations only run if user has no motion preference
  gsap.from('.hero-title', {
    y: 50,
    opacity: 0,
    duration: 0.8,
    scrollTrigger: {
      trigger: '.hero-title',
      start: 'top 80%',
    },
  });
}

// Or check dynamically
window.matchMedia('(prefers-reduced-motion: reduce)')
  .addEventListener('change', (e) => {
    if (e.matches) {
      // User just enabled reduced motion — kill active animations
      gsap.killTweensOf('*');
      ScrollTrigger.getAll().forEach(t => t.kill());
    }
  });
```

### What "Reduced Motion" Means

| Motion Type | Full Behavior | Reduced Motion |
|-------------|--------------|---------------|
| Entrance animation | Full choreographed reveal | Instant or minimal |
| Scroll parallax | Active | Disabled |
| Hover animations | Full | Minimal or disabled |
| Page transitions | Animated | Instant cut or fade |
| Loading spinners | Animated | Static or "Loading..." |
| Carousels | Auto-advance | User-controlled only |

---

## Anti-Pattern Quick Reference

| Anti-Pattern | What to Do Instead |
|-------------|-------------------|
| `transition: all` | List specific properties only |
| Animate `width`/`height` | Use `transform: scale()` |
| `linear` easing | Use `power4.out`, `back.out`, etc. |
| Infinite floating loops | Trigger once, or remove entirely |
| Parallax without purpose | Remove, or articulate the purpose |
| No reduced-motion | Add `@media` queries + JS check |
| Blocking main thread | RAF, Web Workers, batch DOM ops |
| No cleanup on unmount | Kill ScrollTrigger, remove listeners |

---

## Code Review Checklist

Before shipping any animation work:

- [ ] Zero instances of `transition: all` or `transition: all 0.xs`
- [ ] Zero instances of `linear` in production animation code
- [ ] All layout property animations converted to `transform`
- [ ] `prefers-reduced-motion` handled in both CSS and JS
- [ ] ScrollTrigger instances killed on component unmount
- [ ] No `setInterval` or `setTimeout` loops for animations
- [ ] No blocking operations in scroll/RAF callbacks
- [ ] Parallax elements have a documented purpose
- [ ] No infinite animations that aren't loaders
- [ ] DevTools Performance tab shows no "Long tasks" during animation

Run this checklist. Every violation is a hard failure.
