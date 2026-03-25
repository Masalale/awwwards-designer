# The 5 Technique Families: Tier-Based Interaction Patterns

Each technique family is an interaction/animation paradigm with three tiers of increasing complexity. Choose your tier based on project scope and technical confidence.

---

## Family 1: Cursor

The pointer itself becomes expressive. How the cursor moves, trails, responds to proximity, distorts, or changes based on context.

**Brand gate — answer before implementing any custom cursor:**
1. Can you write one sentence explaining why cursor behaviour is intrinsic to this brand's metaphor — not just "it looks good"?
2. Is the cursor doing something the native cursor cannot, in a way that advances the brand story?
3. If the cursor were removed, would the brand experience feel incomplete?

If you cannot answer YES to all three, use the native cursor. Most premium sites do — restraint is not a failure of craft.

### Tier 1: CSS Cursor Tracking with Variables & Calc

Custom cursor using CSS custom properties updated by JavaScript, no GSAP. A lightweight cursor element positioned via `--cursor-x` and `--cursor-y` custom properties on mousemove, with `calc()` for centering. Interactive elements trigger style changes (scale, background) via hover listeners.

Implementation: Use Context7 to fetch current API docs for CSS custom properties and `calc()`.

**Descender safety:** Not applicable (cursor is custom element, not text).

**Performance:** < 1kb JavaScript. Runs every mousemove. CSS animation fallback available for sub-16ms performance needs.

**Best for:** Subtle elegance, minimal interactivity, performance-critical sites.

---

### Tier 2: Dual-Element Cursor with GSAP & Magnetic Fields

Main cursor with fast response (0.2s), follower cursor with slow response (0.6s). Magnetic pull toward interactive elements. The main cursor snaps instantly to position; the follower lags behind with `power3.out` easing. Magnetic zones detect interactive elements within a 100px radius and apply proportional pull toward element center.

Implementation: Use Context7 to fetch current API docs for GSAP.

**Descender safety:** Not applicable (cursor is custom element).

**Performance:** ~3kb JavaScript. Consider `gsap.ticker.lagSmoothing(0)` if used with other scroll animations to prevent timing conflicts.

**Best for:** Interactive experiences, gallery sites, playful brands.

---

### Tier 3: WebGL Distortion Field with Cursor as Shader Uniform

Cursor position feeds into a GLSL shader as a uniform that distorts everything within a configurable radius. The fragment shader uses `smoothstep` to create falloff, displaces UVs toward/away from cursor position, and optionally adds color shifting near the cursor. Three.js renders the scene with the cursor-driven `ShaderMaterial`.

**How to reinvent:** Change the distortion function (swirl, ripple, pixel-sort), add cursor velocity as a second uniform, use multiple distortion layers, or pipe the effect through a post-processing pass.

Implementation: Use Context7 to fetch current API docs for Three.js and GLSL shaders.

**Descender safety:** Not applicable (WebGL scene, no DOM text).

**Performance:** ~50-100kb JavaScript (Three.js). CPU impact minimal if shader is optimized. GPU bound.

**Best for:** Tech companies, VFX-heavy experiences, cutting-edge signal.

---

## Family 2: Scroll

Content movement through time becomes the signature moment. How sections reveal, parallax, pin, animate.

### Tier 1: CSS Scroll-Driven Animations with Animation-Timeline

Pure CSS, no JavaScript animation library needed. Uses `animation-timeline: scroll()` and `animation-timeline: view()` with `animation-range` to drive keyframe animations from scroll position. Supports section reveals (fadeInUp), sticky parallax (background-position), text opacity transitions, and element rotation — all without JS.

Implementation: Use Context7 to fetch current API docs for CSS Scroll-Driven Animations (`animation-timeline`, `view()`).

**Browser support:** Chrome 115+, Safari 17.2+, Edge 115+. Fallback to static for older browsers via `@supports not (animation-timeline: scroll())`.

**Descender safety:** If animating text, ensure padding-bottom is applied to text elements before animation.

**Performance:** Native browser implementation. 60fps guaranteed if animation is GPU-accelerated (transform, opacity).

**Best for:** Performance-first sites, simple scroll narratives, mobile.

---

### Tier 2: Lenis + GSAP ScrollTrigger Sync Pattern

Smooth scroll library (Lenis) + GSAP ScrollTrigger for sophisticated orchestration. Lenis provides easeOutExpo smooth scrolling; ScrollTrigger pins sections, scrubs timelines, and triggers staggered reveals.

