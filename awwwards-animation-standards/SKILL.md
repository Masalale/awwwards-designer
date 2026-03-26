---
name: awwwards-animation-standards
description: >
  Animation implementation standards for the awwwards-designer workflow. Contains
  easing vocabulary, tier-based animation matrix, GPU-only animation rules, timing
  references, and code patterns for scroll-triggered reveals, text animation, smooth
  scroll, and page transitions. Consulted during Phase 4 (Enhancement Layer) when
  implementing the animation map, and during Phase 5 (Quality Gate) when auditing
  the animation layer. Easing defaults in this skill yield to animation direction
  in DESIGN.md and to the project-specific easings defined in the Invention Gate
  animation map.
---

# Awwwards Animation Standards

> **Priority order for animation decisions:**
> 1. **DESIGN.md** — If Stitch's `extract_design_context` output specifies animation direction, tone, or style, that is the authority. Implement it.
> 2. **Animation map** — The project-specific easings and motion language defined during the Invention Gate take precedence over the defaults in this skill.
> 3. **This skill** — Use the easing vocabulary, timing sheet, and patterns here as defaults and reference when the above two sources leave gaps.

The animation layer is not decoration. It's the difference between a site that _works_
and one that _wows_. Every Antigravity build must pass this bar.

---

## Animation Philosophy: 3 Pillars

### 1. Intentionality
Every animation has a reason. It reveals hierarchy, guides attention, or confirms
interaction. Animations that exist "just because" dilute the craft. If you can't
state the purpose of an animation in one sentence, remove it.

### 2. Narrative Coherence
Animations tell a story. The page enters with purpose, content reveals in a logical
sequence, and interactions feel like natural cause-and-effect. Transitions connect
contexts, not sever them. The user should feel the site is _alive_, not glitchy.

### 3. Performance Integrity
Premium feel requires 60fps. Jank, stutter, or layout shift disqualifies any
animation, no matter how creative. GPU-accelerated only. Main thread blocking is
a hard failure. `prefers-reduced-motion` is non-negotiable.

---

## Animation Complexity Matrix

> **Note:** This matrix describes per-interaction implementation complexity — not the project-level tier from the `awwwards-designer` workflow. A single Tier 2 project (designer tier) typically contains all four complexity levels simultaneously: CSS micro-interactions on buttons, scroll reveals on sections, pinned galleries, and page transitions.

| Level | Type | Approach | Duration | Complexity | When to Use |
|-------|------|----------|----------|------------|-------------|
| **CSS** | Micro-interactions | CSS `transition` + `animation` | 0.15–0.4s | Low | Hover states, button feedback, toggles, form focus |
| **JS-Scroll** | Scroll-triggered reveals | JS animation library + scroll observer | 0.5–1.2s | Medium | Section reveals, staggered content, parallax backgrounds |
| **JS-Advanced** | Scroll + interaction combos | JS animation library + momentum scroll | 0.4–1.5s | Medium-High | Horizontal scroll galleries, pinned sections, parallax layers |
| **JS-Transitions** | Page transitions | JS animation library + TanStack Router hooks | 0.4–0.8s per phase | High | Multi-page sites where transition quality defines the experience |

**Library selection by level:**
- CSS: No library needed
- JS-Scroll / JS-Advanced: GSAP + ScrollTrigger (scroll orchestration, multi-element choreography)
- JS-Transitions: GSAP + TanStack Router hooks, or CSS View Transitions API (zero JS, simpler sequences)
- Component state animations (mount/unmount, layout shifts): Framer Motion — see `awwwards-designer/references/tech-stack.md` for the GSAP vs Framer Motion domain boundary

---

## Easing Selection: The 3 Easings

Define these as your core easing vocabulary. Map them to brand curves.

### `ease-primary` — The workhorse
For most reveals and interactions. Sharp attack, smooth landing.
```
CSS:  cubic-bezier(0.16, 1, 0.3, 1)
GSAP: power4.out
Framer: spring({ stiffness: 300, damping: 30 })
```
**Use for:** Section reveals, card entrances, modal open, menu items

### `ease-reveal` — The dramatic opener
For hero reveals and high-impact moments. Slow start, explosive exit.
```
CSS:  cubic-bezier(0.22, 1, 0.36, 1)
GSAP: power3.out
Framer: spring({ stiffness: 200, damping: 25 })
```
**Use for:** Hero headline reveal, full-page load sequence, circular reveal

