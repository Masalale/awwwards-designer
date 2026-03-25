# Page Transitions — Reference

> **All projects use TanStack Start with TanStack Router.** The authoritative
> page transition implementation guide lives in the main orchestrator skill:
>
> **`awwwards-designer/references/page-transitions.md`**
>
> Read that file for:
> - Root layout pattern (`__root.tsx` + `useRouterState` + `useLayoutEffect`)
> - Leave animation hook (`useAnimatedNavigation`)
> - Clip-path wipe implementation
> - GSAP FLIP shared-element morph
> - Smooth scroll reinitialization on route change
> - Route-specific transition variants
> - Native CSS View Transitions API (zero-JS lightweight option)
> - Full pre-ship checklist

---

## What This File Covers

This file supplements the main reference with animation quality guidance for
transitions — the principles that make a transition feel crafted vs. mechanical.

---

## Transition Quality Principles

### 1. Every transition has two acts
The leaving page must tell you it's leaving. The entering page must announce its
arrival. A fade to black and fade in is two acts. A hard cut is zero acts — it
communicates nothing. Define both acts in every transition, even if the leaving
act is brief (0.2–0.3s).

### 2. Duration is emotional pacing
- Fast (< 0.4s total): Sharp, confident, modern — good for SaaS, editorial
- Medium (0.5–0.8s): Measured, considered — good for portfolios, agencies
- Slow (0.8s+): Cinematic, immersive — good for luxury, storytelling sites

Match the transition duration to the brand's easing language from the animation map.

### 3. Direction carries meaning
The user expects spatial consistency. If pages are "deeper" in a hierarchy,
they should enter from a consistent direction. Entering from bottom = going deeper.
Entering from top = going back. Entering from right = going forward.
Do not randomize transition direction.

### 4. Shared elements must be continuous
If an element (a project thumbnail, a logo) appears on both the leaving and
entering page, use a shared-element transition (GSAP FLIP or CSS
`view-transition-name`). A cut where a morph should happen breaks spatial
continuity and reads as a bug, not a design choice.

### 5. Persistent elements do not transition
Navigation, persistent headers/footers, and overlays live outside `<Outlet />`
in the root layout. They should not animate out and back in on every route
change — they persist. Only route-specific content transitions.

---

## Timing Reference

| Phase | Duration | Easing |
|-------|----------|--------|
| Leave — fade/slide out | 0.25–0.4s | `ease-transition` (power2.in) |
| Leave — clip wipe cover | 0.35–0.5s | `ease-transition` (power4.inOut) |
| Enter — clip wipe reveal | 0.35–0.5s | `ease-transition` (power4.inOut) |
| Enter — content arrive | 0.5–0.8s | `ease-primary` (power3.out) |
| Shared element morph | 0.6–1.0s | `power3.inOut` |

Total perceived transition time should be under 1.0s for most routes.
Above 1.0s feels slow unless the brand explicitly calls for cinematic pacing.

---

## Reduced Motion

Always check `prefers-reduced-motion` before initializing JS transitions.
Provide an instant swap (no animation) as the reduced-motion path.

```js
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches
if (prefersReducedMotion) {
  // Skip to direct navigation — no animation
  return
}
// Run transition animation
```
