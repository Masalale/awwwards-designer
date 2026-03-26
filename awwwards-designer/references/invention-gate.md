# Invention Gate: Brand Metaphor → Animation Map + Stitch Prompt

The Invention Gate is the creative engine. It takes Phase 1 interview answers and produces two outputs that drive the entire pipeline: an **animation map** (what the site does) and a **Stitch prompt** (what the site looks like). The user reviews and confirms the animation map before the Stitch prompt is generated.

---

## Input: Interview Answers (Phase 1)

1. Brand name
2. Brand identity — what it does, what it stands for
3. Target audience — who it serves, what they expect
4. Tier — 1 (CSS), 2 (GSAP), 2.5 (light 3D), 3 (WebGL)
5. Page count and content per page
6. Interactive/data-driven sections (forms, dashboards, auth, checkout)
7. Reference sites (optional)

---

## The 4-Step Process

### Step 1: Extract Brand Metaphor

Three metaphors are extracted from the brand brief — not invented. They describe what the brand *feels* like, not what it *means*.

**Metaphor 1: Physical Sensation**
Question: "If I could touch the brand, what texture would it be?"

Not: "The brand is sophisticated."
But: "The brand feels like cold steel, precisely machined. Edges you wouldn't accidentally cut yourself on. Not dangerous — just exact."
Or: "The brand feels like warm amber glass — smooth, clear, with depth you can see into. Substance without heaviness."

**Metaphor 2: Materiality**
Question: "What material is this brand made of?"

Not: "The brand is elegant."
But: "The brand is liquid mercury — reflective, responsive to even tiny vibration, impossible to hold perfectly still."
Or: "The brand is frosted glass. You can see something is behind it, but not clearly. The thing behind matters more than the surface."

**Metaphor 3: Emotional Trigger**
Question: "What feeling does the brand invoke in the person encountering it?"

Not: "The brand is premium."
But: "The brand invokes vertigo — the good kind. Standing at a height and feeling the pull down. Disorienting but absolutely clear."
Or: "The brand invokes the moment of unwrapping. The satisfaction of something special arriving accessible and affordable."

**Where metaphors come from:**
- The brand brief (exact phrases the client uses)
- The client's own language when describing their work
- Competitor positioning (what does this brand need to be the inverse of?)
- First gut impression — what is the feeling before the thought

#### Deep Extraction Warning

The most common failure: latching onto one concrete detail from the brief and mistaking it for the metaphor. This produces an animation approach that fits the detail but misses the brand's essential nature.

Example of the failure:
- Brief says: "performances begin in total silence for minutes before anything moves"
- Wrong extraction: "the brand is about stillness before motion" → Loading/Reveal (one-time ritual)
- Right extraction: "the brand is kinetic memory — the body carries what the mind cannot speak" → Cursor (continuous physical expression throughout every interaction)

The detail (silence before motion) describes one performance. The metaphor (body as memory) describes the brand continuously.

**The test:** "Does this metaphor describe what the brand *does once* or what the brand *is continuously*?" If once — keep extracting.

#### Metaphor Quality Gates

Each metaphor must pass three tests before proceeding:

- **Grounding:** Can you touch, see, or feel it? Quote the exact brief phrase it came from.
- **Continuity:** Does it describe the brand continuously — not just at one moment?
- **Distinctiveness:** Would a competitor in the same industry arrive at the same metaphor? If yes — dig deeper.

All three must pass. If any fail, re-extract.

---

### Step 2: Derive Motion Language

From the metaphors — typically the strongest of the three — derive the site's motion language. This determines easing character and animation personality across the entire project.

**Four qualities to define:**

| Quality | Question |
|---------|----------|
| **Speed** | Does this metaphor move fast or slow? |
| **Weight** | Does it feel heavy or light? |
| **Texture** | Smooth gradual transitions or sharp cuts? |
| **Response** | Does it react instantly or with deliberate delay? |

**Map qualities to easing:**