### `ease-transition` — The connector
For page transitions and context shifts. Fluid, no drama.
```
CSS:  cubic-bezier(0.65, 0, 0.35, 1)
GSAP: power2.inOut
Framer: spring({ stiffness: 400, damping: 35 })
```
**Use for:** Page transitions, horizontal wipes, clip-path reveals

### Brand → Curve Mapping Guide
```
Bold/Assertive brand:     power4.out / cubic-bezier(0.16, 1, 0.3, 1)
Elegant/Luxury brand:     power3.out / cubic-bezier(0.22, 1, 0.36, 1)
Playful/Creative brand:  back.out / cubic-bezier(0.34, 1.56, 0.64, 1)
Tech/SaaS brand:          power2.out / cubic-bezier(0.25, 1, 0.5, 1)
Minimal/Quiet brand:     power1.out / cubic-bezier(0.25, 0, 0.5, 1)
```
**Never use linear easing for anything user-facing.** Linear = robotic = cheap.

---

## Hard Stops

These are non-negotiable. Violations are auto-fails in code review.

### Descender Safety (ALL display text > 48px)
```css
/* MUST be applied to any display/hero text */
.display-text {
  overflow: visible;
  padding-bottom: 0.18em; /* Minimum clearance — measure per font via Canvas API, see references/descender-safety.md */
}
```
**Why:** `clip-path` animations on text with descenders (g, y, p, q, j) will clip
the bottom of letters during animation. `overflow: visible` + bottom padding is
the fix. This affects every scroll reveal on display text.

### Smooth Scroll: Never Override Native Touch
The smooth scroll system (if used) must not intercept native touch scroll. Lenis is
the preferred library — if used, always set `smoothTouch: false`.

```js
// Lenis — the preferred smooth scroll implementation
const lenis = new Lenis({
  duration: 1.2,
  easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
  smoothTouch: false, // HARD STOP — true causes scroll jank on mobile
  touchMultiplier: 2,
});
```
**Why:** `smoothTouch: true` intercepts native scroll momentum and replaces it with
lerped scrolling. On mobile, this feels laggy and breaks pull-to-refresh. Any
smooth scroll library must apply the equivalent setting.

### GPU-Accelerated Properties Only
```
ALLOWED:  transform, opacity, filter (blur, brightness, contrast, hue-rotate), clip-path
FORBIDDEN: width, height, margin, padding, top, left, font-size, border-radius (animate via transform)
```
**Why:** Animating layout properties triggers reflow/repaint. Transform and opacity
go straight to the compositor. `will-change` sparingly — only on active animations.

### prefers-reduced-motion
```css
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```
```js
// In JS — check before initializing scroll-heavy animations
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
if (!prefersReducedMotion) {
  // Initialize scroll animations, parallax, etc.
}
```
**Why:** WCAG 2.1 Level AA requirement. Also, vestibular disorders. There's no excuse.

---

## Quick Reference

### Timing Cheat Sheet

| Context | Duration | Easing | Stagger |
|---------|----------|--------|---------|
| Hero reveal sequence | 0.8–1.2s | ease-reveal (power3.out) | 100–150ms per item |
| Section fade-up | 0.6–0.8s | ease-primary (power4.out) | 50–100ms per item |
| Scroll-triggered image | 0.8–1.0s | ease-primary | — |
| Micro-interaction (hover) | 0.2–0.4s | ease-primary | — |
| Button press | 0.1–0.2s | power4.in | — |
| Button release (elastic) | 0.3–0.5s | elastic.out | — |
| Page leave | 0.3–0.5s | ease-transition | — |
| Page enter | 0.5–0.8s | ease-primary | — |
| Clip-path wipe | 0.6–0.8s | ease-transition | — |
| Horizontal scroll scrub | scrub: 1 | — | — |
| Text char reveal | 0.04–0.08s/char | ease-reveal | 20–40ms stagger |
| Magnetic pull | 0.3–0.5s | ease-primary | — |

### Key Do's and Don'ts

**✅ DO:**
- Use scoped animation contexts (`gsap.context()` or library equivalent) for cleanup
- Kill scroll trigger instances and smooth scroll on unmount/page transition
- Sync the smooth scroll RAF loop with the animation library's tick cycle
- Stagger reveals to create visual rhythm (words, then images, then details)
- Use `autoAlpha` (opacity + visibility combined) instead of separate opacity tweens
- Add `will-change: transform` only during active animation, remove after
- Test on low-end Android device — if it janks, it's wrong

