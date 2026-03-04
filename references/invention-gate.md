# The Invention Gate: Mandatory Pre-Code Framework

## Gate Philosophy: Structure Blocks Gravitational Pull

AI agents have been trained on millions of websites. That training creates a gravitational pull toward safe patterns. When asked to build a website, the default response is to reach for:

- GSAP y: 40px stagger reveal on text
- mix-blend-mode: difference cursor
- Standard magnetic buttons
- Parallax background images
- Basic split-text character stagger
- Blur backdrop navigation

These patterns work. They're proven. They're in the training data millions of times. The agent's internal reward signal says: "These are safe choices."

The Invention Gate is a structural checkpoint that blocks this pull. It forces specificity before implementation. The gate is not a creative exercise. It is not inspirational. It is a **mandatory document** that must be written and saved before a single line of code is written.

You cannot proceed to design or code until:

1. Three brand metaphors are extracted (not invented—extracted from the brief)
2. One signature interaction paradigm is chosen
3. That paradigm is mapped to a brand metaphor with documented reasoning
4. At least two alternative approaches are rejected with documentation of why they failed
5. A counterintuitive twist is added to the paradigm (the part that makes it unrepeatable)
6. A signature statement is written in the exact prescribed format
7. An INVENTION.md file is created and saved to the project

This is the contract you make with yourself before building.

---

## The 4-Step Invention Framework

### Step 1: Extract Three Brand Metaphors

Brand metaphors are not invented. They are extracted from the brand brief, visual direction, client positioning, or your immediate sensory impression of the brand.

Do not overthink this. The metaphor is what it *feels* like, not what it *means*.

For each metaphor, answer a specific question:

**Metaphor 1: Physical Sensation**
- Question: "If I could touch the brand, what texture would it be?"
- Not: "The brand is sophisticated"
- But: "The brand feels like cold steel, precisely machined, edges you wouldn't accidentally cut yourself on. Not dangerous—just exact."
- Or: "The brand feels like warm wood that's been handled thousands of times. Smooth, responsive, has absorbed something from constant use."
- Or: "The brand feels like silk being pulled taut. Tension without strain. The moment before the cloth tears but it doesn't."

**Metaphor 2: Materiality**
- Question: "What material is this brand made of?"
- Not: "The brand is elegant"
- But: "The brand is liquid mercury—reflective, responsive to even tiny vibration, impossible to hold perfectly still, constantly shifting."
- Or: "The brand is frosted glass. You can see through it, but not clearly. There's something behind it that matters more than what you see on the surface."
- Or: "The brand is oxidized copper. Starts shiny and bright, but develops a patina over time. The patina is where the value lives."

**Metaphor 3: Emotional Trigger**
- Question: "What feeling does the brand invoke in the person encountering it?"
- Not: "The brand is premium"
- But: "The brand invokes vertigo—the good kind. Standing at a height and feeling the pull down. Slightly disorienting but thrilling. You want to go back to the edge."
- Or: "The brand invokes serenity. The pause before you speak. The silence after a question when the answer is starting to form."
- Or: "The brand invokes electric tension. The moment before lightning. The air has changed, something is about to happen."

