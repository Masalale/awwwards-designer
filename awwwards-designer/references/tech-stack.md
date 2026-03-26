# Enhancement Layer: Tier-Based Implementation Guide

## Capability-First Principle

Every section in this guide describes a **capability to achieve**, not a library to install. The selection criteria under each capability are what make the default recommendation correct for Awwwards-level work — not the tool name itself. When the animation map requires a capability not documented here, or when a newer tool appears to be a better fit, use those criteria as your evaluation rubric and Context7 to research current options. Choose the tool that best satisfies the criteria; if you deviate from a documented default, note the reason in a one-line comment at the integration point.

---

## How to Choose a Tier

The tier was established in Phase 1 and confirmed in the animation map. It defines the ceiling of animation complexity and the performance budget. Build from the tier up — if the animation map does not demand Tier 3, do not implement it.

| Tier | What it achieves | JS budget (gzip) |
|------|-----------------|-----------------|
| **1** | CSS-only animations and transitions | < 20KB |
| **2** | Scroll-triggered reveals, smooth scroll, animated text, page transitions | < 120KB |
| **2.5** | Everything in Tier 2 + three-dimensional spatial elements in specific zones | < 150KB |
| **3** | Everything in Tier 2 + full GPU-rendered scenes, generative art, GLSL shaders | < 300KB |

---

## Tier 1: CSS-Primary Enhancement

No JS animation library needed. CSS alone achieves scroll-driven animations, entrance sequences, and view transitions.

**What the Enhancement Layer must achieve:**
- Scroll-driven animations (reveals, parallax, sticky effects) via `animation-timeline: scroll()`
- Entrance animations via CSS `@starting-style` and `transition`
- Page transition feel via CSS View Transitions API (`@view-transition`, `::view-transition-*`)
- Font loading optimized (`font-display: swap`, preload critical fonts)
- Responsive image strategy (AVIF/WebP with `<picture>`, `fetchpriority="high"` on LCP)

**Performance targets:**
- FCP: < 1.0s | LCP: < 1.8s | CLS: < 0.05 | INP: < 100ms | JS budget: < 20KB

---

## Tier 2: JS-Enhanced Animation

### Capability: Scroll Orchestration

**Goal:** Precisely timed, multi-element animation sequences driven by scroll position — section reveals, scroll-pinned sections, scrub-based timelines.

**Selection criteria:**
1. Scrub-based timelines — animation progress maps 0→1 to a defined scroll window
2. Multi-element choreography with configurable trigger points and stagger
3. PIN support — elements remain fixed in viewport during a scroll window
4. Cleanup API that kills all instances on route change without memory leaks
5. Syncs with a smooth scroll library's virtual scroll position (not just native scroll events)

**Current recommended:** GSAP + ScrollTrigger — the only option that satisfies all five at Awwwards-level complexity. Use Context7 for current API docs before implementing.

**Alternatives when simpler is sufficient:**
- CSS `animation-timeline: scroll()` — zero bundle cost, sufficient for single-element reveals with no choreography
- Intersection Observer + CSS class toggle — lightweight, sufficient for basic fade-in entrances

---

### Capability: Smooth Scroll

**Goal:** Momentum-based, eased scrolling that syncs with the animation render loop without disrupting native mobile scroll behavior.

**Selection criteria:**
1. Does not intercept native touch scroll — must be configurable to off, never forced on
2. Exposes a RAF/tick callback to sync with the JS animation library's render loop
3. Provides a full `destroy()` method for clean teardown on route change
4. Bundle contribution: < 15KB gzip

**Current recommended:** Lenis — satisfies all four. If the animation map does not specify smooth scroll, native browser scroll is always acceptable and preferable.

---

### Capability: Animated Text

**Goal:** Character-level or word-level DOM text splitting for GSAP-driven reveal animations.

**Selection criteria:**
1. DOM-based splitting — preserves accessibility and SEO (not canvas rendering)
2. Accurate line, word, and character measurement including descenders
3. Produces standard DOM elements usable as GSAP animation targets
4. Handles responsive resize — re-splits correctly after layout reflow

**Current recommended:** SplitType. Use Context7 for current API docs.

**Descender safety is mandatory regardless of library:** every split line must have `padding-bottom: 0.18em` and `overflow: visible`. See `references/descender-safety.md`.

---

### Capability: Component-Level Animation

**Goal:** Declarative, state-driven animation for individual React components — mount/unmount sequences, layout position transitions, and in-place state changes that do not require scroll orchestration.

**Selection criteria:**
1. React-native API that integrates with component lifecycle — not imperative DOM manipulation
2. Handles exit animations on unmount (components must animate out before being removed from the DOM)
3. Layout animation support — elements that change position animate smoothly without manual delta calculation
4. Declarative syntax driven by component state, not manual `.play()` calls

**Current recommended:** Framer Motion (`motion.div`, `AnimatePresence`, `layout` prop). Integrates naturally with TanStack Start's React tree.

**Use GSAP instead when:** the animation requires scroll orchestration, multi-component choreography on a shared timeline, or scrub-based precision. GSAP and Framer Motion can coexist in the same project — let each own its domain. Do not use both to animate the same element.

---

### Capability: Page Transitions

**Goal:** Animated route changes where the leaving page exits with purpose and the entering page arrives with intention. No hard cuts between routes.

**Selection criteria:**
1. Integrates with TanStack Router's navigation lifecycle hooks
2. Supports both enter and exit sequencing — leaving page animates before the route actually changes
3. Handles scroll position reset and ScrollTrigger instance cleanup on every route change
4. Supports route-specific variants — not every route needs the same transition

