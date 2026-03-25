# Enhancement Layer: Tier-Based Implementation Guide

This file defines what the Enhancement Layer must achieve at each tier. Tool choices are the agent's decision — select based on animation map requirements, bundle budget, and what best serves the project. Use Context7 to fetch current API docs for every library you choose before writing integration code.

The agent does NOT scaffold the project from scratch. The agent ENHANCES the Stitch-generated output.

---

## How to Choose a Tier

The tier was established in Phase 1 (Brief Interview) and confirmed in the animation map. It defines the ceiling of animation complexity and the performance budget. Build from the tier up — do not implement Tier 3 capabilities if the animation map does not demand them.

| Tier | What it achieves | JS budget (gzip) |
|------|-----------------|-----------------|
| **1** | CSS-only animations and transitions | < 20KB |
| **2** | Scroll-triggered reveals, smooth scroll, animated text, page transitions | < 120KB |
| **2.5** | Everything in Tier 2 + three-dimensional spatial elements in specific zones | < 150KB |
| **3** | Everything in Tier 2 + full GPU-rendered scenes, generative art, GLSL shaders | < 300KB |

---

## Tier 1: CSS-Primary Enhancement

No JS animation library needed. CSS alone can achieve scroll-driven animations, entrance sequences, and view transitions.

**What the Enhancement Layer must achieve:**
- Scroll-driven animations (reveals, parallax, sticky effects) via `animation-timeline: scroll()`
- Entrance animations via CSS `@starting-style` and `transition`
- Page transition feel via CSS View Transitions API (`@view-transition`, `::view-transition-*`)
- Font loading optimized (`font-display: swap`, preload critical fonts)
- Responsive image strategy (AVIF/WebP with `<picture>`, `fetchpriority="high"` on LCP)

**Performance targets:**
- FCP: < 1.0s | LCP: < 2.5s | CLS: < 0.1 | JS budget: < 20KB

---

## Tier 2: JS-Enhanced Animation

Sophisticated scroll orchestration, smooth scroll, animated text reveals, and choreographed page transitions. Choose the right tool for each concern.

**What the Enhancement Layer must achieve:**

**Scroll-triggered animation:**
Sections reveal, pin, and animate as the user scrolls. Choose based on complexity:
- CSS scroll-driven animations (`animation-timeline: scroll()`) — zero bundle cost, sufficient for simple reveals
- Intersection Observer + CSS classes — lightweight, performant for fade-ins
- A JS animation library (GSAP + ScrollTrigger is the most capable option for complex sequencing) — use when the animation map requires precise timing, scrub-based animations, or multi-element choreography

**Smooth scroll:**
If the animation map specifies smooth scroll behavior, implement momentum-based scrolling. Lenis is the preferred library. Any implementation must not intercept native touch scroll momentum (`smoothTouch: false` on Lenis; equivalent on other libraries). If the animation map does not require smooth scroll, native browser scroll is always acceptable.

**Animated text:**
For character-level or word-level text animation, a text-splitting library is needed. SplitType is the most capable option for DOM-based splitting with GSAP. Implement descender safety on all split text targets — see `references/descender-safety.md`.

**Page transitions:**
Implement animated route transitions in `__root.tsx`. Choose approach based on animation complexity:
- CSS View Transitions API — zero JS, sufficient for fades and simple slides
- JS library integration with TanStack Router hooks — for clip-path wipes, shared-element morphs, choreographed sequences
See `references/page-transitions.md` for implementation patterns.

**Critical integration requirement:** Smooth scroll, scroll triggers, and animation contexts must be properly destroyed/reverted on every route change. Memory leaks from orphaned instances are the most common bug at this tier.

**Performance targets:**
- FCP: < 1.2s | LCP: < 2.5s | CLS: < 0.1 | INP: < 200ms | JS budget: < 120KB (gzip)

---

## Tier 2.5: Light 3D Enhancement

Everything from Tier 2 plus three-dimensional spatial depth in specific overlay zones from the animation map. Use this tier only when the Invention Gate produced a metaphor that explicitly requires three-dimensional space. Do not use if the metaphors are flat (ink, fabric, print, surface).

**What the Enhancement Layer must achieve:**
Implement the 3D overlay zones specified in the animation map. Choose the approach that matches the scene complexity:

- **Path A: CSS 3D** — `perspective`, `transform-style: preserve-3d`, z-depth layering. Zero additional bundle cost. Use when the spatial effect can be achieved with CSS transforms.
- **Path B: Single WebGL mesh** — One scene, one mesh, one purpose. Hero focal moment only. Three.js is the proven default; React Three Fiber (R3F) integrates cleanly into TanStack Start's React tree. Use when the scene requires GPU rendering but doesn't justify a full 3D environment.
- **Path C: CSS perspective grid** — Entire layout in 3D space, animation-driven camera on scroll. Use when the brand metaphor requires navigating through space.

**Mobile rule:** Define the mobile fallback before writing 3D code. Touch devices must receive a full-quality fallback (hide canvas, show Stitch design). Detect touch via `matchMedia('(pointer: coarse)')`.

**Performance targets:**
- CSS 3D (Path A): Same as Tier 2
- WebGL mesh (Path B): FCP < 1.3s — do NOT block render on WebGL init; lazy-init after LCP | < 150KB total JS

---

## Tier 3: Full WebGL/GPU

Everything from Tier 2 plus GPU-rendered scenes, generative art, particle systems, and custom GLSL shaders as specified in the animation map.

**What the Enhancement Layer must achieve:**
Implement the WebGL scenes specified in the animation map. Scene requirements determine the renderer:

- **Three.js / React Three Fiber** — Proven default for web WebGL. R3F is recommended for TanStack Start due to native React integration. Lazy-load via `React.lazy` + `Suspense` to avoid blocking initial render.
- **Raw WebGL** — Maximum performance for custom shaders when a full scene graph isn't needed.
- **Babylon.js** — Consider for complex scene graphs with built-in physics and advanced lighting.
- **WebGPU** — For compute-heavy simulations. Always provide a WebGL 2.0 fallback — WebGPU support is limited.

Choose based on what the animation map specifies. Do not over-engineer — if the scene needs one particle system, Three.js is sufficient. If it needs GPU compute, evaluate WebGPU with WebGL fallback.

**Mobile rule:** Awwwards judges test on phones. Reduce particle count and shader complexity on mobile. Detect WebGL 2.0 support; fall back to static gradient or CSS animation.

**Performance targets:**
- FCP: < 1.5s (higher due to shader compilation) | LCP: < 3.0s | CLS: < 0.1 | JS budget: < 300KB (code-split aggressively)

---

## Core Web Vitals (All Tiers)

These are outcomes — achieve them regardless of which libraries are used.

**FCP:** Inline critical CSS for above-fold content. Preload custom fonts with `font-display: swap`.

**LCP:** Preload the hero image with `fetchpriority="high"`. Use responsive `<picture>` with AVIF/WebP. Never lazy-load the LCP element.

**CLS:** Set explicit `width`/`height` or `aspect-ratio` on all images. Reserve space for dynamic content before it loads.

**INP:** Batch DOM updates inside `requestAnimationFrame`. Debounce scroll/resize handlers. Never perform synchronous reflow in event listeners.