**❌ DON'T:**
- `transition: all` — ever, for any reason, in any file
- Animate `width`, `height`, `margin`, `top`, `left`, `font-size`
- Use `setInterval` or `setTimeout` for animation loops
- Chain `.then()` on ScrollTrigger callbacks — use `onComplete` instead
- Initialize multiple ScrollTrigger instances on the same element
- Forget to call `ScrollTrigger.refresh()` after DOM mutations

---

## Table of Contents

| Reference File | Read When... |
|----------------|-------------|
| `references/scroll-patterns.md` | Building scroll-triggered reveals, horizontal galleries, parallax, or need Lenis setup |
| `references/page-transitions.md` | Multi-page site, TanStack Router transitions, shared-element morphs, View Transitions API |
| `references/text-animation.md` | SplitType headlines, variable font animation, masked text reveals, descender safety |
| `references/micro-interactions.md` | Button arcs, magnetic buttons, custom cursor, hamburger → X, form feedback |
| `references/anti-patterns.md` | Code review, debugging jank, or when something "feels off" in the animation layer |

---

## Examples: Same Pattern, Three Tools

### Pattern: Fade-up reveal on scroll

**GSAP + ScrollTrigger:**
```js
gsap.from('.section-title', {
  y: 60,
  opacity: 0,
  duration: 0.8,
  ease: 'power4.out',
  scrollTrigger: {
    trigger: '.section-title',
    start: 'top 85%',
    toggleActions: 'play none none reverse',
  },
});
```

**CSS (Tier 1 equivalent):**
```css
.section-title {
  opacity: 0;
  transform: translateY(40px);
  transition: opacity 0.6s cubic-bezier(0.16, 1, 0.3, 1),
              transform 0.6s cubic-bezier(0.16, 1, 0.3, 1);
}

.section-title.is-visible {
  opacity: 1;
  transform: translateY(0);
}
```

**Framer Motion:**
```tsx
const variants = {
  hidden: { y: 60, opacity: 0 },
  visible: {
    y: 0,
    opacity: 1,
    transition: { duration: 0.8, ease: [0.16, 1, 0.3, 1] },
  },
};

<motion.div
  initial="hidden"
  whileInView="visible"
  viewport={{ once: true, margin: '-15%' }}
  variants={variants}
>
  <h2 className="section-title">Revealed on scroll</h2>
</motion.div>
```

### Pattern: Page transition clip-path wipe

**GSAP + TanStack Router:**
```js
// In __root.tsx useLayoutEffect — leave then enter
// Leave: called in useAnimatedNavigation hook before navigation
gsap.to('#page-container', {
  clipPath: 'inset(0 0 100% 0)',
  duration: 0.5,
  ease: 'power2.inOut',
});

// Enter: called in root layout after route change
gsap.from('#page-container', {
  clipPath: 'inset(0 0 100% 0)',
  duration: 0.6,
  ease: 'power4.out',
  clearProps: 'clipPath',
});
```

**CSS View Transitions API:**
```css
@keyframes slide-from-right {
  from { transform: translateX(100%); }
}
@keyframes slide-to-left {
  to { transform: translateX(-100%); }
}

::view-transition-old(root) {
  animation: 400ms cubic-bezier(0.65, 0, 0.35, 1) both slide-to-left;
}
::view-transition-new(root) {
  animation: 500ms cubic-bezier(0.16, 1, 0.3, 1) both slide-from-right;
}
```

---

## Skill Quality Gates

Before shipping any animation work:

1. **Performance:** Lighthouse Performance score ≥ 90 with animations active
2. **Reduced Motion:** Site is fully usable with `prefers-reduced-motion: reduce`
3. **Descender Safety:** All display text >48px has `overflow: visible` + `padding-bottom`
4. **Cleanup:** Scroll triggers and smooth scroll killed on unmount; no memory leaks after 10 page transitions
5. **Mobile:** No smoothTouch Lenis; no scroll-jank on 4G throttle in DevTools
6. **Easing:** Zero instances of `linear` or `transition: all` in source files
7. **Accessibility:** No animation lasts >5s without pause control (WCAG 2.3.3)
8. **Purpose:** Every animation can answer "what does this communicate?"

---

_This skill is the source of truth for animation decisions in Antigravity builds.
When in doubt, ask: "Does this animation earn its place?"_
