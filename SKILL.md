---
name: awwwards-v8
description: >
  Elite web design architect skill for building Awwwards-level websites — sites that can genuinely
  win or be nominated for Awwwards SOTD, SOTM, or SOTY. Use this skill for ANY request to build,
  design, or create a website, landing page, portfolio, or web experience where quality matters.
  Trigger on: "build me a site", "create a website", "landing page", "portfolio site", "agency site",
  "brand website", "web experience", "Awwwards", "award-winning", "GSAP site", "interactive site",
  "immersive site", "creative website", "design studio site", "architecture firm website",
  "fashion brand site", or any front-end project brief. Also trigger when a user describes a brand
  and wants a digital presence built — even if they don't say "website" explicitly. Do NOT trigger
  for: bug fixes on existing codebases, adding a single component to an existing site, pure backend
  tasks, or simple CSS tweaks with no design brief attached.
---

# awwwards-v8: Elite Web Design Architecture

> **The North Star:** Every project built with this skill is calibrated to win or be nominated for Awwwards SOTD, SOTM, or SOTY — the standard set by Framer and Webflow studios like Osmo and Basement Studio. Not "premium-looking." Award-winning.

---

## HARD STOPS

Read this block before anything else. These are invariant principles — true regardless of which libraries, frameworks, or techniques are current. Each one states its WHY.

1. **No code before `INVENTION.md` is written to the project root.**
   AI always gravitates toward safe, familiar patterns. The Invention Gate is the structural block that prevents convergence. If the gate hasn't run, neither has genuine invention.

2. **Output is Astro (Tier 1/2/2.5) or TanStack Start (Tier 2/3). No single HTML files — ever.**
   Not for demos. Not for proofs of concept. Not for "just testing." A single HTML file is never the deliverable. If you are about to create an `.html` file as the project output, stop and scaffold the correct framework instead.

3. **Use one coherent icon system throughout the entire project. Never mix libraries.**
   Visual consistency is a design principle, not a library preference. One set of stroke weights, one optical language. Mixing systems produces visual noise agents rarely notice but judges always see. Current recommendation: Lucide. If you know something better, use that — one system, consistently.

4. **`overflow: visible` on all display text elements. Never `overflow: clip`.**
   Descenders (g, y, q, p) extend below the content box. `overflow: clip` ignores `padding-bottom` and severs them regardless of spacing. `overflow: hidden` is acceptable on containers. `clip` on text elements is never acceptable.

5. **`dvh` not `vh` for any full-screen section.**
   Mobile browser address bars appear and disappear, making `100vh` taller than the visible screen. `100dvh` accounts for this dynamically. Browser reality, not preference.

6. **Never fight the mobile browser's scroll. Delegate touch to the browser.**
   Overriding native touch scroll creates jank on mobile devices. Current implementation: `smoothTouch: false` on Lenis. Future agents: honor this principle with whatever is current.

7. **Always fetch current API docs before writing integration code.**
   Library APIs shift between major versions — GSAP plugin registration, Lenis constructor options, Barba lifecycle hooks have all changed before. Training data is not current documentation. Use Context7 or equivalent before writing any integration code.

8. **Descender safety protocol is mandatory for all display text >48px.**
   Descender clipping is typographic law — a font metric reality, not a trend. Measure actual descender depth, apply `padding-bottom`, verify at all viewport sizes. See `references/descender-safety.md` for the complete protocol.

9. **Read `references/anti-patterns.md` before design begins.**
   The Pattern Blacklist contains forbidden patterns and overused patterns requiring a documented twist. No exceptions. Read it before committing to any design direction.

---

## Philosophy

AI agents have a gravitational pull toward safe patterns. Parallax backgrounds, GSAP stagger reveals, magnetic buttons — the training data has seen them millions of times. The default response is to repeat what works.

This skill structurally blocks that pull. The Invention Gate forces extraction of genuine brand metaphors and demands a signature interaction that cannot be copy-pasted elsewhere. Every project has a thesis statement about why this interaction belongs to this brand alone. Every rejected alternative is documented.

The alternative is beautiful templates that feel like everyone else's templates. That is not what we build here.

---

## Awwwards Scoring

**Design 40% · Usability 30% · Creativity 20% · Content 10%**

Design and Usability form the foundation (70% of the score). These must be flawless — if the site doesn't look premium and navigate cleanly, judges stop looking before they reach your innovation. Build from the base up. Creativity is the differentiation layer, not the starting point.

---

## Execution Sequence

Work through these steps in order. Each reference is read at the moment it becomes relevant — not all upfront.

**Step 1 — Invention Gate (mandatory)**
Read `references/invention-gate.md` completely. Extract three brand metaphors. Choose one signature interaction paradigm. Document the twist. Write `INVENTION.md` to the project root. Do not continue until this file exists.

**Step 2 — Color System**
Invoke the `brand-color-psychology` skill. Feed it the brand brief plus all three metaphors from INVENTION.md. Use its Blue Ocean strategy to audit competitors, its Archetype Color Framework to identify the right palette territory, and its 60-30-10 rule to structure the output. Present the proposed palette to the user for approval. Do not write a single color token until the user confirms. Once confirmed, document all colors in HEX, RGB, and as CSS custom properties. Colors are user-owned — brand-color-psychology proposes, the user decides.

**Step 3 — Synthesis**
Read `references/synthesis.md`. Translate your INVENTION.md into binding execution decisions: lerp factor, brand easing curve, hero structure for first 3 seconds, scroll phase ratios. These decisions are derived — not chosen freely.

**Step 4 — Section Architecture**
Read `references/section-architecture.md`. Define the section sequence as a narrative argument derived from brand metaphor. Every section has a job. No generic sections (About, Services, Contact). Build the argument structure before touching layout code.

