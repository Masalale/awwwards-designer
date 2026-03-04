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

## Version Policy & Library Docs

**No version numbers are pinned in this skill.** Always install the latest version of every library. Never hardcode a version like `gsap@3.12.7` or `lenis@1.0.42` into install commands or CDN URLs — use `@latest` or bare package names.

**Before writing integration code for any library**, use Context7 (or an equivalent MCP documentation tool) to pull its current API documentation. Library APIs shift between major versions — `smoothTouch`, `smoothWheel`, Lenis constructor options, Barba lifecycle hooks, GSAP plugin registration — all of these have changed across versions. Code from memory or from this skill's own examples may be subtly outdated. Context7 takes 5 seconds and prevents a class of bugs that are hard to debug.

**The correct lookup flow:**
1. Identify the library needed (e.g. Lenis, Barba.js, GSAP ScrollTrigger)
2. Use Context7 to resolve its library ID and fetch current docs
3. Write integration code from current docs, not from memory

This applies to: Lenis, GSAP + plugins, Barba.js, SplitType, Three.js, React Three Fiber, Theatre.js, Matter.js, Astro, TanStack Start — anything with an API surface.

---

## Philosophy: We Don't Copy Interactions. We Invent Them.

AI agents have a gravitational pull toward safe patterns. We have seen parallax backgrounds, GSAP stagger reveals, and magnetic buttons millions of times across training data. The default response is to repeat what works. This skill structurally blocks that gravitational pull.

The Invention Gate is not optional. It is not a creative exercise. It is a **mandatory checkpoint** where you must extract genuine brand metaphors, define an unrepeatable signature interaction, and document why this interaction belongs to this brand alone—before writing a single line of code.

This mandate prevents convergence. Every website built with this skill will have:
- A signature interaction that cannot be copy-pasted elsewhere
- Brand metaphors embedded in technical choices (not just color)
- Deliberate rejection of overused patterns with documented alternatives
- A thesis statement about why this interaction exists

The alternative is beautiful templates that feel like everyone else's templates.

## The Awwwards Scoring System

Awwwards judges these dimensions in this priority order:

**Design (40%)** — Visual direction, typographic hierarchy, color sophistication, layout tension, originality of visual expression. Does the design make a statement? Does it feel considered?

**Usability (30%)** — Navigation clarity, responsive behavior, accessibility, interaction feedback, load performance. Can a user navigate without friction? Is the experience fluid?

**Creativity (20%)** — Novel approaches, unexpected technical execution, signature moments, interaction paradigm innovation. Did the team invent something, or remix the expected?

**Content (10%)** — Copy quality, visual content curation, narrative structure, reason to visit. Is there substance, or just pretty pixels?

**Implementation strategy:** Design and Usability form the foundation (70% of score). These must be flawless. Creativity is the differentiation layer. If your site doesn't look premium and navigate cleanly, judges stop looking before they see your innovation. Build from the base up.

## The Invention Gate (MANDATORY)

You cannot write code until this checkpoint is complete.

The Invention Gate is a structured extraction of three brand metaphors and one signature interaction paradigm. It exists because AI agents default toward the safe, the proven, the mixable. The gate forces specificity—not inspiration, but constraint.

**Read references/invention-gate.md completely before proceeding. This is not supplementary—it is prerequisite.**

Your gate output must include:

1. **Three brand metaphors** (physical sensation, materiality, emotional trigger) — extracted from the user's brand brief or design direction. Example: "Luxury watchmaker → cold precision metal, frosted glass, vertigo before understanding."

2. **One signature interaction** with these documented elements:
   - The interaction paradigm (cursor, scroll, loading, hover, typography, or layout)
   - Brand-to-interaction mapping (why this paradigm fits the brand metaphor)
   - Rejected alternatives (what else you considered and why it failed)
   - The twist (the counterintuitive element that makes it unrepeatable)

3. **Pattern Blacklist self-check** — Does your signature interaction use any forbidden patterns without documented innovation? If yes, reinvent until the answer is no.