| Brand Quality | Easing Direction |
|---|---|
| Heavy, monumental | Long ease-out, no bounce — `power4.out` |
| Light, airy | Short ease-in-out, slight overshoot — `back.out(1.2)` |
| Precise, mechanical | Linear or stepped — `steps(8)` |
| Organic, fluid | Asymmetric cubic-bezier — `power2.inOut` |
| Energetic, fast | Quick ease-in, snap to position — `power3.in` |
| Contemplative, slow | Long duration (1.2s+), gentle ease-out — `power1.out` |

**Define 3 named project easings:**
- `ease-primary` — interaction easing (buttons, links, hover states)
- `ease-reveal` — content reveal easing (scroll enters, page load reveals)
- `ease-transition` — page transition easing (TanStack Router + GSAP)

---

### Step 3: Define Signature Interaction

One unique interaction derived from the brand metaphor. Must feel native to the brand — not a template pattern.

#### Choose an Interaction Territory (ONE only)

**Territory 1: Cursor**
The pointer becomes expressive — changes shape, trails, responds to proximity, distorts elements.
Best for: brands where navigating IS the experience — studios, agencies, brands where every gesture is expressive.
Note: underused. If the brand's emotional trigger involves precision, agency, performance, or play — seriously evaluate this before dismissing.

**Territory 2: Scroll**
Content movement through time is the signature. How sections reveal, pin, parallax — how text moves through the viewport.
Best for: narrative-driven sites, portfolios, manifesto brands.

**Territory 3: Loading/Reveal**
The first encounter is the signature. How the page introduces itself, what appears first, how content assembles.
Best for: studios, event sites, agencies where anticipation is part of the brand experience.

**Territory 4: Hover**
Engagement moments are the signature. What reveals, focuses, lifts, or develops on hover.
Best for: product sites, gallery experiences, discovery-driven content.

**Territory 5: Typography**
Text itself is the medium. How type moves, breathes, scrambles, changes weight or width based on interaction.
Best for: editorial sites, manifesto brands, publishing — anywhere language carries more weight than imagery.
Note: underused. If the brand's identity lives in language, time, or documentation — seriously evaluate this.

**Territory 6: Layout**
Space itself transforms. Grids reshuffle, columns merge and split, whitespace expands and contracts.
Best for: architecture firms, spatial brands, structural experiences.

#### Rejection Discipline

Before committing, explicitly reject at least 3 of the remaining territories with one-line reasoning tied to the brand's nature. This is not optional. Picking the first territory that fits without documented rejections means the gate was bypassed, not completed.

Rejections must be territory rejections — not aesthetic choices ("no parallax"). Reject the territory itself and explain why the brand's essential nature makes it the wrong container.

**Commitment test:** "If a competitor in the same industry used this same territory choice — would it still make sense?" If yes, you haven't found the right one yet.

#### The Twist

The counterintuitive element that makes the interaction unrepeatable. What makes someone say "wait, why is it doing that?" — not because it's confusing, but because it surprises and then instantly makes sense.

**Formula:**
```
[Territory] + [Metaphor material] + [Unexpected medium] = Signature Interaction
```

**Write the signature statement in this exact format:**
```
"When [specific user trigger], [brand metaphor] manifests as [specific technical implementation]
through [the twist that makes it unrepeatable]."
```

The statement must be specific enough that a developer can build it without a single clarifying question. Vague nouns ("particle effect," "dissolve," "smooth transition" without naming the mechanism) fail the test.

#### Usability Gates — Automatic Disqualifiers

If any apply, the interaction FAILS regardless of how well the metaphor maps. The metaphor may be right; the expression is wrong. Keep the metaphor, change the expression.

- **Any delay >4 seconds before content is accessible** — unskippable waits over 4 seconds are hostile UX. "The brand is about patience" does not override this.
- **Refresh resets meaningful state** — refreshing is not a user error. If refresh breaks the experience, the interaction penalizes standard browser behavior.
- **Content locked behind interaction completion** — interactions enhance content; they do not gatekeep it. Users must be able to access the primary content without completing any animation or ritual.
- **Audio without explicit user action** — browsers block autoplay. Audio must be opt-in with a visible, persistent toggle.
- **Hover as the only path to information** — hover is absent on touch devices. Any information conveyed exclusively through hover is inaccessible to 30%+ of users.
- **Intentional technical degradation** — broken image loading, artificial latency, or simulated failure states framed as "authenticity." This always reads as broken to anyone who doesn't know the concept. Find the expression in layout, sequence, or framing — not in making the browser behave badly.