**Critical setup notes:**
- `gsap.ticker.add()` connects Lenis to GSAP's internal ticker (convert seconds to ms)
- `gsap.ticker.lagSmoothing(0)` prevents scroll delay artifacts
- In TanStack Start, wrap Lenis init in `useLayoutEffect` inside the root layout component
- Wrap animations in `gsap.context()` for cleanup
- Cleanup: `ctx.revert()`, kill all ScrollTrigger instances, `lenis.destroy()` on page navigation

**Descender safety:** If animating text with SplitType, add `padding-bottom: 0.18em` to every line wrapper. Use `overflow: visible` — never `clip` (clip ignores padding).

Implementation: Use Context7 to fetch current API docs for Lenis, GSAP, and ScrollTrigger.

**Bundle size:** ~40kb (Lenis + GSAP + ScrollTrigger)

**Performance:** 60fps on most devices. Test on mid-range mobile.

**Best for:** Premium experiences, narrative-driven sites, sophisticated scroll interactions.

---

### Tier 3: Scroll-Velocity Shaders

Scroll velocity drives a GLSL uniform, affecting shader calculations in real-time. The JavaScript layer calculates normalized velocity (0-1) from scroll delta, applies smooth decay when idle, and passes it to the fragment shader each frame. The shader uses velocity to distort UVs and shift color temperature (warm at rest, cool at speed — or inverted).

**How to reinvent:** Map velocity to different visual properties (blur, grain, displacement intensity), use velocity direction (up vs down) as a second uniform, or combine with cursor position for dual-input distortion.

Implementation: Use Context7 to fetch current API docs for Three.js and GLSL shaders.

**Descender safety:** Not applicable (WebGL scene).

**Performance:** GPU-bound. Requires WebGL 2.0.

**Best for:** Cutting-edge experiences, tech companies, VFX-heavy narratives.

---

## Family 3: Loading/Reveal

The first moment the user encounters the site (loading sequence, hero reveal) is the signature moment.

### Tier 1: CSS @starting-style + View Transitions

Native CSS for entrance animations without JavaScript. `@starting-style` defines initial state before render (opacity, transform, clip-path), and CSS transitions animate to the final state. `@view-transition` with `navigation: auto` handles page-level crossfades. Staggered children use `--child-index` custom property with `transition-delay: calc()`.

Implementation: Use Context7 to fetch current API docs for CSS `@starting-style` and View Transitions API.

**Browser support:** Chrome 119+, Safari 18+. Fallback to instant display for older browsers.

**Descender safety:** Hero h1 should have padding-bottom and overflow: visible (never clip).

**Performance:** 60fps. Native implementation.

**Best for:** Simple, elegant reveals. First-time visitors.

---

### Tier 2: SplitType + GSAP with Particle Assembly

Text characters appear one by one as particles assemble. SplitType splits the headline into individual characters. A GSAP timeline orchestrates: backdrop fade-in, characters animating from scaled-down/offset/rotated positions with random stagger order, subheading reveal, then CTA with elastic easing.

**Descender safety:** Critical. Every line from SplitType must have `padding-bottom: 0.18em` and `overflow: visible` (never clip).

Implementation: Use Context7 to fetch current API docs for GSAP and SplitType.

**Bundle size:** ~50kb (GSAP + SplitType)

**Performance:** 60fps. Consider reduced motion with `prefers-reduced-motion` query.

**Best for:** Premium landing pages, portfolio intros, storytelling.

---

### Tier 3: Matter.js Particle System with Physics

Particle assembly with gravity, collision, and natural motion. Characters spawn as physics bodies at screen center with random velocity, bounce off a floor body, then gravitationally settle into target text positions via per-frame force application. Restitution and friction create natural settling behavior.

**How to reinvent:** Change the physics model (zero gravity with spring constraints, magnetic fields, fluid simulation), vary particle shapes, add user interaction (click to explode/reassemble), or use the settling moment as a transition trigger.

Implementation: Use Context7 to fetch current API docs for Matter.js.

**Descender safety:** Not applicable (particle system, not DOM text).

**Bundle size:** ~50kb (Matter.js)

**Performance:** GPU-accelerated. May impact performance on low-end devices.

**Best for:** Cutting-edge reveals, tech companies, impressive first impression.

---

## Family 4: Hover

Engagement moments become the signature (what reveals on hover, focus, interaction).

### Tier 1: CSS Hover with Custom Properties & Transitions

Custom properties (`--scale`, `--color-shift`, `--shadow-blur`, `--gradient-x`) drive visual changes on `:hover`. Patterns include: scale + shadow + color shift on cards, gradient position animation on CTAs, center-out underline reveal via `::after` pseudo-element, and icon rotation.

Implementation: Use Context7 to fetch current API docs for CSS custom properties and transitions.

**Descender safety:** Not applicable (CSS transitions).