4. **Signature statement** formatted exactly as: "When [trigger], the brand's [tension] manifests as [interaction] using [technique]."

5. **INVENTION.md file** — Write this document to `/INVENTION.md` in the project directory before any code. It is the contract you make with yourself about what makes this site unrepeatable.

Example signature statement: "When scrolling through the portfolio, the brand's architectural precision manifests as floor-by-floor construction through a custom scroll-velocity shader that calculates structural load based on scroll acceleration."

## Icon System: Lucide Only

Every icon in every project built with this skill uses **Lucide** — no exceptions. Not Font Awesome, not Heroicons, not Phosphor, not inline SVG from random sources.

**Why Lucide:**
Lucide is a single, coherent icon system with consistent stroke weight, optical sizing, and visual language. Mixing icon libraries is the visual equivalent of mixing fonts from different type designers — even when individual icons are good, the system reads as unconsidered. Lucide's restraint matches the design philosophy of this skill.

**Usage:**
- Vanilla HTML/JS projects: `https://unpkg.com/lucide@latest` via CDN, initialised with `lucide.createIcons()`
- React/Astro: `import { ArrowRight, X, Menu } from 'lucide-react'`
- Icon size should always be set explicitly — never let it inherit unpredictably
- Stroke width: `1.5` (default) for UI icons; `1` for large decorative icons; `2` for small utilitarian icons
- Icons should be sized to optical weight, not pixel-matched — a 24px Lucide icon next to 16px body text reads correctly; a 24px icon next to 13px micro-text overpowers it

**What to avoid:**
- Font Awesome (heavyweight, inconsistent quality, signals template work)
- Heroicons (fine library, but mixing it with Lucide creates visual inconsistency)
- Phosphor, Feather, Tabler, Remix Icons — same reason: inconsistency
- Inline SVG copy-pasted from the internet (no visual system, random stroke weights)
- Emoji as interface icons (breaks in dark mode, inconsistent cross-platform rendering)

If a specific icon doesn't exist in Lucide, draw it as a minimal inline SVG that matches Lucide's stroke weight (`stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`) rather than switching libraries.

---

## Descender Safety Protocol (MANDATORY)

This is the most consistent tell of non-professional web work: descender clipping (g, y, q, p characters cut off at the bottom).

**Read references/descender-safety.md completely. This is not optional.**

Every text element larger than 48px MUST follow this protocol:

- Use the `--descender-clearance` CSS system with font-specific values
- Test with the canvas measurement technique to get actual descender depth
- Apply `padding-bottom: var(--descender-clearance)` to all headline and display text
- Use `overflow: visible` on text elements — NOT `overflow: clip` (clip ignores padding and cuts descenders at the content box edge, making padding-bottom useless)
- Use `overflow: hidden` (not `clip`) on hero/section containers so child padding is respected
- If using SplitText/SplitType, add padding-bottom to every line wrapper with `overflow: visible`
- Perform the mandatory visual check sequence at 120px scale before declaring done

Non-negotiable. Every agent output is visually validated against this protocol before launch.

## Mobile-First Consciousness

Every site built with this skill must work beautifully on mobile. Not "passably" — beautifully. Awwwards judges test on mobile, and broken mobile experiences tank Usability scores (30% of the total).

This doesn't mean a separate mobile reference file. It means mobile thinking is embedded in every decision you make:

**Design phase:** Start with the 375px viewport. The hero title, the section spacing, the grid — design them for mobile first, then expand outward. If your hero looks stunning at 1440px but cramped at 375px, you designed it backward.

**Typography:** Use `clamp()` for every font-size. The minimum value is the mobile size, the maximum is desktop. Test the minimum — at 375px, does your headline still have impact? Does the type scale still create hierarchy, or does everything collapse into the same size?