---

### Step 4: Generate Animation Map

Using the tier, metaphors, motion language, signature interaction, and page structure from the interview — generate the full animation map following the schema in `references/animation-map.md`.

The animation map contains:
- Global settings: tier, easing values, scroll behavior, page transitions, signature interaction
- Per-page animation assignments for every section (type, trigger, description)
- Three.js overlay zones (Tier 2.5+) with mobile fallbacks
- SplitType targets with split type and stagger values
- ScrollTrigger pins

Read `references/technique-families.md` for interaction pattern options per tier.
Read `references/anti-patterns.md` before finalizing any pattern decision.

---

## Step 5: User Review Gate

**Do not generate the Stitch prompt yet.**

Present to the user:
1. The three brand metaphors with quality gate results
2. The motion language (speed, weight, texture, response → named easings)
3. The signature interaction statement
4. The animation map summarized per page

Then ask:

```
Here's what I've extracted from the brand before I write the Stitch prompt.

[Present metaphors, motion language, signature interaction, animation map summary]

Does this capture the brand correctly?
Any changes before I write the Stitch prompt?
```

Wait for explicit confirmation. If the user requests changes — revise the animation map and present again. Do not proceed to the Stitch prompt until the user confirms.

---

## Step 6: Generate Stitch Prompt

Only after user confirms the animation map.

Write the Stitch prompt following the format in `references/stitch-brief.md`. The Aesthetic Direction section is built by injecting the brand metaphors from this Invention Gate output verbatim, followed by the visual vocabulary and negative constraints each metaphor implies at rest.

---

## Output: Two Documents

**Output A: Animation Map**
Schema: `references/animation-map.md`
Contains: global settings, per-page assignments, Three.js zones, SplitType targets, scroll pins.

**Output B: Stitch Prompt**
Format: `references/stitch-brief.md`
Contains: brand identity (actual name + description), aesthetic direction (INVENTION metaphors injected + derived visual vocabulary), typography, color, icons, shared components, page structure, device target.

**Gate:** Both documents must exist and the animation map must be user-confirmed before Phase 3 begins.

---

## What the Invention Gate Does NOT Do

- Choose specific colors — Stitch owns this, or the user provides them
- Choose specific fonts — Stitch owns this
- Generate any code
- Make visual design decisions beyond aesthetic direction for the Stitch prompt
- Prescribe backend implementation

---

## Worked Examples

### Example 1: Fragrance E-Commerce (Tier 2)

**Brief:** Kenya-based store selling premium Middle Eastern fragrances. Kenya-wide delivery via Pickup Mtaani agents. Warm but premium — not flashy luxury, not budget discount. Value seekers who appreciate quality and discovery.

**Metaphor 1 (Physical Sensation):** Warm amber glass — smooth, clear, with depth you can see into. Substance without heaviness. Concentrated, refined, precious.
- Source quote: "Premium fragrances, Kenya-wide delivery"
- Grounding: ✓ — can touch/feel amber glass
- Continuity: ✓ — every interaction should feel warm, clear, substantial
- Distinctiveness: ✓ — not cold luxury, not cheap accessibility — warm value

**Metaphor 2 (Materiality):** Golden liquid in a vessel. Catches light when held right. Patience in the waiting — scent settles, develops, reveals itself.
- Source quote: "Value seekers, nationwide"
- Grounding: ✓
- Continuity: ✓ — every stage from browse to unbox is a reveal
- Distinctiveness: ✓ — the reveal experience is the brand, not just the product

**Metaphor 3 (Emotional Trigger):** The moment of unwrapping. The first spray. The satisfaction of something special arriving affordable and accessible.
- Source quote: "Kenya-wide delivery"
- Grounding: ✓
- Continuity: ✓ — from first browse to final pickup, anticipation built at each step
- Distinctiveness: ✓ — not just "delivery" but the event of receiving something special

