# Easing Language: Motion as Brand Voice

## What Easing Actually Controls

A cubic-bezier curve has four values: `(x1, y1, x2, y2)`.

- **x1, y1** — controls the *start* of the motion (departure from initial state)
- **x2, y2** — controls the *end* of the motion (arrival at final state)

```
cubic-bezier(x1, y1, x2, y2)
             ↑         ↑
         departure   arrival
```

---

## Deriving Your Curve from Metaphor 1

**Metaphor 1 (Physical Sensation)** is your source. The question: how does this texture move?

**Cold steel, precisely machined**
- Departure: immediate, no hesitation
- Arrival: crisp, no overshoot, no settle
- Curve: `cubic-bezier(0.25, 0, 0, 1)` — instant start, decisive stop
- Named: `--ease-precision`

**Liquid mercury, constantly shifting**
- Departure: gentle, gathering momentum
- Arrival: long, trailing, almost doesn't stop
- Curve: `cubic-bezier(0.16, 1, 0.3, 1)` — slow start, extended ease-out
- Named: `--ease-fluid`

**Silk pulled taut (slight tension)**
- Departure: quick
- Arrival: tiny overshoot, settles back
- Curve: `cubic-bezier(0.34, 1.56, 0.64, 1)` — spring-like, elastic arrival
- Named: `--ease-tension`

**Geological stone (inevitable, massive)**
- Departure: very slow, enormous weight
- Arrival: once it arrives, it has always been there
- Curve: `cubic-bezier(0.76, 0, 0.24, 1)` — extreme ease-in, minimal ease-out
- Named: `--ease-geological`

**Warm wood (handled thousands of times)**
- Departure: unhurried
- Arrival: soft, settled, comfortable
- Curve: `cubic-bezier(0.22, 1, 0.36, 1)` — organic, breathing motion
- Named: `--ease-organic`

**Oxidized copper (aged, patinated)**
- Departure: slight reluctance
- Arrival: gradual acceptance
- Curve: `cubic-bezier(0.45, 0.05, 0.55, 0.95)` — symmetrical, dignified
- Named: `--ease-patina`

**Frosted glass (seeing but not fully)**
- Departure: immediate
- Arrival: soft, slightly uncertain
- Curve: `cubic-bezier(0.2, 0, 0.8, 1)` — sharp start, gradual resolve
- Named: `--ease-translucent`

**Kinetic energy in stillness (dancer)**
- Departure: explosive
- Arrival: controlled deceleration
- Curve: `cubic-bezier(0.7, 0, 0.3, 1)` — fast start, careful landing
- Named: `--ease-kinetic`

---

## Implementation: Name the Curve, Use It Everywhere

```css
:root {
  /* Single brand ease — derived from Metaphor 1 */
  /* Name it for what it IS, not what it does */
  --ease-brand: cubic-bezier(0.25, 0, 0, 1);  /* e.g. "cold steel precision" */

  /* Functional variants — same personality, different duration contexts */
  --ease-micro: cubic-bezier(0.25, 0, 0, 1);    /* 150–200ms: state changes */
  --ease-standard: cubic-bezier(0.25, 0, 0, 1); /* 300–500ms: reveals */
  --ease-macro: cubic-bezier(0.25, 0, 0, 1);    /* 800–1200ms: page moments */
}
```

```typescript
// In JavaScript/TypeScript — the same curve as a GSAP ease
// Convert cubic-bezier to CustomEase once, use everywhere
import { CustomEase } from 'gsap/CustomEase'

const BRAND_EASE = CustomEase.create('brand', 'M0,0 C0.25,0 0,1 1,1')

// Every animation uses it
gsap.to(element, { y: 0, ease: BRAND_EASE })
gsap.to(cursor, { x: mouseX, ease: BRAND_EASE, duration: 0.4 })
```

**If you are using different eases for different animations without a documented reason, you are not using easing as brand voice — you are using easing as decoration.**

---

## Duration Relationships

Duration is as important as curve. They form a system.

