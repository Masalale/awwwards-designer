# Animation Standards

> **Priority order:** DESIGN.md → Animation map easings → This reference.

---

## Animation Philosophy: 3 Pillars

1. **Intentionality** — Every animation has a reason. It reveals hierarchy, guides attention, or confirms interaction. If you can't state its purpose in one sentence, remove it.
2. **Narrative Coherence** — Animations tell a story. The page enters with purpose, content reveals in a logical sequence, and interactions feel like natural cause-and-effect.
3. **Performance Integrity** — Premium feel requires 60fps. GPU-accelerated only. Main thread blocking is a hard failure.

---

## Animation Complexity Matrix

| Level | Type | Duration | Complexity | When to Use |
|-------|------|----------|------------|-------------|
| **CSS** | Micro-interactions | 0.15–0.4s | Low | Hover states, button feedback, toggles, form focus |
| **JS-Scroll** | Scroll-triggered reveals | 0.5–1.2s | Medium | Section reveals, staggered content, parallax |
| **JS-Advanced** | Scroll + interaction combos | 0.4–1.5s | Med-High | Horizontal scroll galleries, pinned sections |
| **JS-Transitions** | Page transitions | 0.4–0.8s/phase | High | Multi-page sites |

---

## Easing Selection: The 3 Easings

| Easing | Curve | Use For |
|--------|-------|---------|
| `ease-primary` | `cubic-bezier(0.16, 1, 0.3, 1)` / GSAP `power4.out` | Section reveals, card entrances, modal open |
| `ease-reveal` | `cubic-bezier(0.22, 1, 0.36, 1)` / GSAP `power3.out` | Hero headlines, full-page load sequences |
| `ease-transition` | `cubic-bezier(0.65, 0, 0.35, 1)` / GSAP `power2.inOut` | Page transitions, clip-path wipes |

**Never use `linear` easing for anything user-facing.**

### Brand → Curve Mapping

| Brand Personality | Curve |
|------------------|-------|
| Bold/Assertive | `power4.out` / `cubic-bezier(0.16, 1, 0.3, 1)` |
| Elegant/Luxury | `power3.out` / `cubic-bezier(0.22, 1, 0.36, 1)` |
| Playful/Creative | `back.out` / `cubic-bezier(0.34, 1.56, 0.64, 1)` |
| Tech/SaaS | `power2.out` / `cubic-bezier(0.25, 1, 0.5, 1)` |
| Minimal/Quiet | `power1.out` / `cubic-bezier(0.25, 0, 0.5, 1)` |

---

## Timing Cheat Sheet

| Context | Duration | Easing | Stagger |
|---------|----------|--------|---------|
| Hero reveal | 0.8–1.2s | ease-reveal | 100–150ms/item |
| Section fade-up | 0.6–0.8s | ease-primary | 50–100ms/item |
| Scroll-triggered image | 0.8–1.0s | ease-primary | — |
| Micro-interaction (hover) | 0.2–0.4s | ease-primary | — |
| Page leave | 0.3–0.5s | ease-transition | — |
| Page enter | 0.5–0.8s | ease-primary | — |
| Text char reveal | 0.04–0.08s/char | ease-reveal | 20–40ms stagger |

---

## Key Animation Rules

### DO:
- Use scoped animation contexts (`gsap.context()` or equivalent) for cleanup
- Kill scroll trigger instances and smooth scroll on unmount/page transition
- Stagger reveals to create visual rhythm
- Use `autoAlpha` instead of separate opacity tweens
- Add `will-change` only during active animation, remove after

### DON'T:
- `transition: all` — ever, for any reason
- Animate `width`, `height`, `margin`, `top`, `left`, `font-size`
- Use `setInterval`/`setTimeout` for animation loops
- Initialize multiple ScrollTrigger instances on the same element
- Forget `ScrollTrigger.refresh()` after DOM mutations

---

## See Also

- `references/scroll-patterns.md` — Scroll-triggered reveals, galleries, parallax
- `references/page-transitions.md` — TanStack Router transitions
- `references/text-animation.md` — SplitType, variable font animation
- `references/micro-interactions.md` — Button arcs, magnetic effects, cursor
- `references/anim-anti-patterns.md` — Animation anti-patterns
