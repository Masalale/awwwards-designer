# Technique Families

This document defines interaction paradigms across three complexity tiers. It replaces verbatim code recipes with conceptual approaches. Use these as a starting point for inventing your own signature interactions.

## The Tier System

- **Tier 1 — CSS & Lightweight**: Native browser capabilities with no dependencies. Requires creative constraint — every effect must be achieved through CSS magic.
- **Tier 2 — GSAP & DOM**: Advanced orchestration with physics-based motion. Requires careful context management and cleanup.
- **Tier 3 — WebGL, Shaders & Generative**: Immersive 3D environments with GPU-accelerated effects. Requires deep technical expertise and performance optimization.

---

## Cursor Family

The pointer as a design surface. These approaches transform the cursor from a utility into a narrative tool.

- **Tier 1 — CSS Blend Cursor**: The cursor element uses CSS blending modes. High-contrast visual interest without JavaScript. Requires restraint — CSS-only means every pixel counts.
- **Tier 1 — CSS Scale Cursor**: A simple visual element that changes its scale or shape on hover. The transition timing communicates the brand's "snappiness" or "softness."
- **Tier 2 — Elastic Trail Cursor**: The visual cursor lags behind the pointer using spring physics. The lag and snap-back create a sense of physical weight and momentum.
- **Tier 2 — Magnetic Pull Cursor**: Interactive elements exert gravitational pull on the cursor as it nears. The interface feels "alive" and responsive.
- **Tier 2 — Morphing Cursor**: The cursor transforms into different shapes or icons depending on context — "View" over images, "Drag" over sliders.
- **Tier 3 — Displacement Shader Cursor**: The cursor acts as a lens that distorts content beneath it via WebGL displacement. Creates tactile, physical sensation.
- **Tier 3 — Particle Emission Cursor**: Movement spawns GPU-rendered particles that trail and dissipate. Particle physics define the experience's energy.

---

## Scroll Family

Velocity, position, and direction as creative input for storytelling.

- **Tier 1 — Native Scroll-Driven Animation**: Keyframes tied to scroll progress. Complex transformations with zero JS.
- **Tier 1 — Sticky Section Panels**: Sticky positioning creates a "stacking" effect where sections slide over each other. Creates depth and layering.
- **Tier 2 — Lenis Velocity Distortion**: Scroll speed maps to skew, scale, or blur. Faster scrolling = more "warping" = visceral sense of speed.
- **Tier 2 — Scroll-Pinned Timeline**: A section pins while animations play during scroll. Forces engagement with narrative moments.
- **Tier 2 — Horizontal Scroll Takeover**: Vertical scroll hijacked for horizontal movement. Disrupts rhythm for galleries or timelines.
- **Tier 3 — Scroll-Velocity Shader**: Scroll velocity passes to vertex shader. Geometry ripples, bends, or fragments based on scroll force.
- **Tier 3 — Camera Z-Depth Scroll**: Camera moves through 3D space along Z-axis. User "flies" through content for true spatial depth.

---

## Reveal Family

The choreography of how content enters the visual field.

- **Tier 1 — Clip-Path Reveal**: Content hidden behind geometric mask that expands or slides. Sharp, architectural entries.
- **Tier 1 — Opacity + Transform Fade**: Elements move into position while fading in. Premium feel comes from bespoke easing and stagger timing.
- **Tier 2 — SplitType Character Reveal**: Text broken into characters/words that animate in sequence. Movement direction defines typographic personality.
- **Tier 2 — Masked Image Reveal**: Image revealed as secondary "curtain" slides away. Interaction between image and mask creates layered sophistication.
- **Tier 2 — Blur-to-Focus Reveal**: Elements enter blurred then sharpen. Mimics camera lens — effective for photography-led stories.
- **Tier 3 — Liquid Reveal**: Displacement filters make content emerge from liquid or smoke. Distortion resolves into sharp content.
- **Tier 3 — Physics-Based Reveal**: Elements enter as physical objects subject to gravity and collisions. Bounce, float, or settle with inertia.

---

## Typography in Motion

Treating letterforms as dynamic, expressive elements rather than static information.

- **Tier 1 — Variable Font Axis Animation**: Animating internal axes (weight, width, slant) based on scroll or hover. Text feels organic and responsive.
- **Tier 1 — Viewport-Width Headline**: Text fills horizontal space. Typography becomes a structural grid element.
- **Tier 2 — Kinetic Text Loop**: Text moves in continuous, stylized loop. May follow complex paths, change speed based on scroll, or distort.
- **Tier 2 — Text Stroke Drawing**: Outline animates as if being drawn in real-time. Adds "hand-crafted" feel.
- **Tier 3 — MSDF Text Rendering**: Text in WebGL using Multi-channel Signed Distance Fields. Text exists in 3D space, responds to lights, carries shaders.
- **Tier 3 — Fluid Text Distortion**: Fluid simulation or displacement shaders on text geometry. Letters wave, break apart, or ripple like water.

---

## Loading & Transition

The "in-between" moments that define continuity of the experience.

- **Tier 1 — Structural Blueprint Reveal**: Grid and structural lines draw before content loads. Loading = deliberate "construction" phase.
- **Tier 1 — Counter-Based Loader**: Minimalist numerical display counting to 100%. Impact comes from typeface choice and count speed.
- **Tier 2 — Brand-Morphing Loader**: Abstract shape morphs through states while assets fetch. Motion communicates brand identity.
- **Tier 2 — Page Transition Overlay**: Full-screen wipe between navigations. Wipe shape maintains visual language across the site.
- **Tier 3 — Particle Assembly Loader**: Hero image assembles from thousands of particles that fly in and snap into place.
- **Tier 3 — Shader Intro Sequence**: Full-screen generative shader represents brand "vibe." Gradually morphs or dissolves to reveal interface.

---

## Combining Families

A truly unique signature interaction often lives at the intersection of two families.

- **Cursor + Scroll**: Cursor behavior changes based on scroll velocity or current section.
- **Typography + Reveal**: Characters reveal based on cursor proximity — user "discovers" text.
- **Loading + Page Content**: Final loading state becomes hero section's starting state. Seamless "no-cut" entry.

## Avoiding Convergence

To ensure divergence, never pick the most "obvious" approach.

1. **Select a Family**: Choose the paradigm that fits the brand narrative.
2. **Pick an Approach**: Select one from the tiers above.
3. **Add a Constraint**: Introduce a unique rule (e.g., "all movement must be diagonal," or "motion only on Y-axis").
4. **Personalize the Metaphor**: If using "Elastic Trail," decide if it feels like "honey," "rubber band," or "heavy lead weight." The physics parameters are where the soul lives.
