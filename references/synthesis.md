# Synthesis: From Invention to Execution

---

## The Engine: How Every Awwwards Site Is Actually Built

Before any design decision, understand the system every award-winning site runs on. This is not optional architecture — it is the foundation.

```
Lenis (scroll input)
  ↓
gsap.ticker.add() (single unified timing loop)
  ↓
Multiple synchronized outputs:
  - DOM transforms (CSS custom properties)
  - GSAP animations (ScrollTrigger, quickTo)
  - Three.js uniforms (if Tier 2.5/3)
  - Typography state (variable font axes)
```

**One timing source. Multiple outputs. Always.**

Scroll is never a trigger. It is a progress value (0–1) that drives a timeline. The difference between a site that feels premium and one that feels built is whether scroll *triggers events* or *drives continuous state*.

### The Three Laws of the Timing Loop

**Law 1: Everything runs off `gsap.ticker`**
```typescript
// CORRECT — single source of truth
gsap.ticker.add((time) => {
  lenis.raf(time * 1000)
  // All scroll-dependent logic reads from lenis.scroll here
})
gsap.ticker.lagSmoothing(0)
```

**Law 2: Smoothing uses lerp, not easing functions**
```typescript
// lerp factor IS the brand feel
// 0.03–0.06 = glacial, meditative (sake brewery, monastery)
// 0.08–0.12 = fluid, confident (architecture, fashion)
// 0.15–0.25 = responsive, energetic (agency, tech startup)
// 0.4–0.6  = direct, no-nonsense (brutalist, utilitarian)
const lerp = (a: number, b: number, n: number) => a + (b - a) * n
current = lerp(current, target, brandLerpFactor)
```

**Law 3: State machines, not triggers**

Every element lives at a value between 0 and 1 at all times. Nothing appears. Nothing disappears. Everything transitions.

```typescript
// WRONG — event-based thinking
onScroll(() => { element.classList.add('visible') })

// CORRECT — state-based thinking
const progress = scrollY / totalHeight  // always 0–1
element.style.opacity = smoothstep(0.2, 0.4, progress).toString()
```

---

## Translation: INVENTION.md → System Decisions

Your INVENTION.md has three outputs: paradigm, metaphor, twist. Each paradigm has a specific system shape. Map yours here.

### Paradigm: Scroll

**System shape:**
```
ScrollProgress (0–1)
  ↓
Phase Map (divide into 3–5 phases)
  ↓
Per-phase GSAP timeline (scrub: 1)
  ↓
CSS custom properties update per frame
```

**Phase mapping principle:**
Divide your scroll journey into acts. Each act has a job in the brand narrative. The ratios are not aesthetic — they are calculated from what each act needs to communicate.

```
[0.00 → 0.30] ACT 1: Establish. Brand identity, first impression, emotional trigger.
[0.30 → 0.65] ACT 2: Demonstrate. The signature interaction at full expression.
[0.65 → 0.85] ACT 3: Deepen. Substance, proof, content that earns trust.
[0.85 → 1.00] ACT 4: Convert. Action, clarity, what the user does next.
```

Kōen Knives example: 0–0.25 = raw steel (heavy type weight, rough grain), 0.25–0.65 = forging stages (hour counter advances, type refines), 0.65–0.90 = finished edge (light weight, smooth), 0.90–1.0 = the knife / CTA.

**ScrollTrigger setup for phased scroll:**
```typescript
const phases = [
  { start: 0, end: 0.30, timeline: act1Timeline() },
  { start: 0.30, end: 0.65, timeline: act2Timeline() },
  // ...
]

ScrollTrigger.create({
  trigger: 'body',
  start: 'top top',
  end: 'bottom bottom',
  scrub: 1,
  onUpdate: (self) => {
    const p = self.progress
    phases.forEach(phase => {
      const localProgress = clamp((p - phase.start) / (phase.end - phase.start), 0, 1)
      phase.timeline.progress(localProgress)
    })
  }
})
```

---

### Paradigm: Cursor

**System shape:**
```
Mouse position (raw)
  ↓
lerp smoothing (lerp factor = brand feel)
  ↓
quickTo animations (pre-created, never recreated)
  ↓
Optional: trail canvas / proximity field / WebGL uniform
```