**The duration ratio:** Pick a base duration. All other durations are multiples.

```css
:root {
  --dur-base: 400ms;     /* The heartbeat */
  --dur-micro: 150ms;    /* 0.375× — micro-interactions, state hints */
  --dur-fast: 250ms;     /* 0.625× — quick responses */
  --dur-standard: 400ms; /* 1× — standard reveals */
  --dur-slow: 700ms;     /* 1.75× — significant moments */
  --dur-macro: 1200ms;   /* 3× — hero events, major transitions */
}
```

**The base duration comes from the brand's tempo:**
- Brands about speed, energy, urgency: `--dur-base: 250ms`
- Brands about quality, craft, consideration: `--dur-base: 400ms`
- Brands about patience, time, ritual: `--dur-base: 600ms`

A sake brewery's base duration is not the same as a tech startup's. The tempo IS a design decision.

---

## Stagger: The Rhythm Between Elements

Stagger is not a convenience — it is the brand's sense of rhythm.

**Mechanical stagger** (all elements with identical delay):
```typescript
stagger: 0.05  // robotic, grid-like, systematic
```

**Organic stagger** (variable delays):
```typescript
stagger: {
  amount: 0.4,        // total time across all elements
  from: 'random',     // chaotic, natural
  ease: 'power2.in'  // acceleration through the stagger
}
```

**Anatomical stagger** (based on element properties — use for typography):
```typescript
// Ascenders animate first, descenders last — letter anatomy determines timing
stagger: (index, target) => {
  const char = target.textContent?.toLowerCase() ?? ''
  const ascenders = 'bdfhklt'
  const descenders = 'gjpqy'
  if (ascenders.includes(char)) return index * 0.02
  if (descenders.includes(char)) return index * 0.06
  return index * 0.04
}
```

**Which stagger type for which brand:**
- Grid/systematic brands (architecture, engineering): mechanical
- Organic/living brands (botanical, culinary, natural): organic from random
- Language/editorial brands (publishing, manifesto): anatomical

---

## The `power2.out` Problem

`ease: 'power2.out'` is a default, not a decision. Every match in your codebase is a missed opportunity to make the motion feel like the brand. Replace all instances with your named brand ease.

**Audit your animation code:**
```
grep -r "power2.out\|power3.out\|easeOut\|easeInOut" src/
```

Every match is a default that should be replaced with the brand ease. The only exceptions are:
- Micro-interactions inside the signature interaction (may use `power2.out` as a sub-ease)
- Third-party component libraries where you cannot control the ease

Otherwise: every `power2.out` is a missed opportunity to make the motion feel like the brand.

---

## Scroll Velocity Easing

When scroll velocity drives animations (Scroll paradigm, Typography paradigm), the smoothing factor IS the brand feel.

```typescript
// Lenis exposes velocity — use it
lenis.on('scroll', ({ velocity }) => {
  const normalizedV = clamp(Math.abs(velocity) / 30, 0, 1)
  smoothedV = lerp(smoothedV, normalizedV, 0.08)  // ← THIS NUMBER IS THE BRAND

  // 0.03 = glacial response (sake brewery, monastery, geological)
  // 0.08 = measured response (architecture, craft, premium)
  // 0.15 = responsive (agency, technology, dynamic)
  // 0.25 = immediate (brutalist, direct, no-nonsense)
})
```

The lerp factor here is the brand's relationship to urgency. Derive it from Metaphor 3 (Emotional Trigger).

---

## Easing Audit

Before launch, verify every animation uses a derived ease:

- [ ] Brand ease named and documented (traced to Metaphor 1)
- [ ] Duration base set and documented (traced to brand tempo)
- [ ] No `power2.out` / `power3.out` without justification
- [ ] Stagger type derived from brand's sense of rhythm
- [ ] Scroll velocity lerp factor derived from Metaphor 3
- [ ] Hero animation uses macro duration
- [ ] State change micro-interactions use micro duration
- [ ] All GSAP eases and CSS transition eases match — one brand, one motion language