**Touch interactions:** Mobile has no hover state. Every hover effect needs a touch equivalent or graceful absence. Magnetic buttons become tap-responsive. Custom cursors are hidden on touch devices. Horizontal scroll sections need touch-friendly swipe indicators. Lenis smooth scroll should use `smoothTouch: false` — mobile browsers handle touch scroll natively and fighting them creates jank.

**Viewport units:** Use `dvh` (dynamic viewport height) instead of `vh` for hero sections. Mobile browsers have address bars that appear and disappear, making `100vh` taller than the actual visible screen. `100dvh` accounts for this.

**Safe areas:** Notched devices (iPhone, etc.) have safe area insets. If your design bleeds to the edges, use `env(safe-area-inset-top)` and friends. Navigation bars and bottom CTAs must respect these.

**Performance:** Mobile networks are slower and mobile GPUs are weaker. WebGL shaders that run at 60fps on desktop may stutter on a mid-range Android. Always provide a simpler fallback for Tier 3 effects on mobile — a static gradient instead of an animated shader, a CSS animation instead of a particle system. Use `matchMedia('(pointer: coarse)')` to detect touch devices and adjust accordingly.

**Testing:** Browser resize to 375px is not mobile testing. It misses touch behavior, safe areas, address bar interference, font rendering differences, and performance constraints. If you can't test on actual devices, at minimum use Chrome DevTools device emulation with touch simulation enabled and CPU throttling at 4x.

## Output Format: When to Use What

The skill produces different outputs depending on project complexity. Understanding when to use each format prevents the wrong tool for the job.

**Single-file HTML** — Use for single-page sites, landing pages, demos, and proofs of concept. Everything lives in one file: HTML structure, CSS in a `<style>` tag, JavaScript in a `<script>` tag. CDN-loaded libraries (GSAP, Lenis, SplitType). No build step, no bundler, instant results. This is the right choice for Tier 1 and most Tier 2 projects, and for any project where the goal is to demonstrate a concept quickly. The Chomba Creative demo is a single-file project.

**Multi-page static site** — Use when the project has multiple distinct pages (Home, About, Work, Contact) and needs page transitions (Barba.js). Still no framework — plain HTML files with shared CSS/JS. Each page follows the Barba wrapper/container structure from references/page-transitions.md. This is the right choice for agency portfolios and small business sites at Tier 2.

**Framework project (Astro, TanStack Start, Next.js)** — Use only when the project genuinely requires it: component reuse across 10+ pages, dynamic data fetching, CMS integration, or Tier 3 WebGL with React Three Fiber. The overhead of a framework (build step, node_modules, config files) is only justified when the project's complexity demands it. Most Awwwards SOTD winners are simpler than you'd expect — the impression of complexity comes from motion design, not architecture.

**Decision rule:** Start with single-file. Only move to multi-page or framework when you hit a concrete limitation (need page transitions → multi-page; need R3F components → framework). Don't reach for a framework because it feels "more professional." Judges don't see your build tools. They see your output.

## 5-Phase Process

### Phase 1: Discovery & Strategy
- Run the Invention Gate completely (extract metaphors, choose paradigm, document twist)
- Select complexity tier (Tier 1/2/3 based on brand ambition and performance requirements)
- Choose output format (single-file, multi-page, or framework) based on the decision rule above
- Audit existing brand assets (fonts, colors, imagery direction, tone)
- Build a mood board of 3-5 reference sites (NOT to copy, but to understand what emotional registers exist in the category)
- Write INVENTION.md and save to project `/INVENTION.md`

### Phase 2: Design Execution
- Start with mobile viewport (375px) — design the hero, type scale, and spacing here first
- Establish typography system using golden ratio clamp() scale (read references/aesthetic-foundations.md)
- Select luxury color palette (or build custom from principles in references/aesthetic-foundations.md)
- Design layout with broken grid, asymmetric spacing, mathematical tension
- Design signature interaction in detail — include the mobile adaptation from the start
- Plan descender safety for all display text before coding