**The cursor lag IS the brand personality:**
```typescript
// Precision instrument (knife maker, watchmaker, surgical)
const lagFactor = 0.12  // follows closely, controlled

// Fluid/organic (dance company, fashion, living brand)
const lagFactor = 0.04  // long trail, body-like lag

// Energetic/responsive (agency, tech, interactive art)
const lagFactor = 0.20  // quick, decisive
```

**Always use `quickTo` — never `gsap.to()` on mousemove:**
```typescript
const xTo = gsap.quickTo(cursor, 'x', { duration: 0.4, ease: brandEase })
const yTo = gsap.quickTo(cursor, 'y', { duration: 0.4, ease: brandEase })

window.addEventListener('mousemove', (e) => {
  xTo(e.clientX)
  yTo(e.clientY)
})
```

---

### Paradigm: Loading/Reveal

**System shape:**
```
Resource load progress (0–1) — NOT arbitrary timing
  ↓
Single progress value drives reveal state
  ↓
Reveal has skip option at 4-second mark
  ↓
On complete: transition to main content (no full page reload)
```

**Resource-tied loading (not setTimeout):**
```typescript
const resources = [
  fetch('/api/data'),
  new Promise(resolve => { img.onload = resolve }),
  // ...
]

let loaded = 0
resources.forEach(r => r.then(() => {
  loaded++
  const progress = loaded / resources.length
  updateRevealProgress(progress)  // drives the animation
}))
```

---

### Paradigm: Hover

**System shape:**
```
Pointer proximity (0 = far, 1 = on element)
  ↓
lerp smoothing (hover feel)
  ↓
CSS custom properties or GSAP quickTo
  ↓
Touch fallback: tap reveals same information
```

**Proximity field (not just on/off hover):**
```typescript
const getProximity = (el: Element, mouse: {x: number, y: number}) => {
  const rect = el.getBoundingClientRect()
  const cx = rect.left + rect.width / 2
  const cy = rect.top + rect.height / 2
  const dist = Math.hypot(mouse.x - cx, mouse.y - cy)
  const maxDist = Math.max(rect.width, rect.height)
  return clamp(1 - dist / maxDist, 0, 1)
}
```

---

### Paradigm: Typography

**System shape:**
```
Scroll velocity or position (raw)
  ↓
Normalized value (0–1)
  ↓
font-variation-settings axes via CSS custom property
  ↓
GSAP ticker drives update per frame
```

**Variable font axis mapping:**
```typescript
gsap.ticker.add(() => {
  const velocity = lenis.velocity  // lenis exposes this
  const normalizedVelocity = clamp(Math.abs(velocity) / maxExpectedVelocity, 0, 1)

  // Map velocity to font axes — derived from brand metaphor
  const weight = lerp(300, 900, normalizedVelocity)  // slow = light, fast = heavy
  const width = lerp(75, 125, normalizedVelocity)     // slow = condensed, fast = wide

  document.documentElement.style.setProperty(
    '--font-variation',
    `'wght' ${weight}, 'wdth' ${width}`
  )
})
```

---

### Paradigm: Layout

**System shape:**
```
Scroll position or user action
  ↓
GSAP Flip captures state before change
  ↓
DOM restructures (CSS Grid variables update)
  ↓
Flip animates from old state to new state
  ↓
Optional: CSS 3D z-depth for stratigraphy/layering
```

**Flip pattern:**
```typescript
const transitionLayout = (newConfig: string) => {
  const state = Flip.getState(items)  // capture BEFORE change

  container.dataset.layout = newConfig  // trigger CSS Grid change

  Flip.from(state, {
    duration: 0.8,
    ease: brandEase,
    stagger: { amount: 0.2, from: 'random' },
    onComplete: () => { /* unlock interaction */ }
  })
}
```

---

## The Hero: First 3 Seconds

Awwwards judges see thousands of sites. The hero decides in 3 seconds whether they keep watching.

**What must happen in 3 seconds:**
1. The brand's emotional trigger must be communicated — not stated, *felt*
2. The signature interaction must be hinted or demonstrated
3. Visual hierarchy must be unmistakable at a glance

**The hero is not a section — it is an argument:**

| Second | Job | How |
|--------|-----|-----|
| 0–0.5 | Orient | Brand name visible, interaction starts |
| 0.5–1.5 | Intrigue | Something unexpected happens — the twist reveals itself |
| 1.5–3.0 | Earn | User understands the brand's essential nature |
| 3.0+ | Reward | Scroll/interact to go deeper |