**Performance:** 60fps. GPU-accelerated (transform, opacity).

**Browser support:** All modern browsers.

**Best for:** Simple elegance, minimal overhead.

---

### Tier 2: GSAP FLIP with Magnetic Pull

Magnetic buttons: inner element follows mouse position within the button boundary with proportional offset (30% of distance), elastic snap-back on leave. FLIP layout transitions: capture First rect, change DOM state, capture Last rect, Invert with delta transform, Play with GSAP animation.

**How to reinvent:** Vary the magnetic pull curve (exponential vs linear), add rotation based on entry angle, combine FLIP with color/opacity morphs, or use magnetic pull on non-button elements (images, cards).

Implementation: Use Context7 to fetch current API docs for GSAP and GSAP Flip plugin.

**Descender safety:** Not applicable (no text animation).

**Bundle size:** ~40kb (GSAP)

**Performance:** 60fps if using transform animations only.

**Best for:** Interactive cards, CTA buttons, gallery experiences.

---

### Tier 3: Fragment Shader Distortion

Hover position drives fragment shader distortion. Mouse position (normalized 0-1) is passed as a uniform. The shader calculates distance from each fragment to the mouse, applies sinusoidal distortion inversely proportional to distance, and displaces UV sampling coordinates. The result is a ripple/warp effect centered on the cursor.

Implementation: Use Context7 to fetch current API docs for Three.js and GLSL shaders.

**Descender safety:** Not applicable (WebGL scene).

**Bundle size:** ~50kb (Three.js)

**Performance:** GPU-bound.

**Best for:** VFX galleries, cutting-edge experiences.

---

## Family 5: Typography

Text itself becomes the medium of expression.

### Tier 1: Variable Fonts Driven by Scroll Timeline

Pure CSS. Variable font axes (`wght`, `wdth`, `opsz`) animate via `font-variation-settings` keyframes tied to `animation-timeline: scroll()`. Weight morphs from 400 to 900 over scroll distance; width morphs from condensed to normal.

Implementation: Use Context7 to fetch current API docs for CSS variable fonts and scroll-driven animations.

**Browser support:** All modern browsers with variable font support.

**Descender safety:** Add padding-bottom and overflow: visible to display text (never clip).

**Performance:** Native, 60fps, no JavaScript.

**Best for:** Performance-first, elegant reveals.

---

### Tier 2: SplitType + Variable Fonts + GSAP

SplitType splits text into individual characters. GSAP animates each character's `font-variation-settings` independently — weight increases character by character based on position index. Color shifts stagger across characters with 50ms delay.

**Descender safety:** Mandatory for all display text. Every SplitType line must have `padding-bottom: 0.18em` and `overflow: visible`.

Implementation: Use Context7 to fetch current API docs for GSAP and SplitType.

**Bundle size:** ~50kb

**Performance:** 60fps if using font-variation-settings on transform/opacity timeline.

**Best for:** Editorial sites, premium landing pages.

---

### Tier 3: Canvas Text Rendering with Custom Rasterization

Text rendered to canvas, pixel data extracted, converted to particle system. Each opaque pixel becomes a particle with position and velocity. Particles can explode, reassemble, respond to cursor proximity, or morph between words. The canvas 2D context handles both the initial text rasterization and the per-frame particle rendering.

**How to reinvent:** Change particle behavior (fluid simulation, flocking, magnetic fields), vary particle shape/size, add WebGL for GPU-accelerated particles, or combine with audio reactivity.

Implementation: Use Context7 to fetch current API docs for Canvas 2D API.

**Descender safety:** Not applicable (canvas rendering, not DOM).

**Bundle size:** ~5kb (custom code only)

**Performance:** GPU-accelerated canvas rendering.

**Best for:** Experimental, eye-catching reveals, particle effects.

---

## Summary Table

| Family | Tier 1 | Tier 2 | Tier 3 |
|--------|--------|--------|--------|
| **Cursor** | CSS vars (1kb) | GSAP dual + magnetic (3kb) | WebGL distortion field (50-100kb) |
| **Scroll** | CSS animation-timeline (0kb) | Lenis + GSAP ScrollTrigger (40kb) | Scroll-velocity shaders (80kb) |
| **Loading** | CSS @starting-style (0kb) | SplitType + GSAP timeline (50kb) | Matter.js physics particles (50kb) |
| **Hover** | CSS transitions + custom props (1kb) | GSAP FLIP + magnetic buttons (40kb) | Fragment shader distortion (50kb) |
| **Typography** | Variable fonts + scroll (0kb) | SplitType + variable axes (50kb) | Canvas text rasterization (5kb) |

Each family, each tier, is production-ready. Choose based on brand ambition, timeline, and technical confidence.
