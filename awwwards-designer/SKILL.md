---
name: awwwards-designer
description: >
  Awwwards-level website builder powered by Google Stitch. Takes a brand brief, generates
  award-quality UI designs via Stitch MCP, then enhances the output with a bespoke
  animation and interaction layer — scroll effects, page transitions, 3D scenes, and
  signature interactions derived from the brand metaphor. Built on TanStack Start.
  Targets Awwwards SOTD/SOTM/SOTY.
---

# Awwwards + Stitch: 5-Phase Execution Skill

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

---

## Phase 1: Brief Interview

Ask the user these 6 questions to extract everything the Invention Gate needs:

1. What does the brand do and what does it stand for?
2. Who is the target audience?
3. What tier of animation? (1: CSS-only | 2: JS-enhanced | 2.5: light 3D | 3: WebGL/shaders)
4. How many pages and what content on each?
5. Are there any interactive or data-driven sections — forms, logins, dashboards, listings, checkout flows? If yes, describe each briefly.
6. Any reference sites that capture the desired feel? (optional)

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

Following the format in `references/stitch-brief.md`:
- Framework declaration (first — sets the ground rules for Stitch's output format)
- Brand identity, aesthetic direction, typography, color, icons, page structure, device target
- NO animation, 3D, or interaction instructions in the Stitch prompt

**Output:** Animation map (user-confirmed) + Stitch prompt.

**Gate:** Both documents must exist and the animation map must be user-confirmed before proceeding to Phase 3.

---

## Phase 3: Stitch MCP

Drive Google Stitch programmatically via MCP to generate the design and build the project. Stitch adapts its output format based on the framework declared in the Stitch prompt.

### 3.1 Create Project
Call `create_project` via Stitch MCP. Once the project ID is returned, display the canvas link to the user:
```
Your Stitch canvas: https://stitch.withgoogle.com/project/{projectId}
```
Screens will appear here live as they are generated.

### 3.2 Generate Screens
Call `generate_screen_from_text` for each page using the Stitch prompt from Phase 2.
- Set `deviceType: "DESKTOP"`
- Screen generation takes 2-10 minutes per screen. Wait for completion before generating the next.

### 3.3 Review Gate
After all screens are generated, prompt the user:
```
All screens are live at your Stitch canvas. Review and edit them until you're happy,
then reply here when you're ready to build.
```
Wait for explicit user confirmation before proceeding.

### 3.4 Build Site
Call `build_site` with the project ID and route mappings:
- Map each screen to its URL route (e.g., screenA -> "/", screenB -> "/work")
- Output: Project in the declared framework with Tailwind HTML, one page per route

### 3.5 Extract Design Context
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