**Hero structure derived from paradigm:**

- **Scroll hero:** Full-viewport. First scroll trigger is immediate. The signature interaction begins the moment scroll begins — not after a loading sequence.
- **Cursor hero:** The cursor interaction IS the hero. No large hero image. The expressive cursor space IS the content.
- **Loading hero:** The loading IS the brand experience. Keep under 4 seconds. Skip at 4 seconds.
- **Hover hero:** Content exists in an unresolved state before hover. First hover IS the first impression.
- **Typography hero:** The headline IS the interaction. Variable font, SplitType, or kinetic type as the primary visual.
- **Layout hero:** The layout assembles in front of the user. The structure reveals itself within 2 seconds.

---

## Easing as Brand Voice

Easing is not a technical setting. It is the brand's physical personality expressed through motion.

**Derive your easing from Metaphor 1 (physical sensation):**

| Physical sensation | Easing characteristic | cubic-bezier |
|-------------------|----------------------|--------------|
| Cold steel, precise | Sharp acceleration, no overshoot | `cubic-bezier(0.25, 0, 0, 1)` |
| Liquid, mercury | Gentle ease-in, long ease-out | `cubic-bezier(0.16, 1, 0.3, 1)` |
| Silk, tension | Quick start, controlled settle | `cubic-bezier(0.34, 1.56, 0.64, 1)` (slight overshoot) |
| Stone, geological | Very slow start, inevitable arrive | `cubic-bezier(0.76, 0, 0.24, 1)` |
| Organic, living | Ease that breathes, slight hesitation | `cubic-bezier(0.22, 1, 0.36, 1)` |
| Mechanical, engineered | Linear with micro ease | `cubic-bezier(0.4, 0, 0.6, 1)` |

**Name your ease — then use it everywhere:**
```css
:root {
  /* Named from brand metaphor, not from library defaults */
  --ease-brand: cubic-bezier(0.25, 0, 0, 1);  /* Kōen: cold steel precision */
}
```

```typescript
// All animations use the same brand ease
const brandEase = 'cubic-bezier(0.25, 0, 0, 1)'
gsap.to(element, { y: 0, ease: brandEase })
// NOT: ease: 'power2.out' — that is a default, not a decision
```

---

## Buffer Space: The Invisible Detail

Every premium interaction has buffer space — room to move into before hitting edges.

**CSS buffer (DOM-based interactions):**
```css
.parallax-image {
  width: 115%;        /* 7.5% buffer each side */
  margin-left: -7.5%;
  height: 115%;
  margin-top: -7.5%;
}
```

**Shader buffer (WebGL interactions):**
```glsl
// Scale UV to 85% — creates 15% movement room
vec2 uv = (vUv - 0.5) * 0.85 + 0.5;
uv += parallaxOffset;  // now has room to shift without clipping
```

Build the buffer into the initial dimensions — never try to constrain within bounds after the fact.

---

## Performance: What Separates 60fps from Jank

**Always:**
- `gsap.ticker.lagSmoothing(0)` — prevents GSAP from compensating for dropped frames by skipping ahead
- `gsap.quickTo()` for mousemove handlers — pre-created tweens, never recreated
- `will-change: transform` on animated elements — promote to compositor layer
- CSS custom properties for JS-driven values — one restyle, not per-element DOM writes

**Never:**
- `getBoundingClientRect()` inside animation loops — cache it, update on resize
- `gsap.to()` inside mousemove or scroll events — use quickTo
- `transition: all` — specificity matters, animate only what changes
- Animating `top`, `left`, `width`, `height` — animate `transform` and `opacity` only

---

## Synthesis Checklist

Before building any page, derive each answer from INVENTION.md — not from defaults:

- [ ] Lerp factor chosen and traced to brand emotional trigger (Metaphor 3)
- [ ] Brand easing curve named, derived from physical metaphor (Metaphor 1), used consistently
- [ ] Scroll paradigm: phase ratios calculated with narrative justification for each ratio
- [ ] Cursor paradigm: lag factor derived from brand personality, quickTo implemented
- [ ] Hero structure maps to paradigm — first 3 seconds planned specifically
- [ ] Buffer space built into all animated elements (CSS or shader)
- [ ] All animations run off single gsap.ticker — no parallel timing sources
- [ ] State machine thinking — nothing appears/disappears, everything transitions 0→1