**Motion Language:**
- Speed: Slow — amber is viscous, nothing snaps
- Weight: Substantial with presence, not heavy
- Texture: Smooth, gradual reveals — light catching glass at different angles
- Response: Deliberate, with slight delay — like lifting something precious
- `ease-primary`: `cubic-bezier(0.25, 0.46, 0.45, 0.94)` — warm ease-out, no snap
- `ease-reveal`: `power2.out`
- `ease-transition`: `power3.inOut`

**Territory: Hover**

Rejected:
1. Scroll: Value seekers are active browsers — scroll makes product feel passive, consumed rather than discovered
2. Typography: Fragrances are sensory — text as primary medium distracts from the visual product
3. Layout: Brand is about warmth and access, not structural engineering
4. Loading: One-time ritual doesn't serve the browse → buy journey
5. Cursor: Discovery through approach (hover) better serves e-commerce than continuous pointer expression

Commitment test: A competitor fragrance shop could use Hover — but they'd apply it to product images alone. This brand's Hover extends to the entire discovery experience: pricing reveals, agent proximity, delivery timelines. The hover IS the exploration.

**The Twist — Layered Lift:**
Product cards on hover don't zoom or brighten. They lift with depth — a shadow emerges, the card rises, then layers within the card separate progressively (image lifts first, then text, then price). The longer you hover, the more layers open. Leaving reverses the sequence smoothly. The physical sensation of picking up a bottle to examine it.

**Signature Statement:**
"When hovering over a product card, the brand's warm reveal manifests as a layered lift through GSAP-driven depth animation where hover duration progressively separates card layers and shadow depth, making the examination of a fragrance feel physical and intentional."

**Animation Map (global settings):**
```yaml
tier: 2
easing_language: "slow, warm, deliberate"
ease_primary: "cubic-bezier(0.25, 0.46, 0.45, 0.94)"
ease_reveal: "power2.out"
ease_transition: "power3.inOut"
scroll_behavior: lenis
page_transitions: tanstack-router
signature_interaction: "layered product card lift — hover duration drives progressive layer separation via GSAP"
```

---

### Example 2: Architecture Firm (Tier 2)

**Brief:** Berlin-based architecture firm specializing in cultural institutions. Monumental, restrained, structurally precise. Materials: concrete, steel, glass.

**Metaphors:**
1. Physical Sensation: Concrete and light — heavy but not oppressive. Precision visible in every surface.
2. Materiality: Steel under construction — incomplete potential. Value is in what's being built, not what's finished.
3. Emotional Trigger: Structural clarity — the understanding that everything rests on something solid. Visibility of load-bearing elements.

**Motion Language:**
- Speed: Deliberate, measured
- Weight: Heavy — concrete doesn't float
- Texture: Sharp, precise — no soft curves
- Response: Weighted delay — like structural mass resisting motion
- `ease-primary`: `power4.out` — heavy ease-out, monumental
- `ease-reveal`: `power3.out`
- `ease-transition`: `power2.inOut`

**Territory: Scroll**

Rejected:
1. Cursor: Architecture is about systems, not individual gesture — cursor individualizes what should feel structural
2. Loading: Construction should be visible throughout the experience, not only at entry
3. Hover: Too reactive — architecture is about weight and permanence, not responsiveness

**The Twist:**
Building sections don't scroll in — they're constructed as you scroll. Floors appear bottom-to-top. Structural elements (beams, columns) draw themselves with SVG stroke animation. Scroll velocity determines construction speed. Each floor visibly rests on the one below it — physical logic made visible.

**Signature Statement:**
"When scrolling through the portfolio, the brand's structural integrity manifests as real-time floor-by-floor construction through SVG stroke animation where scroll velocity determines assembly speed and each floor draws atop previously-completed structure."

**Animation Map (global settings):**
```yaml
tier: 2
easing_language: "heavy, deliberate, precise"
ease_primary: "power4.out"
ease_reveal: "power3.out"
ease_transition: "power2.inOut"
scroll_behavior: lenis
page_transitions: tanstack-router
signature_interaction: "scroll-velocity-driven SVG construction — floors build bottom-to-top as user scrolls"
```
