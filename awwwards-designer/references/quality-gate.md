# Quality Gate: Pass/Fail Checklist

Run this checklist after the Enhancement Layer completes. Every item must pass before the site ships. No subjective scoring — each check is binary.

---

## Interaction & Animation

- [ ] **Page transitions present** — TanStack Router hooks + GSAP handle all route changes with animated enter/exit sequences in `__root.tsx`. No hard page reloads.
- [ ] **Signature interaction present** — At least one interaction that is unique to this brand's metaphor. Not a template pattern. Derived from the animation map.
- [ ] **Scroll animations functional** — ScrollTrigger-driven animations fire at correct scroll positions on desktop and mobile.
- [ ] **Lenis smooth scroll active** — `smoothTouch: false` confirmed. No native scroll hijacking on touch devices.
- [ ] **Animation performance** — No visible jank during scroll or interaction. GSAP animations run at 60fps on mid-range hardware.

## Responsive & Mobile

- [ ] **Mobile responsive at 375px** — Full layout integrity at iPhone SE width. No horizontal overflow. No text truncation.
- [ ] **`100dvh` on full-screen sections** — Not `100vh`. Accounts for mobile address bar resize.
- [ ] **No touch scroll hijacking** — Lenis `smoothTouch: false`. Native touch behavior preserved.
- [ ] **Touch device detection** — `pointer: coarse` media query used. Hover-dependent interactions have touch fallbacks.
- [ ] **`env(safe-area-inset-*)` applied** — Notched device safe areas respected on fixed/absolute elements.

## Typography & Descender Safety

- [ ] **`overflow: visible` on text elements** — Never `overflow: clip` (ignores padding). Display text >48px has descender clearance via `padding-bottom`.
- [ ] **SplitType text legible** — Split characters/words render correctly. No clipping on g, y, p, q, j descenders.

## Technical

- [ ] **No `transition: all`** — Every transition specifies exact properties.
- [ ] **Icon system verified** — All icons match the specified system (default: Lucide). No mixed libraries.
- [ ] **Context7 docs fetched** — Current API docs fetched via Context7 for every library before integration code was written.
- [ ] **GSAP context cleanup** — `gsap.context()` wraps all animations. Cleanup runs on page transitions.
- [ ] **Three.js disposal** — If Tier 2.5+: geometries, materials, and renderers disposed on cleanup. No GPU memory leaks.
- [ ] **`prefers-reduced-motion` respected** — All JS-driven animations are skipped or reduced when `window.matchMedia('(prefers-reduced-motion: reduce)').matches`. CSS animations suppressed via the global `prefers-reduced-motion` media query. Site must be fully usable without motion.

## Performance (by Tier)

| Metric | All Tiers |
|--------|-----------|
| LCP | < 1.8s — WebGL/3D must lazy-init after first paint |
| CLS | < 0.05 |
| INP | < 100ms |
| FCP | < 1.2s — Tier 1 target is < 1.0s |

- [ ] **Core Web Vitals within tier targets** — Run Lighthouse audit. All metrics pass.

## Skeleton Test (Structural)

- [ ] **Build succeeds** — `bun run build` completes without errors.
- [ ] **No dead routes** — Every route defined in build_site renders content.
- [ ] **No broken assets** — All images, fonts, and scripts resolve (no 404s).

---

- **All pass** — Ship.
- **Any fail** — Fix before shipping. No exceptions.