**Current recommended:** GSAP + TanStack Router hooks for complex sequences; CSS View Transitions API (`defaultViewTransition: true` in router config) for simple fades at zero JS cost. See `references/page-transitions.md` for full patterns including clip-path wipes and shared-element morphs.

**Critical integration requirement:** Smooth scroll, scroll triggers, and animation contexts must be destroyed/reverted on every route change. Orphaned instances across navigations are the most common source of bugs and memory leaks at this tier.

**Performance targets:**
- FCP: < 1.2s | LCP: < 1.8s | CLS: < 0.05 | INP: < 100ms | JS budget: < 120KB (gzip)

---

## Tier 2.5: Light 3D Enhancement

**Goal:** Three-dimensional spatial depth in specific overlay zones defined by the animation map. Use this tier only when the Invention Gate produced a metaphor that explicitly requires three-dimensional space.

**Selection criteria (all paths):**
1. Fits within the 150KB total JS budget
2. Mobile fallback defined before any 3D code is written — touch devices receive a full-quality 2D fallback. Detect via `matchMedia('(pointer: coarse)')`.
3. Full cleanup and disposal on route change — no GPU memory leaks between navigations

**Choose the path that matches the scene's spatial requirement:**

**Path A: CSS 3D** — `perspective`, `transform-style: preserve-3d`, z-depth layering. Zero additional bundle cost. Use when the spatial effect is achievable with CSS transforms.

**Path B: Single WebGL mesh** — One scene, one mesh, one purpose. React Three Fiber (R3F) for a React-integrated scene graph; Raw WebGL for a shader-only effect with no scene graph. Lazy-init after LCP — never block initial render on WebGL initialization.

**Path C: CSS perspective grid** — Entire layout in 3D space, camera movement driven by scroll. Use when the metaphor requires navigating through space rather than viewing a 3D object.

**Performance targets:**
- CSS 3D (Path A): Same as Tier 2
- WebGL mesh (Path B): LCP < 1.8s — WebGL must lazy-init after first paint, never before LCP | < 150KB total JS

---

## Tier 3: Full WebGL/GPU

**Goal:** GPU-rendered scenes, generative art, particle systems, and custom GLSL shaders as defined by the animation map.

**Selection criteria:**
1. React component tree integration — lifecycle-aware initialization and cleanup within TanStack Start's React tree
2. Full GPU pipeline access — geometry, materials, and custom shader support
3. Disposal API — `geometry.dispose()`, `material.dispose()`, `renderer.dispose()` — all must be called on route change
4. Actively maintained — verify last release date via Context7 before committing to any library
5. Fits within 300KB budget with code-splitting; lazy-load via `React.lazy` + `Suspense`

**Current options by scene type — use Context7 to verify current state before choosing:**

- **React Three Fiber (R3F):** React-native scene graph built on Three.js. Recommended default for TanStack Start — lifecycle integration is natural, the Three.js ecosystem is accessible, and disposal patterns are well-established.
- **Raw WebGL:** Maximum GPU performance for custom shaders when no scene graph is needed. Direct pipeline control. Use when the animation map specifies a single shader effect with no geometry management.
- **Babylon.js:** Complex scene graphs with built-in physics, advanced lighting, and animation system. Evaluate when scene complexity exceeds R3F's ergonomics.
- **WebGPU:** Compute shaders and GPU simulation. Evaluate when the animation map explicitly requires compute-heavy work that WebGL cannot achieve. Always provide a WebGL 2.0 fallback — WebGPU availability is not universal.

**Mobile rule:** Reduce particle count and shader complexity on mobile. Detect WebGL 2.0 support; fall back to static gradient or CSS animation if unavailable.

**Performance targets:**
- LCP: < 1.8s — shader compilation must happen after first paint, never before LCP | CLS: < 0.05 | INP: < 100ms | JS budget: < 300KB (code-split aggressively via `React.lazy` + `Suspense`)

---

## Core Web Vitals (All Tiers)

These are outcomes — achieve them regardless of which libraries are used. Awwwards targets: **LCP < 1.8s | CLS < 0.05 | INP < 100ms | FCP < 1.2s**. See `awwwards-performance-standards` for full optimization techniques.

**FCP:** Inline critical CSS for above-fold content. Preload custom fonts with `font-display: swap`.

**LCP:** Preload the hero image with `fetchpriority="high"`. Use responsive `<picture>` with AVIF/WebP. Never lazy-load the LCP element. WebGL and 3D scenes must initialize after LCP, never before.

**CLS:** Set explicit `width`/`height` or `aspect-ratio` on all images. Reserve space for dynamic content before it loads. Use `font-display: swap` with `size-adjust` to prevent layout shift from font swap.

**INP:** Batch DOM updates inside `requestAnimationFrame`. Debounce scroll/resize handlers. Never perform synchronous reflow in event listeners. Break long tasks (>50ms) with `setTimeout(r, 0)` yields.

---

## Researching Beyond This List

When the animation map requires a capability not documented here, or when you believe a tool not listed may be the best choice for a given scenario:

1. **Define the capability goal and constraints first** — what must it achieve? What are the bundle budget, browser support floor, and React/TanStack integration requirements?

2. **Use Context7 to research current tools** in this capability space before writing any code.

3. **Evaluate each candidate against:**
   - Does it fully achieve the capability goal?
   - Bundle fits the tier budget?
   - Integrates with React and TanStack Start's component lifecycle?
   - Actively maintained — check last release date?
   - Has a cleanup/disposal API suitable for route changes?
   - Browser support adequate for the target audience?

4. **Choose the tool that best satisfies the criteria.** Add a one-line comment at the integration point explaining why it was selected over the documented default.

5. **If no clear winner emerges:** default to the documented recommendation. A proven tool with known integration patterns is preferable to a cutting-edge alternative with unknown production behavior at the Awwwards ceiling.
