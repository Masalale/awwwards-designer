# INVENTION.md

**Project:** Chomba Creative
**Date:** 2026-03-03
**Complexity Tier:** Tier 2 (GSAP + DOM)

---

## Brand Metaphors

### Metaphor 1: Physical Sensation
The brand feels like carbon fiber woven with light. Smooth at first touch, but beneath the surface there's hidden texture—interwoven threads of capability. Not warm, not cold. Temperature-neutral in a way that feels engineered. There's undeniable mass to it, presence, weight—but it doesn't feel heavy. It feels absolutely capable of anything.

### Metaphor 2: Materiality
The brand is liquid chrome. Reflective, it takes on the color and tone of whatever environment it occupies, but underneath always maintains its silver core. Never truly solid—always flowing, always shifting, but in a controlled, precise way. Like mercury that has been magnetically contained. Every reflection is temporary. The metal underneath is permanent.

### Metaphor 3: Emotional Trigger
The brand invokes the feeling of standing at the edge of something monumental. Not fear—excitement. The view from the very top. You made it here, and what you're seeing is only for people who made it. It's the exclusivity of witnessing something extraordinary. The sense that what you're watching being built was worth every penny to create.

---

## Signature Interaction

### Chosen Paradigm
**Scroll**

### Brand-to-Paradigm Mapping
Chomba builds websites. The scroll IS the construction process. As users scroll, they are literally watching work get built. The paradigm connects directly to what the agency does—building. And the premium feeling comes from the slowness, the care, the deliberate construction of something that couldn't be rushed.

### Rejected Alternatives

**Alternative 1: Cursor**
- Cursor trails, glowing effects, magnetic buttons.
- Why rejected: Futuristic is expected. Every "innovation" agency has custom cursors. It's the instant tell of template-level thinking. Also doesn't connect to the core business—building.

**Alternative 2: Loading/Reveal**
- Complex initial loading sequence, assembly animation on page load.
- Why rejected: "Futuristic" agencies all have flashy loaders. It's overused. Also, the premium feeling comes from ongoing experience, not just the first 3 seconds.

**Alternative 3: Hover**
- Interactive elements that respond to hover with effects.
- Why rejected: Hover is passive. Chomba is about bold action, not passive interaction.

### The Twist
Most scroll sites animate content IN. The content moves from off-screen into the viewport. The twist here is that content doesn't move IN—it gets BUILT. Elements don't fade in or slide up. They emerge from nothing. From negative space. Letters assemble, images sharpen, buttons materialize—not as transitions, but as if the scroll crank is literally manufacturing each element in real-time. The speed of construction responds to scroll velocity. Scroll fast = chaotic rapid building. Scroll slow = deliberate, careful assembly. The user is not consuming content—they are watching a team build something extraordinary, and their scroll is the tool.

### Technical Implementation (Brief)
Tier 2 approach: Framer Motion for scroll-triggered animations. Using scroll velocity to drive animation timing and scale. Elements start at scale(0) or opacity(0) and get "constructed" through a combination of clip-path reveals, SVG stroke animations, and scale-up sequences. Smooth scroll via Lenis for premium feel. Code-split by section for performance.

### Signature Statement
"When scrolling through the experience, the brand's monumental construction manifests as real-time building through velocity-driven assembly animations, where elements don't reveal—they get built, and scroll speed directly controls construction pace, making every pixel feel earned."

---

## Validation

- [x] All three metaphors extracted from brand brief
- [x] Paradigm chosen consciously (not defaulted to)
- [x] At least 2 alternatives considered and rejected
- [x] Signature statement is specific and testable
- [x] Interaction doesn't use Pattern Blacklist without documented twist
- [x] Complexity tier chosen matches brand ambition and timeline

---

## Notes

- Tech: TanStack Start (or Astro) + Framer Motion + Lenis
- No GSAP needed—Framer Motion handles the same animation needs
- Typography: Bold, display-focused, minimalist (futuristic but readable)
- Color: Silver/chrome primary with accent colors that shift based on scroll
- Hero: Big, bold, architectural—sets the tone immediately
- Avoid: mesh gradients, basic stagger reveals, difference cursors

---

**Status: GATE PASSED - Ready for Design & Development**
**Date gate passed:** 2026-03-03