**Where do these come from?**
- The brand brief (explicit language)
- The logo or visual mark (what does it evoke sensorily)
- The client's language (how do they describe their work)
- Your gut impression (what's the first feeling, not the thought)
- Competitor positioning (what do other brands in this space feel like, so this one can be the inverse)

### Step 2: Choose Interaction Paradigm (ONE)

You will choose ONE of these six paradigms. Your signature interaction will live within this paradigm.

**Paradigm 1: Cursor**
- The pointer itself becomes expressive
- How the cursor moves, changes shape, responds to proximity, trails, distorts
- Best for: brands that want to signal constant engagement, precision, playfulness
- Example: luxury watchmaker's cursor rotates like watch hands based on mouse position

**Paradigm 2: Scroll**
- Content movement through time becomes the signature moment
- How sections reveal, parallax, pin, how text moves through the viewport
- Best for: narrative-driven sites, portfolios, manifesto-style brands
- Example: building construction site that assembles in real-time as you scroll

**Paradigm 3: Loading/Reveal**
- The first moment the user encounters the site (loading sequence, hero reveal) is the signature
- How the page introduces itself, what appears first, how content assembles
- Best for: agencies, studios, festival/event sites where anticipation matters
- Example: wine company where loading screen fills a glass with particle simulation

**Paradigm 4: Hover**
- Engagement moments become the signature (what reveals on hover, focus, interaction)
- How elements respond when touched or approached
- Best for: product sites, gallery experiences, discovery-driven content
- Example: images don't zoom on hover—they slowly come into focus like a darkroom developing

**Paradigm 5: Typography**
- Text itself becomes the medium of expression
- How text moves, breathes, scrambles, transforms, changes weight/width based on interaction
- Best for: editorial sites, manifesto brands, sites where copy is as important as imagery
- Example: variable font weight increases as you scroll through a section (building momentum)

**Paradigm 6: Layout**
- Space itself transforms as the user interacts or scrolls
- Grid reshuffles, columns merge/split, whitespace expands/contracts
- Best for: architecture firms, construction companies, spatial experiences
- Example: portfolio items aren't cards that zoom—they're architectural blueprints that collapse into single lines, then expand into full sections

**How to choose:**
- Which paradigm does your brand metaphor naturally point toward?
- Which interaction would make someone say "I've never seen that before"?
- Which paradigm can you execute at your chosen complexity tier without faking it?
- Which would make returning to the site rewarding (not just loading it once)?

### Step 3: Select Complexity Tier & Output Format

Based on your brand ambition and timeline, choose your technical ceiling. Then choose your output format.

**Tier 1: CSS + Lightweight**
- No GSAP, no Three.js — pure CSS scroll-driven animations, variable fonts, clip-path reveals
- Output: Single HTML file (CDN imports if needed) or lightweight static generator
- Timeline: ~1 week
- Technical ambition: High-confidence execution of elegant, simple interactions
- Mobile: Full mobile support expected — Tier 1 has no excuse for mobile gaps

**Tier 2: GSAP + DOM**
- GSAP, ScrollTrigger, SplitType, Lenis (`smoothTouch: false`), Barba.js if multi-page
- Output: Single HTML file for single-page; plain HTML files + shared JS/CSS for multi-page; Astro if component reuse is needed
- Timeline: ~2 weeks
- Technical ambition: Sophisticated motion, text animation, scroll-based orchestration, page transitions
- Mobile: Every hover effect needs a touch equivalent or graceful absence; no horizontal scroll traps on mobile

**Tier 3: WebGL + Shaders**
- Three.js or vanilla WebGL, GLSL shaders, FBO particles, WebAudio, Theatre.js optional
- Output: Single file for shader-only hero; React Three Fiber + framework (Astro, Next.js) only when component complexity demands it
- Timeline: 3+ weeks
- Technical ambition: Signals deep technical prowess, pushing browser capabilities
- Mobile: **Not optional.** Every Tier 3 project needs a mobile fallback — simpler shader, static gradient, or CSS animation. Use `matchMedia('(pointer: coarse)')` to branch. Judges test on phones.

**Output format decision rule:** Start with single-file. Move to multi-page only when you need page transitions (Barba.js). Move to a framework only when component reuse across 10+ pages or dynamic data demands it. Judges see your output, not your build tools.

If you're unsure on tier, choose Tier 2. It hits the premium bar without overextending.

### Step 4: Combine & Twist

Now combine your metaphors, paradigm choice, and tier selection. Then add the twist.

**Formula:**
```
[Paradigm] + [Material Metaphor] + [Unexpected Medium] = Signature Interaction
```

**What is the twist?**

The twist is the counterintuitive element that no one else would think to add. It's what makes the interaction unrepeatable. It's the thing that makes someone say "wait, why is the cursor doing that?" not because it's confusing, but because it's surprising and then instantly makes sense.

Examples:

1. **Luxury Watchmaker (Tier 2)**
   - Metaphor: Cold precision metal, frosted glass, vertigo before understanding
   - Paradigm: Scroll
   - Twist: Each scroll tick advances time. The watch hands rotate based on scroll velocity (not just position). Scroll faster = watch hands move faster. The user is literally controlling time.
   - Why twist works: Connects the interaction to the core business (timekeeping) in an unexpected way. Not decorative, not a visual metaphor—it's a *functional* metaphor.

2. **Dance Company (Tier 2)**
   - Metaphor: Kinetic energy in stillness, silk under tension, electric anticipation
   - Paradigm: Cursor
   - Twist: The cursor IS a dancer. Mouse movement creates motion trails that look like long-exposure photography. The cursor doesn't follow the mouse—it lags behind and moves fluidly, like a body moving through space.
   - Why twist works: The cursor becomes the brand's primary medium of expression. Every interaction is a dance.

3. **Natural Wine Producer (Tier 3)**
   - Metaphor: Living liquid, sediment, imperfection, serenity in uncertainty
   - Paradigm: Loading/Reveal
   - Twist: The loading screen is a wine glass filling with particle simulation (Matter.js physics). Sediment particles drift and settle. The glass fills at the rate of page load. You're not waiting for a progress bar—you're watching fermentation happen in real time.
   - Why twist works: The loading experience IS the product experience. Impatience becomes appreciation of a natural process.

4. **Digital Art Gallery (Tier 2)**
   - Metaphor: Frosted glass (seeing but not clearly), pause before understanding, vertigo
   - Paradigm: Hover
   - Twist: Images don't zoom or brighten on hover. They slowly come into focus as if a camera lens is sharpening. The longer you hover, the more detail emerges from blur. At maximum focus, you see fine details (artist signature, technique marks).
   - Why twist works: Replicates the experience of approaching an art piece in person and letting your eye focus. The interaction teaches the user to look closely.

5. **Architecture Firm (Tier 2)**
   - Metaphor: Concrete and light, precision, structural integrity, cold clarity
   - Paradigm: Scroll
   - Twist: Building sections are revealed as if being constructed in real-time. As you scroll, floors appear bottom-to-top. Structural elements (beams, columns) draw themselves with SVG stroke animation. The next section doesn't scroll in—it's *built* as you scroll.
   - Why twist works: The interaction IS the discipline. You experience architecture being assembled.

---

## The Pattern Blacklist: Automatic Rejection

If your signature interaction uses any of these patterns WITHOUT a documented twist, it fails the gate and must be reinvented:

**FORBIDDEN (No exceptions):**
- GSAP y: 40px stagger reveal on heading text (too common)
- mix-blend-mode: difference cursor (instant tell of template work)
- Standard magnetic button (every agency site)
- Mesh gradient background (2024 cliché)
- Parallax background image (2015 web)
- Basic SplitType character stagger with identical timing (overplayed)
- Blur backdrop navigation panel (Tailwind template default)
- Scroll-triggered fade opacity reveal (invisible when done right, overused when not)

**Why forbidden:** These patterns have been executed thousands of times across the web. Judges have seen them before. If your site uses them without innovation, the site looks like everyone else's.

**OVERUSED (Requires documented twist to use):**
- Mix-blend-mode: difference cursor → Reinvent as context-aware cursor that changes based on element type
- GSAP y: 40px stagger → Reinvent as directional reveals where direction corresponds to brand meaning
- Magnetic buttons → Reinvent as physics-based button with momentum/drag simulation
- SplitType with standard stagger → Reinvent as variable timing (heavier characters slower), or conditional animation (animate only vowels), or stagger based on character weight
- Standard mesh gradient → Reinvent as generative gradient responding to scroll/time/interaction
- Parallax background → Reinvent as parallax that carries narrative meaning (parallax speed = thematic weight)
- Floating nav with blur → Reinvent as nav that reveals brand character (color shift, brand mark transforms, etc.)

**ENCOURAGED (Signals ambition):**
- MSDF 3D text rendering (text as 3D geometry in WebGL — impossible in DOM)
- DOM-to-shader sync (CSS values / scroll progress drive GLSL uniforms in real-time)
- Scroll-velocity shaders (scroll *speed*, not position, drives shader distortion)
- Cinematic timeline sequencing (Theatre.js or deeply nested GSAP timelines, Hollywood-grade orchestration)
- FBO (Framebuffer Object) particles (GPU-simulated, tens of thousands at 60fps)
- Gaussian Splatting on the web (3D neural reconstruction rendered in WebGL)
- Variable font axes as living typography (interaction drives font-variation-settings — push beyond basic weight)
- Generative variation (procedural algorithms ensure no two visits are identical)
- Generative WebAudio (ambient sound modulated by interaction — always opt-in)
- Canvas text decomposition (pixel data drives particle systems, text as data source)
- Physics-driven UI (Matter.js, Rapier.js — elements with real weight and momentum)
- WebGPU compute shaders (fluid simulations, parallel compute — bleeding edge, provide WebGL fallback)
- View Transitions API (native browser page transitions — hybrid with GSAP for complex choreography)
- Image sequences with alpha compositing (JPEG color + PNG alpha on canvas, scroll-scrubbed)

---

## The Signature Statement

Write your signature statement in this exact format:

```
"When [specific user trigger], [brand tension/metaphor] manifests as [specific technical implementation]
through [unique twist that makes it unrepeatable]."
```

This statement is your thesis. It should:
- Be exactly one sentence
- Reference the user action that triggers the interaction
- Name the brand metaphor or tension that drives it
- Specify HOW it manifests technically (not vaguely—be specific)
- End with the twist

**Examples:**

1. "When scrolling through the portfolio, the brand's architectural precision manifests as floor-by-floor construction through custom scroll-velocity shaders that calculate structural load based on scroll acceleration, making the user's scrolling speed literally affect building weight."

2. "When hovering over an artwork, the brand's hesitation before understanding manifests as progressive lens focus through canvas blur filters, where the descender of the pointer position directly maps to focal depth, rewarding slow, deliberate exploration."

3. "When the page loads, the brand's fermentation story manifests as a wine glass filling with physically-simulated sediment particles through Matter.js, where particles settle at the same rate as page resources load, transforming impatience into appreciation."

4. "When moving the cursor, the brand's kinetic grace manifests as motion trails that mimic long-exposure dance photography through a custom trail renderer, where the cursor lag factor responds to recent velocity, making every movement feel like a performer extending a gesture."

5. "When scrolling enters a typography section, the brand's momentum builds through variable font weight that increases proportionally to scroll velocity, using GSAP ticker to drive font-variation-settings in real-time, so speed directly correlates to typographic weight."

**Note:** Your signature statement should be specific enough that someone could understand exactly what will happen on the site. Not vague ("smooth animations"), but precise ("scroll velocity drives shader distortion factor").

---

## INVENTION.md Template

Create this file in the project root before beginning design or code. Fill it out completely. Save it. Reference it throughout development.

```markdown
# INVENTION.md

**Project:** [Brand Name]
**Date:** [YYYY-MM-DD]
**Complexity Tier:** [Tier 1 / Tier 2 / Tier 3]

## Brand Metaphors

### Metaphor 1: Physical Sensation
[What does the brand feel like if you touch it?]
Example: "The brand feels like cold steel, precisely machined..."

### Metaphor 2: Materiality
[What material is the brand made of?]
Example: "The brand is liquid mercury—reflective, responsive..."

### Metaphor 3: Emotional Trigger
[What feeling does the brand invoke?]
Example: "The brand invokes vertigo—the good kind..."

## Signature Interaction

### Chosen Paradigm
[Cursor / Scroll / Loading / Hover / Typography / Layout]

### Brand-to-Paradigm Mapping
Why does this paradigm fit the brand metaphor?
[1-2 sentences of reasoning]

### Rejected Alternatives
What else did you consider? Why did it fail?

**Alternative 1:** [Paradigm]
- Why rejected: [specific reason]

**Alternative 2:** [Paradigm]
- Why rejected: [specific reason]

### The Twist
What is the counterintuitive element that makes this unrepeatable?
[2-3 sentences describing the twist]

### Technical Implementation (Brief)
[1-2 sentences describing the general technical approach]
- Tier-specific details: [any specific libraries, techniques, or constraints]

### Signature Statement
When [trigger], the brand's [metaphor] manifests as [implementation] through [twist].

## Validation

- [ ] All three metaphors extracted from brand brief
- [ ] Paradigm chosen consciously (not defaulted to)
- [ ] At least 2 alternatives considered and rejected
- [ ] Signature statement is specific and testable
- [ ] Interaction doesn't use Pattern Blacklist without documented twist
- [ ] Complexity tier chosen matches brand ambition and timeline

## Notes
[Any additional context, constraints, or reminders for development]

---

**Status: GATE PASSED - Ready for Design & Development**
[Date gate passed: YYYY-MM-DD]
```

---

## Real Brand Archetypes: Worked Examples

These are real, worked examples of the Invention Gate applied to different brand types. Use these as templates for your own gates.

### Example 1: Luxury Watchmaker

```
BRAND METAPHOR 1 — Physical Sensation:
The brand feels like precise, cold steel. Edges are sharp but not dangerous.
Every detail is exact. There's no wasted motion, no decoration that doesn't
serve a function. Holding it, you feel the weight of intention.

BRAND METAPHOR 2 — Materiality:
The brand is made of frosted glass. You can see something is behind it,
but not clearly. The thing behind matters more than the surface.

BRAND METAPHOR 3 — Emotional Trigger:
The brand invokes vertigo—the moment before understanding when the magnitude
of precision becomes apparent. Standing at a height and feeling the quality
of the air. Disorienting but absolutely clear.

PARADIGM CHOICE: Scroll

BRAND-TO-PARADIGM MAPPING:
A watch measures time. Scrolling measures progress through content.
By mapping scroll velocity to watch hand rotation, the user literally
controls time. The paradigm becomes functional, not decorative.

REJECTED ALTERNATIVES:
1. Cursor Paradigm — cursor rotates like watch hands. Rejected because
   it's one-to-one mapping, literal, not surprising. Watch hands are
   expected on a watch site.
2. Hover Paradigm — images reveal detail on hover. Rejected because
   it doesn't connect to core business (timekeeping). It's pretty
   but disconnected.

THE TWIST:
Watch hands don't just rotate based on scroll POSITION.
They rotate based on scroll VELOCITY. Scroll slowly = hands move slowly.
Scroll fast = hands move fast. The user's scrolling speed IS the source
of time. The scroll bar becomes a crank that winds the watch.

SIGNATURE STATEMENT:
"When scrolling through the portfolio, the brand's precision manifests as
active timekeeping through scroll-velocity shader calculation, where the
user's scroll speed directly rotates watch hands, making content consumption
a temporal act."

IMPLEMENTATION:
Tier 2 — GSAP ticker listens to scroll velocity, drives SVG rotation.
Or Tier 3 — scroll velocity fed as uniform to GLSL shader that rotates
textured watch face.
```

### Example 2: Dance Company

```
BRAND METAPHOR 1 — Physical Sensation:
The brand feels like silk being pulled taut. There's tension but no strain.
It's responsive—even breathing changes the surface. It holds shape but is
alive underneath.

BRAND METAPHOR 2 — Materiality:
The brand is kinetic energy in stillness. A dancer between movements.
The potential for motion is more important than motion itself.

BRAND METAPHOR 3 — Emotional Trigger:
The brand invokes electric anticipation. The moment before a performance
begins. Everyone is watching. The air has changed.

PARADIGM CHOICE: Cursor

BRAND-TO-PARADIGM MAPPING:
Dancers move through space continuously. The cursor is the one element
that's always moving (or can move). Making the cursor expressive turns
every mouse movement into a performance.

REJECTED ALTERNATIVES:
1. Scroll Paradigm — sections animate as you scroll. Rejected because
   scroll is passive (content moves toward you). Dancers are active agents.
2. Hover Paradigm — elements respond on hover. Rejected because hover
   is responsive, not initiatory. Dancers initiate movement.

THE TWIST:
The cursor doesn't follow the mouse. It lags behind and creates motion trails
that look like long-exposure photography of movement. The trails fade out
over time, creating a persistent ghost of every movement. The cursor itself
is semi-transparent, and trails are a darker opacity. Multiple trails layer.
It's like watching a dancer's movement from a 1-second exposure.

SIGNATURE STATEMENT:
"When moving the cursor, the brand's kinetic grace manifests as motion trails
through long-exposure rendering, where cursor lag and trail persistence create
a 1-second photographic memory of every movement."

IMPLEMENTATION:
Tier 2 — Custom cursor tracking with GSAP quickTo (0.2s lag), trail canvas
rendering with fade animation. Or Tier 3 — FBO trail rendering in WebGL
for smoother performance at high move frequencies.
```

### Example 3: Natural Wine Producer

```
BRAND METAPHOR 1 — Physical Sensation:
The brand feels like living liquid. Always moving, never quite settled.
There's sediment and imperfection. It's organic in a way that mass-produced
things aren't.

BRAND METAPHOR 2 — Materiality:
The brand is fermentation. Becoming, not being. Change is happening at
microscopic scale. You can't see it, but you know it's there.

BRAND METAPHOR 3 — Emotional Trigger:
The brand invokes serenity. The patience required to let something develop
at its own pace. The knowledge that rushing damages the outcome.

PARADIGM CHOICE: Loading/Reveal

BRAND-TO-PARADIGM MAPPING:
Fermentation takes time. Most websites hide this time under a progress bar.
But wine's magic IS the time. Making the loading experience mirror
fermentation transforms waiting from a negative (impatience) to a positive
(appreciation of process).

REJECTED ALTERNATIVES:
1. Scroll Paradigm — sections animate as you scroll. Rejected because
   fermentation isn't fast or controlled. Scrolling feels too active.
2. Hover Paradigm — interactive elements on hover. Rejected because
   fermentation doesn't respond to touch. It's autonomous, indifferent.

THE TWIST:
The loading screen is a wine glass filling with physically-simulated sediment
particles (Matter.js). Particles drift, collide, settle to the bottom. The
glass fills at the rate of actual page load (resource completion). You're
not waiting for a progress bar. You're watching fermentation.

SIGNATURE STATEMENT:
"When the page loads, the brand's fermentation story manifests as a glass
filling with physically-simulated sediment particles through Matter.js,
where particle settlement rate matches resource load completion, transforming
impatience into participation."

IMPLEMENTATION:
Tier 2 — Matter.js physics simulation in canvas, synced to fetch Promise
completion with GSAP timeline. Or Tier 3 — Three.js particle system with
custom physics shader.
```

### Example 4: Digital Art Gallery

```
BRAND METAPHOR 1 — Physical Sensation:
The brand feels like approaching something precious. Each step closer
reveals more detail. There's distance and intimacy simultaneously.

BRAND METAPHOR 2 — Materiality:
The brand is frosted glass with light behind it. You see the silhouette
first, details only come into focus when you're close.

BRAND METAPHOR 3 — Emotional Trigger:
The brand invokes the pause before understanding. That moment in a museum
when you step back from a painting and let your eye settle in. Vertigo
before comprehension.

PARADIGM CHOICE: Hover

BRAND-TO-PARADIGM MAPPING:
In a physical gallery, you approach artworks and your eye focuses. Hovering
is the digital equivalent of approach. Making focus literally increase on
hover connects interaction to physical experience.

REJECTED ALTERNATIVES:
1. Click Paradigm — images zoom on click. Rejected because it's a definite
   action, not exploratory. Galleries are about browsing at your own pace.
2. Scroll Paradigm — images animate as you scroll. Rejected because it's
   passive. The gallery visitor is active, not the content.

THE TWIST:
Images don't zoom or brighten on hover. They come into focus as if through
a camera lens. Blur decreases progressively. At maximum focus, the viewer
can see artist's technique details (brushstrokes, texture, signature).
Hovering longer = more focus. Leaving removes focus. It's not a visual effect
applied—it's the experience of focusing your eye on a physical artwork.

SIGNATURE STATEMENT:
"When hovering over an artwork, the brand's contemplative precision manifests
as progressive lens focus through canvas blur filters, where hover duration
directly maps to focal depth, rewarding slow and deliberate exploration."

IMPLEMENTATION:
Tier 2 — Canvas blur filter driven by GSAP animation on hover. Desaturation
also increases with focus. Or Tier 2 — CSS backdrop-filter blur with CSS
custom properties.
```

### Example 5: Architecture Firm

```
BRAND METAPHOR 1 — Physical Sensation:
The brand feels like concrete and light. Heavy but not oppressive.
Raw material shaped with intention. Precision visible in every surface.

BRAND METAPHOR 2 — Materiality:
The brand is steel and concrete under construction. Incomplete potential.
The value is in what's being built, not what's finished.

BRAND METAPHOR 3 — Emotional Trigger:
The brand invokes structural clarity. The understanding that everything
rests on something solid. The visibility of load-bearing elements.

PARADIGM CHOICE: Scroll

BRAND-TO-PARADIGM MAPPING:
Buildings are constructed bottom-up. Scrolling happens top-to-bottom (in
content terms). By reversing the scroll direction and building sections
from bottom-to-top, the interaction mirrors actual construction.

REJECTED ALTERNATIVES:
1. Cursor Paradigm — cursor controls building elements. Rejected because
   it individualizes interaction. Architecture is about systems, not
   individual agency.
2. Loading Paradigm — site builds on load. Rejected because construction
   should be visible throughout the experience, not just initially.

THE TWIST:
Building sections don't scroll in—they're CONSTRUCTED as you scroll.
Floors appear one at a time, bottom-to-top. Structural elements (beams,
columns) draw themselves with SVG stroke animation. The rate of construction
correlates to scroll speed. Fast scroll = fast construction. Each floor
appears to rest on the one below it, creating physical logic.

SIGNATURE STATEMENT:
"When scrolling through the portfolio, the brand's structural integrity
manifests as real-time construction through SVG stroke animation, where
scroll velocity determines building assembly speed and floors are drawn
atop previously-completed structure."

IMPLEMENTATION:
Tier 2 — GSAP ScrollTrigger drives SVG stroke animation on per-floor basis.
Scroll position maps to drawing progress. Or Tier 3 — Custom shader that
builds geometry based on scroll velocity, making every pixel part of the
construction system.
```

---

## When the Gate Blocks You

If you find yourself unable to complete the gate—unable to articulate a twist, stuck between paradigms, rejecting every idea—stop and return to the brief.

The gate isn't broken. You haven't extracted the metaphors deeply enough.

Re-read the client's language. What words repeat? What visuals appear in their reference folder? What's the core tension in their business?

Good gates take 2-3 hours. Great gates take a full day. Bad gates happen when you rush them.

The gate is the most important part of the entire project. Everything else follows from it.

Don't start design until the gate is written and signed off.
