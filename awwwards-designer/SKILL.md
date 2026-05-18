---
name: awwwards-designer
description: >
  Awwwards-level website builder powered by Google Stitch. Takes a brand brief,
  generates award-quality UI designs via Stitch MCP, then enhances the output with
  a bespoke animation and interaction layer — scroll effects, page transitions,
  3D scenes, and signature interactions derived from the brand metaphor. Built on
  TanStack Start. Targets Awwwards SOTD/SOTM/SOTY. This is the unified orchestrator
  skill — it bundles animation standards, performance standards, visual design
  standards, and quality gate checks into one cohesive workflow.
---

# Awwwards + Stitch: Unified Execution Skill

## Hard Stops

These are non-negotiable. Violating any one is a build failure.

1. **No code before the Invention Gate completes.** The animation map and Stitch prompt must exist before any screen is generated or any code is written.
2. **TanStack Start only.** Do not use Astro, Next.js, or any other framework. Every project is built on TanStack Start with React and Tailwind CSS. This is not a choice offered to the user.
3. **`overflow: visible` on text elements.** Never `overflow: clip` (clip ignores padding-bottom). Display text >48px requires descender clearance. See `references/descender-safety.md`.
4. **`100dvh` not `100vh`.** Accounts for mobile address bar resize on full-screen sections.
5. **Never override native touch scroll.** Native touch scroll momentum is sacred. If a smooth scroll library is used, it must not intercept touch scroll (Lenis is preferred — ensure `smoothTouch: false`).
6. **Context7 before integrating any library.** Fetch current API docs via Context7 for every library you choose to use before writing integration code. Library APIs change. Training data is stale.
7. **Descender safety on display text >48px.** `padding-bottom: 0.18em` minimum on all display text. See `references/descender-safety.md`.
8. **Lucide icons exclusively.** Specify in Stitch brief. Stitch uses Lucide by default.
9. **Bun exclusively.** All package management, script execution, and tooling uses Bun. `bun add` not `npm install`. `bunx` not `npx`. `bun run build` not `npm run build`.
10. **GPU-accelerated properties only for animation.** Animate only `transform`, `opacity`, `filter`, `clip-path`. Never animate `width`, `height`, `top`, `left`, `margin`, `padding`, `font-size`, `border-radius`.
11. **No `transition: all` anywhere.** Never, for any reason, in any file.
12. **`prefers-reduced-motion` must be respected.** All animations must gracefully degrade or disable when the user preference is set. No broken state when reduced motion is on.
13. **Body text contrast must be ≥ 4.5:1.** Gray-500 (#6b7280) or darker on white. Never gray-400 or lighter for body text.
14. **Every animation must have a purpose.** If you can't state the reason in one sentence, remove it. No decoration-only animation.

---

## Phase 1: Brief Interview

Ask the user these 7 questions to extract everything the Invention Gate needs:

1. What is the brand or store name?
2. What does the brand do and what does it stand for?
3. Who is the target audience?
4. What tier of animation? (1: CSS-only | 2: JS-enhanced | 2.5: light 3D | 3: WebGL/shaders)
5. How many pages and what content on each?
6. Are there any interactive or data-driven sections — forms, logins, dashboards, listings, checkout flows? If yes, describe each briefly.
7. Any reference sites that capture the desired feel? (optional)

If the user provides brand colors, capture them exactly. If not, note that Stitch will choose.

**Output:** Structured interview answers passed to Phase 2.

---

## Phase 2: Invention Gate

The creative engine. Takes interview answers, produces two documents.

Read `references/invention-gate.md` for the full process.

### 2.1 Extract Brand Metaphor
Distill a physical/sensory metaphor from the brand identity. Must pass 3 quality gates:
- Grounding test (can you touch/feel it?)
- Continuity test (informs both visual and motion?)
- Distinctiveness test (unique to this brand?)

### 2.2 Derive Motion Language
Map the metaphor to speed, weight, texture, and response. Define 3 project easings.

### 2.3 Generate Animation Map
Following the schema in `references/animation-map.md`:
- Global settings (tier, easing, scroll behavior, page transitions, signature interaction)
- Per-page animation assignments for every section
- WebGL/3D overlay zones (Tier 2.5+) with mobile fallbacks
- Animated text targets (elements requiring character/word-level animation)
- Scroll-pinned sections

Read `references/technique-families.md` for interaction pattern options per tier.
Read `references/anti-patterns.md` before making any pattern decisions.

### 2.4 User Review Gate
**Do not generate the Stitch prompt yet.**

Present to the user:
- The three brand metaphors with quality gate results
- The motion language (speed, weight, texture, response → named easings)
- The signature interaction statement
- The animation map summarized per page

Ask: "Does this capture the brand correctly? Any changes before I write the Stitch prompt?"

Wait for explicit confirmation. Revise and re-present if needed. Do not proceed until the user confirms.

### 2.5 Translate to Stitch Prompt
Only after user confirms the animation map.

Write the Stitch prompt following `references/stitch-brief.md`. The Aesthetic Direction section is the creative core — inject the brand metaphors from the Invention Gate verbatim, then follow with the visual vocabulary and negative constraints each metaphor implies at rest. Include the actual brand name (not the creative codename) and define shared components (nav, footer) explicitly so they are consistent across all generated screens.

**Output:** Animation map (user-confirmed) + Stitch prompt.

**Gate:** Both documents must exist and the animation map must be user-confirmed before proceeding to Phase 3.

---

## Phase 3: Stitch MCP

Drive Google Stitch programmatically via MCP to generate the design and build the project. Stitch always outputs HTML with Tailwind CSS — it has no awareness of any JavaScript framework. The TanStack Start project structure is established in Phase 4.

### 3.1 Create Project
Call `create_project` via Stitch MCP. Once the project ID is returned, display the canvas link to the user:
```
Your Stitch canvas: https://stitch.withgoogle.com/project/{projectId}
```
Screens will appear here live as they are generated.

### 3.2 Generate Screens
Call `generate_screen_from_text` for each page using the Stitch prompt from Phase 2.
- Set `deviceType: "DESKTOP"`
- Screen generation takes 2-10 minutes per screen. After each call returns, immediately call `list_screens` to confirm the screen is present in the project before generating the next. This catches silent failures without retrying prematurely.
- After each screen is confirmed, tell the user: "✓ [Page name] screen is live on your canvas."
- Collect every screenId as screens are confirmed — all are needed for the harmonization pass.

### 3.3 Cross-Page Harmonization
`generate_screen_from_text` is always a single, independent call. It has no memory of the other pages generated in the same project. The harmonization pass corrects any inconsistencies that result from independent generation.

Call `edit_screens` once with **all screenIds** in `selectedScreenIds`. This single call gives Stitch visibility across every screen simultaneously, allowing it to reconcile shared visual properties across the entire site.

Harmonization prompt: "Unify all screens so that the navigation bar, footer, button styles, card styles, typography scale, and color usage are identical across every page. Fix any visual inconsistencies introduced by independent generation. Apply the design decisions established in the strongest screen to all others."

### 3.4 Review Gate
After the harmonization pass, prompt the user:
```
All screens are live at your Stitch canvas. Review them and make any edits directly on the canvas until you're happy, then reply here when you're ready to build.
```
Wait for explicit user confirmation before proceeding.

### 3.5 Build Site
Call `build_site` with the project ID and route mappings:
- Map each screen to its URL route (e.g., screenA -> "/", screenB -> "/work")
- Output: HTML pages with Tailwind CSS, one per route.

### 3.6 Extract Design Context
Call `extract_design_context` to get the Design DNA (fonts, colors, layouts).
Save as DESIGN.md in the project root.

**Output:** Project files + DESIGN.md.

---

## Phase 4: Enhancement Layer

The core execution phase. Takes the Stitch output and adds the animation/interaction layer.

### Prerequisites
Read before implementing:
- **DESIGN.md from Phase 3 — this is the single source of truth for all design decisions.** Every color, font, spacing, and component style must come from DESIGN.md. Do not invent or assume design values.
- The animation map from Phase 2 (for what moves and how)
- `references/tech-stack.md` for tier-appropriate library guidance
- `references/technique-families.md` for pattern implementation reference
- `references/page-transitions.md` for TanStack Router + GSAP transitions
- `references/descender-safety.md` for typography safety

Fetch current API docs via Context7 for every library before writing code.

### 4.0 Project Scaffolding
Stitch outputs plain HTML files — one per page. Phase 4 begins by establishing the TanStack Start project that the enhancement layer runs inside.

Use Context7 to fetch the current TanStack Start initialization command before running it — the CLI and package name evolve and a stale command will fail silently or scaffold the wrong structure. Initialize with React + Tailwind CSS.

Once the project is initialized:
- Replace the generated placeholder routes with the Stitch HTML pages, one route per page
- Preserve all Tailwind classes and structure from the Stitch output exactly — DESIGN.md is the design authority and the Stitch HTML is its implementation
- Do not restyle or restructure anything at this stage; the enhancement layer adds motion on top of the Stitch design, it does not replace it

### 4.1 Global Setup
Implement site-wide concerns first:
- Smooth scroll system (if required by the animation map tier — Lenis preferred, `smoothTouch: false`)
- Page transition system in root layout (`__root.tsx`) — see `references/page-transitions.md`
- Animation library initialization and plugin registration for whichever tools are chosen
- Animation cleanup on route change — all scroll triggers, instances, and contexts must be destroyed/reverted on navigation

### 4.2 Per-Section Animation
Walk through the animation map page by page, section by section:
- Match HTML sections to animation map assignments
- Implement the specified animation type (scroll_reveal, scroll_pin, webgl_overlay, static)
- Use the project easings from the animation map
- Animate text targets specified in the animation map with descender safety applied

### 4.3 WebGL/3D Overlays (Tier 2.5+ only)
For each overlay zone in the animation map:
- Create a canvas element positioned over the Stitch HTML section
- Implement the specified scene type using the most appropriate WebGL renderer for the scene (Three.js/R3F are proven defaults — choose based on scene complexity)
- Connect interaction handlers (cursor, scroll)
- Implement mobile fallback (hide canvas, show Stitch design)
- Ensure proper disposal and memory cleanup on route changes

### 4.4 Signature Interaction
Implement the one unique interaction specified in the animation map. This must feel native to the brand metaphor, not bolted on.

### 4.5 Site-Wide Pass
After all sections are enhanced:
- Test page transitions between all routes
- Verify smooth scroll behavior across all pages
- Verify animation cleanup prevents conflicts across route changes
- Test mobile at 375px width

**Output:** Enhanced site with full animation/interaction layer.

---

## Phase 5: Quality Gate

Run the pass/fail checklist in `references/quality-gate.md`.

Every item must pass:
- Page transitions present
- Signature interaction present
- Mobile responsive at 375px
- `100dvh` on full-screen sections
- No touch scroll hijacking
- Descender safety verified
- Icon system verified
- Core Web Vitals within tier targets
- Build succeeds, no dead routes, no broken assets

**All pass:** Site is ready to ship.
**Any fail:** Fix before shipping. No exceptions.

---

## Reference Files

| File | Purpose | When to Read |
|------|---------|-------------|
| `invention-gate.md` | Metaphor extraction + output generation | Phase 2 |
| `animation-map.md` | Animation map schema + easing derivation | Phase 2, Phase 4 |
| `stitch-brief.md` | How to write Stitch prompts | Phase 2 |
| `technique-families.md` | Interaction patterns by tier | Phase 2, Phase 4 |
| `anti-patterns.md` | Interaction/code anti-patterns | Phase 2 |
| `tech-stack.md` | Tier-based enhancement guidance | Phase 4 |
| `page-transitions.md` | Page transition patterns | Phase 4 |
| `descender-safety.md` | Typography clipping prevention | Phase 4 |
| `quality-gate.md` | Final quality gate | Phase 5 |
| `scroll-patterns.md` | Scroll-triggered reveals, galleries, parallax | Phase 4 |
| `text-animation.md` | SplitType, variable font animation, text reveals | Phase 4 |
| `micro-interactions.md` | Button arcs, magnetic effects, cursor | Phase 4 |
| `anim-anti-patterns.md` | Animation anti-patterns and code review | Phase 4 |
| `image-optimization.md` | Image formats, CDNs, lazy loading, blur-up | Phase 4, Phase 5 |
| `font-loading.md` | Preloading, font-display, subsets, size-adjust | Phase 4 |
| `css-performance.md` | Critical CSS, containment, will-change | Phase 4 |
| `testing.md` | Lighthouse, WebPageTest, CI budgets | Phase 5 |
| `typography.md` | Font pairing, type scale, fluid type math | Phase 2, Phase 4 |
| `color-systems.md` | 3-layer tokens, dark mode, OKLCH, WCAG contrast | Phase 2, Phase 4 |
| `responsive-design.md` | Mobile-first breakpoints, container queries | Phase 4, Phase 5 |
| `accessibility.md` | WCAG 2.1 AA checklist, ARIA, focus | Phase 5 |
| `scoring-guide.md` | Awwwards scoring, jury process, rejection reasons | Phase 5 |
| `design-audit.md` | Design quality deep-dive audit | Phase 5 |
| `usability-audit.md` | Navigation, mobile, touch, forms, 404 audit | Phase 5 |
| `technical-audit.md` | Build, routes, assets, semantic HTML, descender audit | Phase 5 |

---

## Consolidated Standards

This section distills the key rules from each standards domain. For full depth, read the reference files listed above.

---

### A. Animation Standards

#### Animation Philosophy: 3 Pillars

1. **Intentionality** — Every animation has a reason. It reveals hierarchy, guides attention, or confirms interaction. If you can't state its purpose in one sentence, remove it.
2. **Narrative Coherence** — Animations tell a story. The page enters with purpose, content reveals in a logical sequence, and interactions feel like natural cause-and-effect.
3. **Performance Integrity** — Premium feel requires 60fps. GPU-accelerated only. Main thread blocking is a hard failure.

#### Animation Complexity Matrix

| Level | Type | Duration | Complexity | When to Use |
|-------|------|----------|------------|-------------|
| **CSS** | Micro-interactions | 0.15–0.4s | Low | Hover states, button feedback, toggles, form focus |
| **JS-Scroll** | Scroll-triggered reveals | 0.5–1.2s | Medium | Section reveals, staggered content, parallax |
| **JS-Advanced** | Scroll + interaction combos | 0.4–1.5s | Med-High | Horizontal scroll galleries, pinned sections |
| **JS-Transitions** | Page transitions | 0.4–0.8s/phase | High | Multi-page sites |

#### Easing Selection: The 3 Easings

| Easing | Curve | Use For |
|--------|-------|---------|
| `ease-primary` | `cubic-bezier(0.16, 1, 0.3, 1)` / GSAP `power4.out` | Section reveals, card entrances, modal open |
| `ease-reveal` | `cubic-bezier(0.22, 1, 0.36, 1)` / GSAP `power3.out` | Hero headlines, full-page load sequences |
| `ease-transition` | `cubic-bezier(0.65, 0, 0.35, 1)` / GSAP `power2.inOut` | Page transitions, clip-path wipes |

**Never use `linear` easing for anything user-facing.**

#### Timing Cheat Sheet

| Context | Duration | Easing | Stagger |
|---------|----------|--------|---------|
| Hero reveal | 0.8–1.2s | ease-reveal | 100–150ms/item |
| Section fade-up | 0.6–0.8s | ease-primary | 50–100ms/item |
| Scroll-triggered image | 0.8–1.0s | ease-primary | — |
| Micro-interaction (hover) | 0.2–0.4s | ease-primary | — |
| Page leave | 0.3–0.5s | ease-transition | — |
| Page enter | 0.5–0.8s | ease-primary | — |
| Text char reveal | 0.04–0.08s/char | ease-reveal | 20–40ms stagger |

#### Key Animation Rules

**DO:**
- Use scoped animation contexts (`gsap.context()` or equivalent) for cleanup
- Kill scroll trigger instances and smooth scroll on unmount/page transition
- Stagger reveals to create visual rhythm
- Use `autoAlpha` instead of separate opacity tweens
- Add `will-change` only during active animation, remove after

**DON'T:**
- `transition: all` — ever, for any reason
- Animate `width`, `height`, `margin`, `top`, `left`, `font-size`
- Use `setInterval`/`setTimeout` for animation loops
- Initialize multiple ScrollTrigger instances on the same element
- Forget `ScrollTrigger.refresh()` after DOM mutations

#### Brand → Curve Mapping

| Brand Personality | Curve |
|------------------|-------|
| Bold/Assertive | `power4.out` / `cubic-bezier(0.16, 1, 0.3, 1)` |
| Elegant/Luxury | `power3.out` / `cubic-bezier(0.22, 1, 0.36, 1)` |
| Playful/Creative | `back.out` / `cubic-bezier(0.34, 1.56, 0.64, 1)` |
| Tech/SaaS | `power2.out` / `cubic-bezier(0.25, 1, 0.5, 1)` |
| Minimal/Quiet | `power1.out` / `cubic-bezier(0.25, 0, 0.5, 1)` |

---

### B. Performance Standards

#### Core Web Vitals — Awwwards Targets

| Metric | Target |
|--------|--------|
| LCP | < 1.8s |
| CLS | < 0.05 |
| INP | < 100ms |
| FCP | < 1.2s |
| TTFB | < 400ms |
| Lighthouse Performance | ≥ 90 |

#### JS Bundle Budgets (gzip)

| Tier | Budget |
|------|--------|
| 1 (CSS-only) | < 20 KB |
| 2 (JS-enhanced) | < 120 KB |
| 2.5 (light 3D) | < 150 KB |
| 3 (WebGL) | < 300 KB |

#### LCP Checklist

- [ ] Preload hero image: `<link rel="preload" as="image" href="hero.avif" fetchpriority="high">`
- [ ] Never lazy-load the LCP element — no `loading="lazy"` on hero
- [ ] Inline critical CSS — no stylesheet blocking first paint
- [ ] Serve from CDN
- [ ] AVIF primary, WebP fallback — never PNG for photos

#### CLS Checklist

- [ ] Reserve space for all images — `width` + `height` OR `aspect-ratio`
- [ ] Never insert content above existing content
- [ ] `font-display: swap` on every `@font-face`
- [ ] Use `size-adjust` for fallback font metric compensation
- [ ] No layout property animations — `transform`/`opacity` only

#### INP Checklist

- [ ] Break up long tasks — no task > 50ms on main thread
- [ ] Use `requestAnimationFrame` for DOM reads/writes
- [ ] Lazy load below-fold interactivity
- [ ] Debounce scroll/pointer handlers
- [ ] Avoid layout thrashing — batch DOM reads, then writes

#### Quick Wins (Every Build)

```
□ 1. Preload LCP image: fetchpriority="high"
□ 2. AVIF primary, WebP fallback, JPEG last resort
□ 3. font-display: swap on every @font-face
□ 4. aspect-ratio on every <img>
□ 5. Defer all non-critical JS
□ 6. Inline critical CSS for above-fold content
□ 7. Preconnect to external origins
□ 8. loading="lazy" on below-fold images
□ 9. No layout property animations
□ 10. Lighthouse Performance ≥ 90 before ship
```

---

### C. Visual Standards

> **DESIGN.md is the authority.** After Phase 3, `extract_design_context` produces a DESIGN.md containing fonts, color tokens, spacing, and component rules. That file overrides everything here. Use these standards only when writing the Stitch brief (Phase 2) or when DESIGN.md has a gap.

#### Typography

- **Distinctive over safe** — Guide toward: Syne, Space Grotesk, Fraunces, Clash Display, Bebas Neue, Plus Jakarta Sans, Outfit, Archivo. Avoid Inter, Roboto, Open Sans.
- **Variable fonts preferred** — For animation-friendly weight interpolation.
- **Fluid type scale with `clamp()`**:
  ```css
  --font-size-display: clamp(2.5rem, 7vw + 1rem, 7rem);
  --font-size-h1:       clamp(2rem, 3vw + 1rem, 4rem);
  --font-size-h2:       clamp(1.5rem, 2vw + 0.75rem, 3rem);
  --font-size-body:     clamp(1rem, 0.25vw + 0.875rem, 1.125rem);
  ```
- **Descender safety** — `overflow: visible` + `padding-bottom: 0.18em` minimum on text ≥ 48px

#### Color: 3-Layer Token Architecture

```
Primitive → Semantic → Component
Raw hex   → Intent   → Reference
```

Never use primitives directly in components. Always reference semantic tokens.

```css
/* Layer 1: Primitives — never use directly */
--primitive-gray-50:  #f9fafb;
--primitive-blue-500: #3b82f6;

/* Layer 2: Semantics — USE THESE */
--color-bg-primary:     var(--primitive-gray-50);
--color-text-primary:   var(--primitive-gray-900);
--color-accent:        var(--primitive-blue-500);

/* Layer 3: Components */
.button-primary {
  background: var(--color-accent);
}
```

#### Layout

- **Spacing**: 4px/8px scale (`--space-1: 0.25rem; --space-2: 0.5rem; ...`)
- **Container**: max-width 1024px, `margin-inline: auto`, `padding-inline: var(--space-6)`
- **Always `100dvh`**, never `100vh` — accounts for mobile browser chrome
- **Asymmetric layouts** — don't center everything; intentional asymmetry creates visual interest

#### Icons

- **Lucide only** — No Heroicons, Font Awesome, or custom SVGs unless brand-specific
- **Stroke width: always 1.5px** — never deviate
- **Size scale**: 16 / 20 / 24 / 32px
- **Use `currentColor`** for dark mode compatibility

---

### D. Quality Gate

#### Scoring (Awwwards Jury)

| Criterion | Weight |
|-----------|--------|
| Design | 40% |
| Usability | 30% |
| Creativity | 20% |
| Content | 10% |

Honorable Mention requires jury average ≥ 6.5 AND user average ≥ 6.5.

#### The 8 Gates

**All 8 must pass. Any fail = fix before shipping. No exceptions.**

| Gate | Area | Key PASS Criteria |
|------|------|-------------------|
| **1** | Design | Typography matches DESIGN.md, WCAG AA contrast, no clipped descenders, Lucide icons consistent |
| **2** | Creativity | Unique concept, memorable first impression, signature element present, animation serves narrative |
| **3** | Content | No lorem ipsum, brand voice, clear hierarchy, specific CTAs |
| **4** | Usability | Mobile 375px functional, 44px touch targets, keyboard navigable, forms work, 404 page exists |
| **5** | Performance | LCP ≤ 1.8s, CLS ≤ 0.05, INP ≤ 100ms, images optimized, fonts with `font-display: swap` |
| **6** | Animation | Purpose-driven, physical easing, page transitions, signature interaction, `prefers-reduced-motion` respected |
| **7** | Technical | Build succeeds, no dead routes, no 404 assets, semantic HTML, no `transition: all` |
| **8** | Pre-Launch | Lighthouse audit, mobile test, keyboard nav test, touch target check, asset resolution check |

#### Pre-Launch Audit Sequence (Gate 8)

1. Final `bun run build` — clean build, zero errors
2. Lighthouse audit — LCP ≤ 1.8s, CLS ≤ 0.05, INP ≤ 100ms, Perf ≥ 90
3. Mobile 375px test — scroll, tap, type, check overflow
4. Keyboard navigation — Tab through the entire site
5. Touch targets — all ≥ 44×44px
6. Form exhaustiveness — fill, submit, check success/error
7. 404 crawl — navigate to `/does-not-exist`, verify branded 404
8. `prefers-reduced-motion` test — verify graceful degradation
9. Asset resolution — Network tab: zero 404s
10. Screenshot comparison — desktop + mobile, check regressions