**Step 5 — Design System**
Read `references/aesthetic-foundations.md`. Build the typography system. Read `references/easing-language.md` — derive the brand easing curve from Metaphor 1 and name it. Colors are provided by the user — do not derive or invent them. Start at 375px mobile first.

**Step 6 — Project Setup**
Read `references/tech-stack.md`. Set up Astro (Tier 1/2/2.5) or TanStack Start (Tier 2/3). No other frameworks.

**Step 7 — Build Pages First**
Build the complete page structure — all layouts, all sections, all content — before any interaction code. A project with scripts but no pages is not a project.

**Step 8 — Signature Interaction**
Read `references/technique-families.md`. Implement the signature interaction using synthesis decisions from Step 2. Build the engine: Lenis → gsap.ticker → outputs. One timing source. Everything runs from it.

**Step 9 — Pattern Validation**
Read `references/anti-patterns.md`. Run the Pattern Blacklist self-check. No forbidden patterns. No overused patterns without a documented twist.

**Step 10 — Page Transitions (conditional)**
Multi-page Tier 2+ only: read `references/page-transitions.md`. Implement Barba.js + GSAP transitions.

**Step 11 — Descender Safety**
Every text element >48px: open `references/descender-safety.md`. Apply canvas measurement. Add `padding-bottom`. Verify `overflow: visible`.

**Step 12 — Pre-Launch Audit**
Read `references/audit.md`. Run every check. The site is not ready until the audit is clean.

---

## 3-Tier Complexity Model

Choose one tier before setup. This choice determines your stack, your bundle budget, and the nature of your signature interaction.

**Tier 1: CSS + Lightweight**
Brand-first design where innovation is visual, not interactive. CSS scroll-driven animations, variable fonts, vanilla JavaScript only — no GSAP, no Three.js. Signature interactions: clip-path reveals, cursor tracking with CSS variables, text scramble on load, scroll parallax.
→ *Choose when: innovation is in design and content. Timeline under 1 week.*

**Tier 2: GSAP + DOM**
Sophisticated scroll interactions and text animations where motion is the signature moment. GSAP + ScrollTrigger + SplitType + Lenis. Barba.js for multi-page transitions. Agency portfolios, hero-driven experiences.
→ *Choose when: signature interaction is text- or motion-based. Loading sequence is planned. Page transitions are needed.*

**Tier 2.5: GSAP + Light 3D**
Tier 2 with one of: CSS 3D transforms (`perspective`, `rotateX/Y`, `translateZ`), a single Three.js mesh, or a CSS perspective grid layout. Justified only when the Invention Gate produces a metaphor that explicitly calls for physical depth, sculpture, or spatial dimension.
→ *Choose when: brand metaphor involves 3D space, architecture, or physical product. A flat 2D treatment would feel like it's missing something the brand needs.*

**Tier 3: WebGL + Shaders**
Brand story fundamentally requires 3D, generative, or particle-based visualization. Three.js or vanilla WebGL. React Three Fiber if already in a React context. Every Tier 3 project requires a mobile fallback — simpler shader, static gradient, or CSS alternative.
→ *Choose when: brand inherently involves 3D/generative/physics. Timeline 3+ weeks. Technology company signaling technical depth.*

---

## SOTD Toolkit: The Baseline Canvas

These five patterns appear across virtually every Awwwards SOTD winner. They are not the signature interaction — they are what judges expect to see before evaluating creativity. A site with a brilliant signature interaction but none of these feels unfinished.

1. **Page Transitions** — The single biggest differentiator between a website and a web experience. Barba.js + GSAP. See `references/page-transitions.md` for the complete implementation.

2. **Horizontal Scroll Sections** — Breaks the tyranny of vertical scrolling. One section per site maximum. GSAP ScrollTrigger `pin: true`. See `references/technique-families.md` → Scroll family.

3. **Marquee / Infinite Ticker** — Brand-gated: content must be worth repeating in motion. Client logos, real project names, real testimonials — not generic copy. One per site. See `references/technique-families.md` → Scroll family.

4. **Text Mask / Clip Reveals** — Text as a window into imagery or video. `background-clip: text` or SVG `<clipPath>`. Works best with heavy fonts (900 weight). See `references/technique-families.md` → Typography family.

5. **Sticky Scrollytelling** — Section pins while internal content transforms as the user scrolls. GSAP ScrollTrigger `pin: true` with a timeline of internal transforms. See `references/technique-families.md` → Scroll family.

---

## Icon System

Use one coherent icon system throughout the entire project. Current recommendation: **Lucide**.

- Vanilla HTML: CDN via `unpkg.com/lucide@latest`, initialised with `lucide.createIcons()`
- Astro/React: `import { ArrowRight } from 'lucide-react'`
- Stroke weight: `1.5` (default UI) · `1` (large decorative) · `2` (small utilitarian)
- Size to optical weight — not pixel-matched
- If an icon doesn't exist in the system: draw it as minimal inline SVG matching the library's stroke weight (`stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`)
- Never use emoji as interface icons

---

## Mobile-First Mandates

Design starts at 375px. These mandates are non-negotiable regardless of tier or project type.

- `100dvh` on all full-screen sections — never `100vh`
- `env(safe-area-inset-*)` for navigation and bottom CTAs on notched devices
- `matchMedia('(pointer: coarse)')` to detect touch devices and disable hover-only interactions
- Custom cursors must be hidden on touch devices
- Never override native touch scroll — delegate it to the browser
- Every hover effect needs a touch equivalent or graceful absence — no hover traps
- Tier 3 WebGL scenes must have a mobile fallback (simpler shader, CSS alternative, or static)
- Test with touch simulation and 4x CPU throttle — browser resize is not mobile testing
