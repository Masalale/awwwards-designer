# Technique Families

This document defines interaction paradigms across three complexity tiers. It replaces verbatim code recipes with conceptual approaches. Use these as a starting point for inventing your own signature interactions.

## 🧬 The Tier System

- **Tier 1 — CSS & Lightweight**: Native browser capabilities, zero or minimal JS, high performance, and accessibility-first.
- **Tier 2 — GSAP & DOM**: Advanced orchestration, physics-based motion, and complex DOM manipulation.
- **Tier 3 — WebGL, Shaders & Generative**: Immersive 3D environments, GPU-accelerated effects, and mathematical visual systems.

---

## 🖱️ Cursor Family
The pointer as a design surface. These approaches transform the cursor from a utility into a narrative tool.

- **Tier 1 — CSS Blend Cursor**: The cursor element uses CSS blending modes to interact with the content beneath it. It creates high-contrast visual interest (like inverting colors) without any JavaScript overhead. Best for minimalist, high-contrast designs.
- **Tier 1 — CSS Scale Cursor**: A simple visual element that changes its scale or shape based on the state of the element it is hovering over. The transition timing and easing communicate the brand's "snappiness" or "softness."
- **Tier 2 — Elastic Trail Cursor**: The visual cursor lags behind the actual system pointer using spring physics. The amount of lag and the "snap" back to position create a sense of physical weight and momentum.
- **Tier 2 — Magnetic Pull Cursor**: Interactive elements exert a gravitational pull on the cursor as it nears them. This makes the interface feel "alive" and responsive to the user's intent before they even click.
- **Tier 2 — Morphing Cursor**: The cursor fluidly transforms into different shapes or icons depending on the context (e.g., becoming a "View" label over an image or a "Drag" icon over a slider).
- **Tier 3 — Displacement Shader Cursor**: The cursor acts as a lens that distorts, refracts, or melts the content beneath it via a WebGL displacement map. It creates a tactile, physical sensation like moving a finger through liquid or glass.
- **Tier 3 — Particle Emission Cursor**: Movement of the pointer spawns GPU-rendered particles that trail behind and dissipate. The particle physics (gravity, turbulence, lifespan) define the energy of the experience.

---

## 📜 Scroll Family
Velocity, position, and direction as creative input for storytelling.

- **Tier 1 — Native Scroll-Driven Animation**: Keyframes tied directly to the scroll progress of a container. This allows for complex transformations and opacity shifts that are perfectly synced with the user's thumb or wheel movement with zero JS.
- **Tier 1 — Sticky Section Panels**: Using sticky positioning to create a "stacking" effect where sections slide over or under each other. This creates a sense of depth and structural layering.
- **Tier 2 — Lenis Velocity Distortion**: Mapping the current scroll speed to visual properties like skew, scale, or blur. The faster the user scrolls, the more the interface "warps," creating a visceral sense of speed.
- **Tier 2 — Scroll-Pinned Timeline**: A section of the page pins in place while a sequence of animations plays out as the user continues to scroll. This forces the user to engage with a specific narrative moment.
- **Tier 2 — Horizontal Scroll Takeover**: A vertical scroll gesture is temporarily hijacked to move content horizontally. This disruption of rhythm is excellent for galleries or timelines that require a change in pace.
- **Tier 3 — Scroll-Velocity Shader**: Scroll velocity is passed as a uniform to a vertex shader, causing the entire page geometry to ripple, bend, or fragment in real-time based on how hard the user "pushes" the scroll.
- **Tier 3 — Camera Z-Depth Scroll**: Moving the camera through a 3D scene along the Z-axis. Instead of elements moving up and down, the user "flies" through the content, creating true spatial depth.

---

## 🎭 Reveal Family
The choreography of how content enters the visual field.

