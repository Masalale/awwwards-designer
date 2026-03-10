# Page Transitions: Barba.js + GSAP

## How It Works

Barba.js intercepts link clicks, fetches new page content via AJAX, swaps the DOM container, and provides lifecycle hooks (`leave`, `enter`, `after`) where GSAP animations are plugged in. The result: no white flash, no full reload, choreographed transitions between every page.

## CDN Setup

```html
<!-- Barba.js — always use latest, no version pinned -->
<script src="https://cdn.jsdelivr.net/npm/@barba/core/dist/barba.umd.min.js"></script>

<!-- GSAP + plugins — always use latest -->
<script src="https://cdn.jsdelivr.net/npm/gsap/dist/gsap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap/dist/ScrollTrigger.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/gsap/dist/Flip.min.js"></script>
```

> **Before writing Barba.js or GSAP integration code**, use Context7 to pull current API docs. Both libraries evolve their lifecycle hook names and options between major versions — code from memory or old examples will produce subtle bugs.

## Required HTML Structure

Barba needs a wrapper and a container. The wrapper persists across transitions. The container gets swapped.

```html
<body>
  <!-- Persistent elements (nav, cursor, audio) live OUTSIDE the container -->
  <nav class="main-nav">...</nav>
  <div class="custom-cursor"></div>

  <!-- Barba wrapper -->
  <div data-barba="wrapper">
    <!-- Barba container — this gets swapped on navigation -->
    <div data-barba="container" data-barba-namespace="home">
      <!-- All page content goes here -->
      <section class="hero">...</section>
      <section class="content">...</section>
      <footer>...</footer>
    </div>
  </div>
</body>
```

**Key rules:**
- `data-barba-namespace` must be unique per page (e.g., "home", "about", "work", "project-detail")
- Navigation, custom cursor, audio players, and any persistent UI must live OUTSIDE the wrapper
- Every page must have the same wrapper/container structure
- Lenis must be re-initialized after each transition (the scroll container is destroyed and rebuilt)

## Basic Transition: Crossfade

The simplest transition — fade out the current page, swap content, fade in the new page.

```javascript
barba.init({
  transitions: [{
    name: 'fade',

    // Runs once on initial page load (equivalent to page's DOMContentLoaded)
    once({ next }) {
      initPage(next.container);
    },

    // Leave animation — current page exits
    leave({ current }) {
      return gsap.to(current.container, {
        opacity: 0,
        duration: 0.5,
        ease: 'power2.inOut',
      });
    },

    // Enter animation — new page enters
    enter({ next }) {
      // Reset scroll position
      window.scrollTo(0, 0);

      return gsap.from(next.container, {
        opacity: 0,
        duration: 0.5,
        ease: 'power2.inOut',
      });
    },

    // Called after enter completes — reinitialize page-specific JS
    after({ next }) {
      initPage(next.container);
    },
  }],
});

// Page initialization function — called on first load and after every transition
function initPage(container) {
  // Kill old ScrollTriggers to prevent memory leaks
  ScrollTrigger.getAll().forEach(t => t.kill());

  // Reinitialize Lenis (the old scroll container was destroyed)
  if (window.lenis) window.lenis.destroy();
  window.lenis = new Lenis({ duration: 1.2, smooth: true });
  gsap.ticker.add((time) => window.lenis.raf(time * 1000));
  gsap.ticker.lagSmoothing(0);
  window.lenis.on('scroll', ScrollTrigger.update);

  // Refresh ScrollTrigger for new DOM
  ScrollTrigger.refresh();

  // Initialize page-specific animations
  initScrollAnimations(container);
  initHoverStates(container);
}
```

## Intermediate: Clip-Path Wipe

A full-screen overlay wipes across, covering the old page, then reveals the new one. This is the most common transition in SOTD winners.

```javascript
barba.init({
  transitions: [{
    name: 'wipe',

    once({ next }) { initPage(next.container); },

    leave({ current }) {
      const overlay = document.querySelector('.transition-overlay');

      return gsap.timeline()
        .set(overlay, { display: 'block' })
        .fromTo(overlay,
          { clipPath: 'polygon(0% 0%, 0% 0%, 0% 100%, 0% 100%)' },
          { clipPath: 'polygon(0% 0%, 100% 0%, 100% 100%, 0% 100%)',
            duration: 0.8, ease: 'power4.inOut' }
        )
        .to(current.container, { opacity: 0, duration: 0.1 }, '-=0.1');
    },

    enter({ next }) {
      const overlay = document.querySelector('.transition-overlay');
      window.scrollTo(0, 0);

      return gsap.timeline()
        .set(next.container, { opacity: 1 })
        .to(overlay,
          { clipPath: 'polygon(100% 0%, 100% 0%, 100% 100%, 100% 100%)',
            duration: 0.8, ease: 'power4.inOut' }
        )
        .set(overlay, { display: 'none' });
    },

    after({ next }) { initPage(next.container); },
  }],
});
```

**Required overlay HTML** (outside the Barba wrapper):

```html
<div class="transition-overlay" style="
  position: fixed; inset: 0; z-index: 9999;
  background: var(--bg); display: none;
  pointer-events: none;
"></div>
```

## Advanced: GSAP FLIP Shared-Element Morph

The premium technique — an element on the current page (e.g., a project thumbnail) morphs smoothly into its position on the new page (e.g., the project hero image). This is the "app-like" feel that wins Developer Awards.