### Phase 3: Motion & Animation
- Implement signature interaction first (this is the centerpiece)
- Build supporting micro-animations (hover states, section reveals, loading moments)
- Apply animation timing scale consistently (200ms micro, 300ms standard, 600ms section, 1000ms macro)
- For every hover effect, define the touch-device equivalent or graceful absence
- Test Lenis + ScrollTrigger sync if Tier 2 — set `smoothTouch: false`
- Validate descender safety in all animated text
- Ensure motion serves brand purpose (not decorative for decoration's sake)

### Phase 4: Technical Excellence
- Be conscious of performance throughout — don't bolt it on at the end. Preload critical fonts with `<link rel="preload">` and use `font-display: swap`. Lazy-load images below the fold. Inline critical CSS. If using WebGL, provide a lighter mobile fallback.
- Test at 375px mobile width with touch simulation and 4x CPU throttle — not just a browser resize
- Accessibility audit (WCAG 2.1 AA minimum: color contrast, keyboard nav, semantic HTML, ARIA)
- Ensure `dvh` is used instead of `vh` for full-screen sections
- Validate safe area insets on notched device simulator

### Phase 5: Pre-Launch Audit
- Run 40-item self-audit against Awwwards criteria (provided at end of this document)
- Screenshot every section at desktop, tablet, mobile
- Test signature interaction on actual devices (or device emulation with touch + CPU throttle)
- Validate descender safety one final time at actual viewport sizes
- Verify all external links work
- Check spelling and copy typos

## 3-Tier Complexity Model

Choose one tier based on brand ambition, timeline, and the nature of the signature interaction.

### Tier 1: CSS + Lightweight

**When to use:** Brand-first design, portfolio sites, landing pages where innovation is design/content, not interaction complexity.

**Tech stack:** CSS scroll-driven animations with `animation-timeline: scroll()`. Variable fonts. Vanilla JavaScript only — no GSAP, no Three.js. Can be a single HTML file or a lightweight static generator.

**Signature interactions:** Scroll parallax (velocity-based), cursor tracking with CSS variables, text scramble on load, clip-path reveals, hover state morphing.

**Performance consciousness:** This is your lightest tier. JavaScript should be negligible — a few kilobytes at most. Fonts are the heaviest asset; preload the critical weight and use `font-display: swap`. Every image should be lazy-loaded except the hero LCP image.

**Decision tree for Tier 1:**
- Is the brand premium/luxury? YES → consider Tier 2
- Is animation the key differentiator? NO → Tier 1
- Can the entire experience be told through scroll and hover? YES → Tier 1
- Budget < 1 week? YES → Tier 1

### Tier 2: GSAP + DOM

**When to use:** Brand experiences where motion is the signature moment. Sophisticated scroll interactions, text animations with descender safety. Agency portfolios, hero-driven experiences, multi-page sites with transitions.

**Tech stack:** GSAP (gsap, ScrollTrigger, SplitType). Lenis for smooth scroll (`smoothTouch: false` for mobile). Barba.js if multi-page. Can be single-file with CDN imports or a static site generator.

**Signature interactions:** SplitText character stagger (with mandatory descender safety), scroll-pinned sections with FLIP transforms, magnetic buttons (with touch fallback), context-aware cursor (hidden on touch), loading sequence with SplitType reveals, horizontal scroll sections, marquees.

**Performance consciousness:** GSAP + Lenis + SplitType together are roughly 40-50kb gzipped. That's your JavaScript floor — be conscious of what you add on top. Inline critical CSS in the `<head>`. Defer non-critical scripts. If using Barba.js, its prefetching on hover makes transitions feel instant even on slow connections. On mobile, be aware that scroll-pinned sections consume more scroll distance than they show content — test that the mobile experience doesn't feel like you're scrolling through treacle.

**Decision tree for Tier 2:**
- Is the signature interaction text-based? YES → Tier 2 with SplitType
- Does the brand need scroll interactivity? YES → Tier 2
- Is there a loading sequence? YES → Tier 2
- Are there multiple pages needing transitions? YES → Tier 2 with Barba.js

### Tier 3: WebGL + Shaders

**When to use:** Only when the brand story fundamentally requires 3D, generative, or particle-based visualization. Tech companies, AI companies, creative studios wanting to signal technical prowess.

**Tech stack:** Three.js or vanilla WebGL for shaders. React Three Fiber if the project is already React-based. Theatre.js for timeline control optional. FBO particle systems. WebAudio optional for ambient sonic branding. Use a framework (Astro, TanStack Start, Next.js) only if the project's page count and data needs justify it — otherwise a single-file or multi-file static approach works fine.

**Signature interactions:** Scroll-velocity shaders, cursor as physics attractor, FBO particle assembly, Gaussian Splatting reveal, procedurally generated content on every load, DOM-to-shader sync.

**Performance consciousness:** WebGL is GPU-bound, not CPU-bound — but mobile GPUs are dramatically weaker than desktop. Every Tier 3 project needs a mobile fallback: a simpler shader with fewer iterations, a static gradient, or a CSS-only alternative. Use `matchMedia('(pointer: coarse)')` or check `navigator.gpu` to branch. The shader should degrade gracefully, not break. Lazy-initialize the WebGL context — don't block page render waiting for shader compilation. The hero text and layout should be visible before the shader finishes loading.

**Decision tree for Tier 3:**
- Does the brand inherently involve 3D/generative/physics? YES → Tier 3
- Timeline 3+ weeks? YES → Tier 3
- Is this a technology company wanting to signal technical depth? YES → Tier 3
- Does the mobile experience have a graceful fallback planned? It must — Tier 3 is not an excuse to abandon mobile

## Micro-interaction Mandate

Every section must contain at least ONE delightful small moment. These are not full animations—they are interactions that reveal the brand's personality.

**Examples of micro-interactions by context:**

- **Hover on text link:** The cursor changes to a custom element. Text gets a background color that has padding around it (reveals whitespace design). Font weight momentarily increases (variable font wght axis). All in 200ms.

- **Scroll into section:** Before the headline animates, a decorative line or shape appears first (signals "something is about to happen"). The line has variable opacity that responds to scroll progress.

- **Hover on image:** A subtle scan-line effect appears (overlaid div with linear-gradient moving top to bottom). Or the image gets a color shift via mix-blend-mode. Not a zoom—something smaller and weirder.

- **Loading state:** Instead of a spinner, a series of dots fade in and out in sequence. The dots spell something subtle (brand acronym, a word, coordinates). The timing is irregular (not mechanically perfect) to feel intentional.

- **Cursor idle:** If the user stops moving the mouse for 2 seconds, a hint appears near the cursor ("scroll", "explore", "play"). It's small text in a custom font that fades in. Not intrusive.

- **Form input focus:** The label doesn't just move—it rotates slightly, becomes a different color, and the input gets a bottom border that draws in from left to right (clip-path animation or border-image).

- **Card hover:** The shadow changes not just in opacity but in blur and color (from cool to warm). A small icon or accent appears (fade in 200ms). The card doesn't scale—it stays fixed size (premium feel).

- **Number counter on scroll:** Numbers animate from 0 to final value as the section scrolls into view. The font-size also changes slightly (variable font wght axis increasing). Creates a feeling of data "arriving."

- **Color shift on scroll:** Background color transitions through a small palette (3-4 colors) based on scroll position. Not jarring—smooth transitions with 100ms delay between shifts.

- **Text underline on hover:** The underline doesn't grow from left to right—it appears as a small dot underneath the text, expands upward, then grows left and right (like a blooming flower). Subtle but distinctive.

These are not essential—they are brand moments. Every Awwwards-winning site has them. They prove intentionality.

## The SOTD Toolkit: Patterns That Win Awards

Research into Framer-built and Webflow-built SOTD winners reveals a consistent toolkit of patterns that appear across virtually every winning site. These aren't signature interactions (those must still be invented per-project via the Invention Gate). These are the **baseline vocabulary** — the things judges expect to see before they even evaluate creativity. A site missing these feels incomplete, the way a restaurant without bread service feels like it's cutting corners.

The insight from the Framer/Webflow ecosystem is that these patterns are so standardized that studios like Osmo (Dennis Snellenberg & Ilja van Eck, 28+ combined SOTD wins) ship them as reusable components. The craft isn't in building them — it's in composing them with taste and layering your signature invention on top.

### 1. Page Transitions (Tier 2+)

**Why it matters:** The single most impactful differentiator between a "website" and a "web experience." When navigating between pages feels like turning pages in a physical book rather than loading a new URL, judges immediately register sophistication. Osmo's entire course (used in 35+ SOTD winners) is built around this.

**Implementation:** Barba.js + GSAP. Barba handles the DOM swap (fetches the new page, replaces content without a full reload). GSAP handles the visual transition (clip-path wipes, crossfades, shared-element FLIP morphs).

**Read references/page-transitions.md for the complete Barba.js + GSAP implementation pattern, including lifecycle hooks, GSAP FLIP integration, and the persistent-element technique.**

**For single-page sites:** Page transitions don't apply, but the *feeling* they create — seamless, app-like flow — should be replicated through section transitions (scroll-driven crossfades, pinned storytelling sections).

### 2. Horizontal Scroll Sections (Tier 2+)

**Why it matters:** Breaks the tyranny of vertical scrolling. Creates a moment of spatial surprise — the user is scrolling down, then suddenly content moves sideways. It signals intentional choreography over default browser behavior.

**Implementation:** GSAP ScrollTrigger with `pin: true` on a container, translating an inner track along the x-axis. The section stays pinned while horizontal content scrolls past.

```javascript
// Horizontal scroll section — pin container, translate inner track
const track = document.querySelector('.horizontal-track');
const sections = gsap.utils.toArray('.horizontal-track .panel');

gsap.to(track, {
  x: () => -(track.scrollWidth - window.innerWidth) + 'px',
  ease: 'none',
  scrollTrigger: {
    trigger: '.horizontal-wrapper',
    pin: true,
    scrub: 1,
    end: () => '+=' + track.scrollWidth,
    invalidateOnRefresh: true,
  }
});
```

**Taste note:** Don't overuse. One horizontal section per site, maximum. It's a moment, not a layout strategy.

### 3. Marquee / Infinite Ticker (All Tiers)

**Why it matters:** Adds perpetual motion to the page even when the user isn't scrolling. It signals a living, breathing site rather than a static document. Nearly every SOTD winner has at least one.

**Implementation:** CSS-only for Tier 1 (duplicate the content, animate with `@keyframes`). GSAP for Tier 2+ (scroll-velocity-responsive speed, pause on hover, direction reversal).

```css
/* Tier 1: Pure CSS marquee */
.marquee-track {
  display: flex;
  width: max-content;
  animation: marquee 20s linear infinite;
}
.marquee-track:hover { animation-play-state: paused; }
@keyframes marquee { to { transform: translateX(-50%); } }
```

**Taste note:** Content should be meaningful (client logos, project names, testimonials), not lorem ipsum. Speed should feel unhurried — 15-25 seconds for a full cycle. Too fast feels anxious.

### 4. Text Mask / Clip Reveals (Tier 2+)

**Why it matters:** Text that reveals imagery or video behind it on scroll creates a moment of visual magic. It's the technique behind many viral Awwwards screenshots. Olivier Larose's tutorials are the canonical reference in the creative dev community.

**Implementation:** SVG `<clipPath>` or CSS `background-clip: text` with a scroll-driven position shift. The text acts as a window into media content beneath it.

```css
/* CSS text-clip reveal */
.text-mask {
  background-image: url('hero-video-poster.jpg');
  background-size: cover;
  background-position: center;
  -webkit-background-clip: text;
  background-clip: text;
  -webkit-text-fill-color: transparent;
  font-size: clamp(4rem, 12vw, 10rem);
  font-weight: 900;
}
```

**Taste note:** Works best with bold, heavy fonts (900 weight) and slow-motion video or high-contrast photography. Thin fonts don't mask enough area to be legible.

### 5. Sticky Section Storytelling / Scrollytelling (Tier 2+)

**Why it matters:** The "scrollytelling" pattern — a section pins in place while internal content transforms as the user scrolls — is the narrative backbone of editorial and product-story SOTD winners. It turns scrolling into a controlled timeline.

**Implementation:** GSAP ScrollTrigger with `pin: true` and a timeline of internal transforms (text swaps, image crossfades, progress indicators, counter animations).

```javascript
// Scrollytelling — pinned section with internal timeline
const tl = gsap.timeline({
  scrollTrigger: {
    trigger: '.story-section',
    pin: true,
    scrub: 1,
    start: 'top top',
    end: '+=300%', // 3x viewport height of scroll distance
  }
});

tl.to('.story-step-1', { opacity: 0, y: -40 })
  .from('.story-step-2', { opacity: 0, y: 40 })
  .to('.story-step-2', { opacity: 0, y: -40 })
  .from('.story-step-3', { opacity: 0, y: 40 });
```

**Taste note:** Each "step" should have enough scroll distance to feel readable — don't cram 5 transitions into 1x viewport height. The `end: '+=300%'` pattern gives each step roughly one screen of scroll.

---

These five patterns form the **SOTD baseline toolkit**. They are not substitutes for the Invention Gate — they are the canvas it paints on. A site with all five patterns but no signature interaction is a polished template. A site with a brilliant signature interaction but no smooth scroll, no transitions, and no marquee feels unfinished. You need both layers.

## Pre-Launch 40-Item Self-Audit

Complete this audit before declaring the site ready. Use the Awwwards scoring weights as your framework.

### Design (16 items, 40% weight)

- [ ] **Typography hierarchy:** Can a user instantly understand H1 > H2 > body? No visual ambiguity?
- [ ] **Color palette:** Does the palette feel luxury-first or template-first? Are there intentional warm/cool shifts?
- [ ] **Logo/brand mark:** Does it feel premium at both large (hero) and small (favicon) scales?
- [ ] **Whitespace:** Is there breathing room? Minimum 120px section padding at desktop, 80px tablet, 60px mobile?
- [ ] **Visual tension:** Is there intentional asymmetry or misalignment that signals sophistication (not accident)?
- [ ] **Typography alignment:** All display text (>48px) checked for descender safety. No g/y/q/p clipping?
- [ ] **Font selection:** Are fonts authentic to brand (not default sans-serif)? Loaded efficiently (preload critical weights)?
- [ ] **Image direction:** All images art-directed for brand (not generic stock)? AVIF/WebP provided?
- [ ] **Grid system:** Is layout on a logical grid (golden ratio, broken grid, mathematical tension)?
- [ ] **Component consistency:** Do cards, buttons, modals feel like one design system?
- [ ] **Micro-details:** Are there small delightful moments (hover states, loading sequences, cursor behavior)?
- [ ] **Responsive design:** Does layout feel intentional at mobile, tablet, desktop—not just squeezed?
- [ ] **Color contrast:** Do text colors meet WCAG AA minimum (4.5:1 body, 3:1 large text)?
- [ ] **Visual hierarchy:** Does the eye know where to look? Primary action obvious?
- [ ] **Interaction feedback:** Do buttons, links, forms give clear feedback on hover/focus/active?
- [ ] **Scroll momentum:** Does scroll feel premium (Lenis-smooth or subtle easing, not jerky default)?

### Usability (12 items, 30% weight)

- [ ] **Navigation clarity:** Can a new user find what they need in < 5 seconds? Main nav obvious?
- [ ] **Mobile navigation:** Is mobile menu usable? Touch targets > 48px? No hover-trap states?
- [ ] **Link states:** Are visited/active/hover/focus states clearly different?
- [ ] **Form usability:** Are form fields labeled? Error messages helpful? Submit button obvious?
- [ ] **Keyboard navigation:** Can you tab through the entire site? Focus states visible?
- [ ] **Accessibility:** Semantic HTML (proper heading hierarchy, alt text, ARIA where needed)?
- [ ] **Load performance:** FCP/LCP within target? Lighthouse score > 90 on mobile?
- [ ] **Mobile responsiveness:** Tested on actual devices (not just browser resize)? No horizontal scroll?
- [ ] **Footer utility:** Does footer have useful links or just boilerplate?
- [ ] **Search/filter (if applicable):** Is search fast and intuitive? Results filtered correctly?
- [ ] **Call-to-action clarity:** Primary CTA obvious? Multiple CTAs don't compete?
- [ ] **Error handling:** Are 404s, loading errors handled gracefully?

### Creativity (8 items, 20% weight)

- [ ] **Signature interaction:** Is there ONE interaction that is unrepeatable (not a standard GSAP stagger)?
- [ ] **Brand metaphor mapping:** Does the interaction come FROM the brand metaphor (documented in INVENTION.md)?
- [ ] **Innovation in technique:** Does the execution use technique in an unexpected way (not just GSAP on text)?
- [ ] **Animation purpose:** Do animations serve the narrative (not just decoration)?
- [ ] **Generative/procedural elements (if applicable):** Is there variation/randomness that rewards repeated visits?
- [ ] **Unexpected medium:** Does the signature interaction surprise (e.g., using physics simulation in unexpected context)?
- [ ] **Cursor/pointer innovation:** If custom cursor, does it serve brand (not just pretty)?
- [ ] **Loading experience:** Is the loading sequence a moment (not a spinner)?

### Content (4 items, 10% weight)

- [ ] **Copy quality:** Is writing clear, compelling, free of jargon or boilerplate?
- [ ] **Narrative structure:** Does the site tell a coherent story (not just list features)?
- [ ] **Visual content curation:** Are all images/videos intentional (not stock)? Do they advance the narrative?
- [ ] **Reason to exist:** Would a user return? Is there substance (not just pretty pixels)?

**Scoring:** If any item is unchecked, that section is incomplete. The site is not ready. Return to that section and fix it. Incomplete Design = incomplete site, regardless of Creativity score.

## Reference Files

Read these in this order:

1. **references/invention-gate.md** — The 4-step framework for extracting brand metaphors and signature interactions. READ FIRST before any design or code. This is mandatory.

2. **references/descender-safety.md** — The canvas measurement technique, CSS clearance system, and visual check sequence. READ before implementing any large text. Non-negotiable. Key rule: use `overflow: visible` on text elements, never `overflow: clip`.

3. **references/aesthetic-foundations.md** — Typography system (golden ratio clamp() scales), color palettes, layout principles, animation timing scale. READ before starting design.

4. **references/technique-families.md** — 10 technique families: 5 core (Cursor, Scroll, Loading, Hover, Typography) organized by tier with code examples, plus 5 SOTD-essential families (Page Transitions, Marquee, Horizontal Scroll, Text Mask, Scrollytelling) with philosophy-first guidance. READ when choosing your signature interaction paradigm.

5. **references/tech-stack.md** — Setup code, Lenis + ScrollTrigger sync pattern, bundle budgets, Core Web Vitals targets by tier. READ before writing code.

6. **references/anti-patterns.md** — Forbidden patterns (never use), overused patterns (require documented twist), encouraged patterns (signal ambition). READ to validate your approach doesn't hit forbidden territory.

7. **references/page-transitions.md** — Barba.js + GSAP page transition system, lifecycle hooks, FLIP shared-element morphs, persistent navigation pattern. READ for any multi-page Tier 2+ project.

---

You now have the framework. The next step is the Invention Gate. Go read references/invention-gate.md and extract your three metaphors and one signature interaction. Write INVENTION.md. Then design. Then code.

No code before the gate is complete.