- **Tier 1 — Clip-Path Reveal**: Content is hidden behind a geometric mask that expands or slides to reveal the element. This creates sharp, architectural entries that feel precise and modern.
- **Tier 1 — Opacity + Transform Fade**: A refined entry where elements move into position while fading in. The "premium" feel comes from bespoke easing curves and carefully timed stagger delays between related elements.
- **Tier 2 — SplitType Character Reveal**: Text is broken down into individual characters or words which then animate in sequence. The direction of movement (e.g., rotating from 90 degrees or sliding from a clip-mask) defines the typographic personality.
- **Tier 2 — Masked Image Reveal**: An image is revealed as a secondary "curtain" element slides away. The interaction between the image's movement and the mask's movement creates a sophisticated, layered reveal.
- **Tier 2 — Blur-to-Focus Reveal**: Elements enter the screen in a blurred state and gradually sharpen into focus. This mimics a camera lens and is highly effective for photography-led brand stories.
- **Tier 3 — Liquid Reveal**: Using displacement filters to make content appear as if it is emerging from a pool of liquid or a cloud of smoke. The distortion resolves into clean, sharp content as the animation completes.
- **Tier 3 — Physics-Based Reveal**: Elements enter the screen as if they are physical objects subject to gravity and collisions. They might "fall" into place and bounce, or "float" up and settle with realistic inertia.

---

## 🔡 Typography in Motion Family
Treating letterforms as dynamic, expressive elements rather than static information.

- **Tier 1 — Variable Font Axis Animation**: Animating the internal axes of a variable font (weight, width, slant) based on scroll position or hover. The text feels organic and responsive to the user's presence.
- **Tier 1 — Viewport-Width Headline**: Sizing text so it always fills the horizontal space of the screen. The typography becomes a structural grid element that defines the layout of the entire page.
- **Tier 2 — Kinetic Text Loop**: Text that moves in a continuous, stylized loop. This isn't just a simple marquee; it might follow a complex path, change speed based on scroll, or distort as it moves.
- **Tier 2 — Text Stroke Drawing**: Animating the outline of a font as if it is being drawn in real-time. This adds a "hand-crafted" or "blueprint" feel to the design.
- **Tier 3 — MSDF Text Rendering**: Rendering text within a WebGL context using Multi-channel Signed Distance Fields. This allows text to exist in 3D space, respond to lights, and be deformed by shaders without losing sharpness.
- **Tier 3 — Fluid Text Distortion**: Applying fluid simulation or displacement shaders to text geometry. The letters wave, break part, or ripple like water in response to user interaction.

---

## ⏳ Loading & Transition Family
The "in-between" moments that define the continuity of the experience.

- **Tier 1 — Structural Blueprint Reveal**: Before the content loads, the site's underlying grid and structural lines are drawn on screen. This frames the loading time as a deliberate "construction" phase.
- **Tier 1 — Counter-Based Loader**: A minimalist numerical display that counts up to 100%. The impact comes from the choice of typeface, the speed of the count, and the final transition into the site.
- **Tier 2 — Brand-Morphing Loader**: An abstract shape or logo mark that fluidly morphs through different states while assets are being fetched. The motion itself communicates the brand's core identity.
- **Tier 2 — Page Transition Overlay**: A full-screen element that wipes across the screen between page navigations. The shape of the wipe (e.g., a circular expansion or a diagonal slice) maintains the visual language across the entire site.
- **Tier 3 — Particle Assembly Loader**: The site's hero image or logo assembles itself from thousands of individual particles that fly in from off-screen and snap into place based on a physics simulation.
- **Tier 3 — Shader Intro Sequence**: The site begins with a full-screen generative shader that represents the brand's "vibe." This shader gradually morphs or dissolves to reveal the actual interface, making the entry feel like a transformation.

---

## 🧩 Combining Families
A truly unique signature interaction often lives at the intersection of two families.
- **Cursor + Scroll**: The cursor's behavior or appearance changes based on the current scroll velocity or the specific section the user is in.
- **Typography + Reveal**: Characters don't just appear; they reveal themselves based on the proximity of the cursor, making the user "discover" the text.
- **Loading + Page Content**: The final state of the loading animation becomes the starting state of the hero section, creating a seamless, "no-cut" entry into the experience.

## 🚫 Avoiding Convergence
To ensure divergence, never pick the most "obvious" approach.
1. **Select a Family**: Choose the paradigm that fits the brand narrative.
2. **Pick an Approach**: Select one from the tiers above.
3. **Add a Constraint**: Introduce a unique rule (e.g., "all movement must be diagonal," or "motion only happens on the Y-axis").
4. **Personalize the Metaphor**: If using "Elastic Trail," decide if it feels like "honey," "a rubber band," or "a heavy lead weight." The physics parameters are where the soul lives.