```javascript
barba.init({
  transitions: [{
    name: 'project-detail',

    // Only use this transition for specific routes
    from: { namespace: ['work'] },
    to: { namespace: ['project-detail'] },

    leave({ current, next, trigger }) {
      // Capture the clicked thumbnail's position
      const thumbnail = trigger.querySelector('.project-thumb');
      const state = Flip.getState(thumbnail);

      // Store for use in enter()
      this.flipState = state;
      this.thumbnailSrc = thumbnail.querySelector('img').src;

      return gsap.to(current.container, {
        opacity: 0,
        duration: 0.3,
      });
    },

    enter({ next }) {
      window.scrollTo(0, 0);

      // Find the hero image on the new page
      const heroImage = next.container.querySelector('.project-hero-img');

      // Animate from thumbnail position to hero position
      return Flip.from(this.flipState, {
        targets: heroImage,
        duration: 0.9,
        ease: 'power3.inOut',
        absolute: true,
      });
    },

    after({ next }) { initPage(next.container); },
  }],
});
```

## Namespace-Specific Transitions

Different page pairs can have different transitions. This is what separates a polished site from a one-trick transition:

```javascript
barba.init({
  transitions: [
    {
      name: 'home-to-work',
      from: { namespace: ['home'] },
      to: { namespace: ['work'] },
      leave(data) { /* slide-up wipe */ },
      enter(data) { /* stagger-in grid */ },
    },
    {
      name: 'work-to-detail',
      from: { namespace: ['work'] },
      to: { namespace: ['project-detail'] },
      leave(data) { /* FLIP morph from thumbnail */ },
      enter(data) { /* hero expand */ },
    },
    {
      name: 'default',
      // Catches all other navigation
      leave(data) { /* crossfade out */ },
      enter(data) { /* crossfade in */ },
    },
  ],
});
```

## Critical: Lenis Reinitializaton

Lenis creates a virtual scroll container. When Barba swaps the DOM, that container is destroyed. You must destroy and recreate Lenis after every transition — otherwise smooth scroll breaks silently.

```javascript
function reinitLenis() {
  // Destroy previous instance
  if (window.lenis) {
    window.lenis.destroy();
    // Remove the old ticker callback
    gsap.ticker.remove(window.lenisRaf);
  }

  // Create fresh instance
  window.lenis = new Lenis({
    duration: 1.2,
    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
    smooth: true,
  });

  // Store reference to the ticker callback so we can remove it later
  window.lenisRaf = (time) => window.lenis.raf(time * 1000);
  gsap.ticker.add(window.lenisRaf);
  gsap.ticker.lagSmoothing(0);
  window.lenis.on('scroll', ScrollTrigger.update);
}
```

## ScrollTrigger Cleanup

Memory leaks from orphaned ScrollTriggers are the most common bug in Barba sites. Every transition must kill all existing triggers before initializing new ones.

```javascript
function cleanupScrollTriggers() {
  ScrollTrigger.getAll().forEach(trigger => trigger.kill());
  // Also kill any GSAP tweens that reference old DOM
  gsap.killTweensOf('*');
}
```

Call `cleanupScrollTriggers()` at the start of every `leave()` or in the `before()` hook.

## Persistent Elements Pattern

Navigation, custom cursors, and audio should persist across transitions. Place them outside `data-barba="wrapper"`:

```html
<body>
  <!-- These persist across ALL page transitions -->
  <nav class="site-nav" id="persistent-nav">...</nav>
  <div class="cursor" id="persistent-cursor"></div>
  <div class="transition-overlay"></div>

  <div data-barba="wrapper">
    <div data-barba="container" data-barba-namespace="home">
      <!-- Page content swaps here -->
    </div>
  </div>
</body>
```

The nav can update its active state in the `after()` hook:

```javascript
function updateNav(namespace) {
  document.querySelectorAll('.nav-link').forEach(link => {
    link.classList.toggle('active', link.dataset.page === namespace);
  });
}
```

## Prefetching for Speed

Barba supports link prefetching — when a user hovers over a link, Barba fetches the page in the background so the transition starts instantly on click:

```javascript
barba.init({
  prefetchIgnore: false, // Enable prefetching
  // ... transitions
});
```

This makes transitions feel instantaneous even on slower connections.

## Single-Page Alternative

For single-page sites (like our Chomba Creative demo), page transitions don't apply directly. But the *feeling* they create — seamless, choreographed flow — should be replicated through:

- **Section transitions:** Clip-path reveals triggered by ScrollTrigger as sections enter
- **Scroll-pinned storytelling:** Sections that pin and transform internal content
- **Loading sequence:** A cinematic loader that acts as the "first transition"
- **Navigation scroll:** Smooth-scrolling to anchors with a transition animation overlay

The principle is the same: no jarring jumps, no content popping in, every moment choreographed.

---

## Checklist: Page Transitions

- [ ] Barba wrapper/container structure on every page
- [ ] Unique `data-barba-namespace` per page
- [ ] Navigation and persistent elements outside the wrapper
- [ ] Lenis destroyed and reinitialized after every transition
- [ ] ScrollTrigger.getAll().forEach(t => t.kill()) before new page init
- [ ] gsap.killTweensOf('*') to prevent orphaned tweens
- [ ] Transition overlay element in the DOM (outside wrapper)
- [ ] At least 2 transition variants (default + one route-specific)
- [ ] Prefetching enabled for hover-based preloading
- [ ] Tested with browser back/forward buttons
- [ ] Active nav state updates after transition
- [ ] No memory leaks (check DevTools Performance tab across 10+ navigations)
