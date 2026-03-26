---
name: awwwards-quality-gate
description: >
  Quality gate standards for Awwwards submission. Defines 8 evaluation gates:
  Design, Creativity, Content, Usability, Performance, Animation, Technical, and
  Pre-Launch Audit. Consulted during Phase 5 of the awwwards-designer workflow.
  Before evaluating Gates 1, 6, and 7, read DESIGN.md — all design-related checks
  must verify fidelity to DESIGN.md, not compliance with generic standards. All 8
  gates must pass before shipping. No exceptions.
---

# Awwwwards Quality Gate

> **All 8 gates pass = ship. Any gate fails = fix before shipping. No exceptions.**

---

## Table of Contents

1. [Scoring Criteria](#scoring-criteria)
2. [Honorable Mention Threshold](#honorable-mention-threshold)
3. [Gate 1 — Design Quality](#gate-1--design-quality)
4. [Gate 2 — Creativity Quality](#gate-2--creativity-quality)
5. [Gate 3 — Content Quality](#gate-3--content-quality)
6. [Gate 4 — Usability Quality](#gate-4--usability-quality)
7. [Gate 5 — Performance Quality](#gate-5--performance-quality)
8. [Gate 6 — Animation Quality](#gate-6--animation-quality)
9. [Gate 7 — Technical Quality](#gate-7--technical-quality)
10. [Gate 8 — Pre-Launch Audit Sequence](#gate-8--pre-launch-audit-sequence)
11. [Pass/Fail Rule](#passfail-rule)

> **Before running any gate:** Read `DESIGN.md` from the project root. Gates 1, 6, and 7 evaluate fidelity to DESIGN.md — not compliance with generic design rules. If DESIGN.md specifies a font, that font is correct. If it specifies an animation style, that style is correct. If it specifies an icon system other than Lucide, that system is correct for this project.

> **Deep-dive references** (load as needed):
> - `references/design-audit.md` — Typography, color, layout, image, icon, spacing, brand audits
> - `references/usability-audit.md` — Navigation, mobile, touch, forms, accessibility, 404, error handling
> - `references/technical-audit.md` — Build, routes, assets, semantic HTML, CSS, JS, descender safety
> - `references/scoring-guide.md` — Scoring breakdown, jury process, rejection reasons, CSSA path

---

## Scoring Criteria

Awwwwards evaluates on **4 criteria** weighted as follows:

| Criterion     | Weight | What Jury Evaluates |
|---------------|--------|---------------------|
| **Design**    | 40%    | Visual impact, typography, color, layout, consistency, brand coherence |
| **Usability** | 30%    | Navigation clarity, mobile experience, touch targets, forms, accessibility |
| **Creativity**| 20%    | Concept uniqueness, first impression, memorable moments, signature elements |
| **Content**   | 10%    | Copy quality, brand voice, information hierarchy, CTAs, relevance |

**The math**: A score of 8/10 across all criteria = ~80% overall. SOTD requires consistently high marks — a 7.0 on Design but 5.0 on Usability will drag you down.

---

## Honorable Mention Threshold

To receive **Honorable Mention** (the minimum recognition tier):

- **Jury score average ≥ 6.5** AND **User score average ≥ 6.5**
- Evaluated by **18+ jury members**
- Top 3 highest and lowest scores are **removed as outliers** before averaging
- **SOTD** (Site of the Day) eligibility window: within **3 months** of launch
- **Developer Award**: requires >7.0 average on the technical/coding criteria

> CSSA (Community Site Feature Award) is a more accessible path — score >7.0 from community reviewers.

---

## Gate 1 — Design Quality

> **Reference:** `references/design-audit.md`

**PASS criteria (all must be true):**

- [ ] **Typography**: Fonts match DESIGN.md specification. No unintended system font fallbacks (fonts are loading correctly). Consistent type scale per DESIGN.md. Readable hierarchy (h1→h2→h3). No clipped descenders on text >48px font-size.
- [ ] **Color**: Palette matches DESIGN.md color tokens exactly. WCAG AA contrast ratios met. No hardcoded hex values — all colors reference DESIGN.md tokens.
- [ ] **Layout**: Intentional rhythm and pacing. Asymmetric layouts used where appropriate (not everything centered). Breathing room. Consistent spacing scale (4px/8px base).
- [ ] **Images**: High-quality, relevant, not stock-photo heavy. Proper aspect ratios throughout. No stretched or pixelated images.
- [ ] **Icons**: Single icon library matching DESIGN.md specification (default: Lucide, but DESIGN.md overrides). Consistent stroke weight. Purposeful use — not decorative noise. Zero mixed icon libraries.
- [ ] **Brand**: Design reflects brand identity. Not a template aesthetic. Visual language is cohesive.

**FAIL signals:** Default fonts, random color choices, centered-everything layouts, stock photo overload, mixed icon libraries, clipped text.

---

## Gate 2 — Creativity Quality

> **Reference:** `references/scoring-guide.md`

**PASS criteria (all must be true):**

- [ ] **Unique concept exists**: There is a clear creative idea behind the site, not just "a website." The concept is communicated in the first scroll.
- [ ] **Memorable first impression**: The hero/landing moment is distinctive. You remember something specific after closing the tab.
- [ ] **Surprising interactions**: Interactions feel unexpected in a good way. Micro-interactions reward attention. Nothing feels routine.
- [ ] **Animation serves narrative**: Animation is tied to the story/concept — it doesn't exist just because it's possible. Every animated element has a reason.
- [ ] **Signature element present**: One interaction, visual motif, or detail that is unique to this project and would be hard to copy.

**FAIL signals:** Generic hero section, no memorable moment, animations feel like copy-paste from boilerplate, no signature element, "it's nice but forgettable."

---

## Gate 3 — Content Quality

**PASS criteria (all must be true):**

- [ ] **Meaningful copy**: Every piece of text serves a purpose. No lorem ipsum. No placeholder copy. No vague marketing speak.
- [ ] **Brand voice reinforced**: The tone of writing matches the visual brand. A playful brand has playful copy. A serious brand is precise.
- [ ] **Clear information hierarchy**: The most important content is most prominent. Users know where to look. No competing equal-weight headings.
- [ ] **CTAs clear and compelling**: Every CTA is obvious, specific, and actionable. "Learn more" is not acceptable — it must say what happens next.

**FAIL signals:** Lorem ipsum anywhere, vague copy, no hierarchy (everything looks equally important), generic CTAs.

---

## Gate 4 — Usability Quality

> **Reference:** `references/usability-audit.md`

**PASS criteria (all must be true):**

- [ ] **Navigation clear**: Users can find what they need in ≤3 clicks. Nav is consistent across all pages. Active state is visible.
- [ ] **Mobile 375px functional**: Fully usable at 375px width. No horizontal overflow. All features work on mobile.
- [ ] **Touch targets 44×44px+**: All interactive elements meet minimum touch target size. Check on actual mobile if possible.
- [ ] **Forms work**: Every form input is functional. Inline validation provides helpful feedback. Submit states (loading/success/error) all exist.
- [ ] **404 page exists**: A branded, helpful 404 page exists with navigation back to useful pages. No dead ends.
- [ ] **Keyboard navigable**: Full keyboard navigation. Visible focus indicators on all interactive elements.

**FAIL signals:** Broken nav, horizontal scroll on mobile, tiny touch targets, forms that don't submit, no 404 page, no keyboard access.

---

## Gate 5 — Performance Quality

> **Reference:** `references/technical-audit.md`

**PASS criteria (all must be true):**

- [ ] **LCP ≤ 1.8s**: Largest Contentful Paint within Awwwards target on mobile 4G. See `awwwards-performance-standards` skill for optimization techniques.
- [ ] **CLS ≤ 0.05**: Cumulative Layout Shift near zero. No layout jumps as content loads.
- [ ] **INP ≤ 100ms**: Interaction to Next Paint responsive. No sluggish clicks/inputs.
- [ ] **No render-blocking resources**: All JS and non-critical CSS are deferred or async. `<link rel="stylesheet">` in `<head>` only for critical.
- [ ] **Images optimized**: WebP/AVIF with fallbacks. Responsive `srcset`. Lazy loading on below-fold images.
- [ ] **Fonts with `font-display: swap`**: No invisible text while fonts load. Fallback fonts are visually acceptable.

**FAIL signals:** LCP >3s, CLS >0.25, blocking scripts, oversized images, FOUT that lasts >1s.

---

## Gate 6 — Animation Quality

> **Reference:** `references/technical-audit.md`

**PASS criteria (all must be true):**

- [ ] **Purpose-driven**: Every animation has a reason. Entrances are choreographed. Nothing animates just because it can.
- [ ] **Physical easing**: No `linear` easing. No `ease-in-out` on everything. Custom cubic-bezier curves that feel physical (slight overshoot, deceleration). See `awwwards-animation-standards` skill.
- [ ] **Page transitions present**: Meaningful transitions between pages or sections (not just instant cuts).
- [ ] **Signature interaction**: At least one interaction that makes you want to interact with the site — a reward for engagement.
- [ ] **`prefers-reduced-motion` respected**: All animations gracefully degrade or disable when user preference is set. No broken state when reduced motion is on.

**FAIL signals:** `transition: all`, `animation: linear` anywhere, animations that get annoying on repeat, reduced motion = broken layout.

---

## Gate 7 — Technical Quality

> **Reference:** `references/technical-audit.md`

**PASS criteria (all must be true):**

- [ ] **`bun run build` succeeds**: Zero build errors. Zero TypeScript/ESLint errors.
- [ ] **No dead routes**: Every defined route renders real content. Check all nav links manually.
- [ ] **No broken assets**: All images, fonts, scripts resolve (200 OK). Check Network tab for 404s.
- [ ] **Semantic HTML**: Proper heading hierarchy (h1→h2→h3, no skips). Landmark elements (header/main/footer/nav/aside). No `<div>` where `<button>` belongs.
- [ ] **Icon system matches DESIGN.md**: Default is Lucide, but verify against DESIGN.md. Zero mixed icon libraries — one system only. Search codebase for violations of whichever system DESIGN.md specifies.
- [ ] **No `transition: all`**: All transitions specify exact properties. `transition: all` is a fail — must be property-specific.
- [ ] **Descender safety verified**: `overflow: visible` on text elements >48px. `padding-bottom` applied where needed to prevent glyph clipping on letters like g, y, p, q.
- [ ] **`100dvh` on full-screen elements**: Mobile browsers use dynamic viewport height. Use `100dvh` (not `100vh`) for full-screen sections to prevent address bar overlap.

**FAIL signals:** Build errors, dead links, 404 assets, `<div>` soup, mixed icon libraries, `transition: all`, text clipping, `100vh` on mobile full-screen.

---

## Gate 8 — Pre-Launch Audit Sequence

> **Run these in order. Do not skip steps.**

1. **Final `bun run build`** — Confirm clean build, zero errors, zero warnings in CI.
2. **Lighthouse audit** — Run in Chrome DevTools. LCP ≤1.8s, CLS ≤0.05, INP ≤100ms, Performance ≥90, Accessibility ≥90.
3. **Mobile 375px test** — Chrome DevTools mobile emulation. Scroll, tap, type. Check for overflow.
4. **Keyboard navigation test** — Tab through entire site. Every interactive element reachable and visible.
5. **Touch target check** — Measure all buttons/links. Minimum 44×44px.
6. **Form exhaustiveness** — Fill every form completely. Submit. Check success/error states.
7. **404 crawl** — Navigate to `/this-does-not-exist`. Verify branded 404 renders.
8. **`prefers-reduced-motion` test** — Enable in OS settings. Verify animations degrade gracefully.
9. **Asset resolution check** — Network tab: confirm no 404s on images, fonts, scripts.
10. **Screenshot comparison** — Take full-page screenshots on desktop + mobile. Review for visual regressions.

---

## Pass/Fail Rule

> **All 8 gates pass = ship. Any gate fails = fix before shipping. No exceptions.**

This is non-negotiable. A site that fails any gate is not ready for Awwwwards submission. A failure in one gate usually signals failures in others — do a full re-audit after fixes.

| Gate | Area | Owner Signal |
|------|------|-------------|
| 1 | Design | `references/design-audit.md` |
| 2 | Creativity | `references/scoring-guide.md` |
| 3 | Content | This file |
| 4 | Usability | `references/usability-audit.md` |
| 5 | Performance | Lighthouse + Network tab |
| 6 | Animation | `references/technical-audit.md` |
| 7 | Technical | `references/technical-audit.md` |
| 8 | Pre-Launch | This file (runbook) |
