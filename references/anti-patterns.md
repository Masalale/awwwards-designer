# Anti-Patterns & Differentiation Framework

The purpose of this classification is not to prohibit creativity but to force differentiation. Any pattern that has become "the default" is an anti-pattern — not because it's bad technique, but because it collapses the design space. The 3 tiers work together: avoid Forbidden, reinvent Overused, reach for Encouraged.

---

## TIER 1 — FORBIDDEN (AI Slop Defaults)

These patterns signal that the AI agent fell back on its statistical average. They appear on 80%+ of AI-generated sites. Using them without radical reinvention disqualifies Awwwards consideration.

### Typography Forbidden
- **Generic Fonts**: Inter, Roboto, Arial, or any system font as a display/headline typeface.
- **Default Google Fonts**: Google Fonts in their default weight/size (unmodified).
- **Flat Hierarchy**: All headings the same size and weight (no typographic hierarchy).

### Color Forbidden
- **Default Tailwind Blue**: Tailwind default blue (`#3B82F6` or similar) as a primary/accent.
- **AI Slop Gradient**: Purple-to-pink gradient on a white background.
- **Pure Extremes**: Pure black (#000000) or pure white (#ffffff) as background colors.
- **Lazy Dark Mode**: "Dark mode" achieved by simply inverting the light palette.

### Layout Forbidden
- **Rigid Symmetry**: Perfectly symmetrical 3-column grid without any breakouts.
- **Standard Hero**: Centered hero with headline + subtitle + two CTAs as the sole above-fold content.
- **Default Cards**: Floating card grids with default box-shadow.
- **Mirror Footer**: Footer identical to the site's header in visual weight.

### Motion Forbidden
- **Global Transitions**: `transition: all` on any element.
- **Default Easing**: `ease-in-out` as the default easing.
- **Simultaneous Load**: All page elements animating in simultaneously on load.
- **Linear Scroll**: Scroll animations that trigger at exactly 0% and complete at 100% scroll position.

### Surface Forbidden
- **Verbatim Tailwind**: Default Tailwind card styling shipped verbatim.
- **Decorative Blur**: Glassmorphism used everywhere (background-blur should be structural, not decorative).
- **Library Shadows**: Box-shadows that look like default browser/library shadows.

---

## TIER 2 — OVERUSED (Use Only If Deeply Reinvented)

These were innovative patterns 2-3 years ago. Today they are recognizable defaults within the "Awwwards-inspired" space. They are NOT forbidden, but using them in their standard form signals derivative design. Each may be redeemed by combining with unexpected constraints.

| Pattern | Standard Form (Overused Signal) | Reinvention Direction |
| :--- | :--- | :--- |
| **`mix-blend-difference` cursor** | White circle that inverts content on hover. Appears on nearly every "creative portfolio" site. | The blend mode should be ONE element of a multi-state cursor that also morphs shape, size, and content based on context. |
| **Standard GSAP `y: 40px` reveal** | Elements fade up 40px with 0.02s stagger on scroll enter. Parameter values feel like a library demo. | Replace Y-translate with clip-path reveals, rotation, blur-to-focus, or custom per-element physics. |
| **Basic magnetic button** | Button follows cursor with 0.3 strength multiplier, resets with elastic.out. Pull and snap feel identical. | The magnetic behavior should have brand-specific physics — a luxury watch brand's button should feel precise and measured, not springy. |
| **SplitType character stagger** | SplitType chars, y: "100%", opacity: 0, stagger: 0.02. Identical character-by-character up-reveal is a visual cliché. | Use rotation, blur, clip-path, or 3D perspective for the reveal. The stagger pattern itself can be non-linear. |
| **Horizontal scroll "projects"** | Cards in a row that scroll horizontally on desktop. Nearly every agency portfolio uses this exact pattern. | If using horizontal scroll, the transition between items must be architectural — not just drag-to-reveal. |
| **Mesh gradient hero** | Multiple radial gradients at fixed positions creating a "soft aurora" effect. Specific color ranges (purple/blue/pink) are recognizable. | If using mesh gradients, they must move or respond to interaction, and the color palette must be derived from brand identity. |
| **Bento grid layout** | Mixed-span grid cells, 2-4 columns, with cards containing an icon + text. Widely adopted from Apple's marketing pages. | If using grid layouts with spans, they must break outside the container, bleed to edges, or include non-rectangular cells. |

---

## TIER 3 — ENCOURAGED (Rare, Bespoke, Cutting-Edge)

These patterns appear on fewer than 5% of sites. Using them signals genuine technical ambition and creative leadership. They are computationally expensive, harder to implement, and impossible to achieve with standard library defaults.

1.  **MSDF 3D Typography**: Multi-channel Signed Distance Field text in Three.js renders letterforms as genuine 3D geometry. Text can be illuminated, shadowed, placed in 3D space, and carry custom shaders. Impossible to mistake for default web text.
2.  **DOM-to-Shader Synchronization (Curtains.js / gpu-curtains)**: HTML elements are cloned into WebGL planes that occupy the same screen position. The WebGL version can carry shaders while the DOM version handles accessibility. Creates distortion/ripple effects on real content.
3.  **Scroll-Velocity Shader Distortion**: The smooth scroll library's velocity value feeds as a GLSL uniform into a vertex shader. At high scroll speed, geometry warps. At rest, it resolves. The entire page feels like it has physical mass.
4.  **Theatre.js Timeline Orchestration**: A professional animation timeline tool with keyframe UI. Used for cinematic, multi-element, time-precise sequences that GSAP timelines cannot express elegantly. Signals film-production-level craft.
5.  **FBO (Frame Buffer Object) Particle Systems**: GPU-based particle simulations where particle positions are stored in textures and updated on the GPU each frame. Enables hundreds of thousands of particles at 60fps. Recognizable as the visual signature of elite creative studios.
6.  **Gaussian Splatting**: 3D scene representation using thousands of Gaussian splats — creates photorealistic 3D environments from photography. Emerging technique (2024-2025) that almost no production sites use yet.
7.  **Variable Font Axis Mapping**: `font-variation-settings` mapped to scroll position, cursor proximity, or time using CSS custom properties and JavaScript. Each letter "breathes" or responds to input. Completely unlike static typography.
8.  **Intentional Generative Variation**: Using noise functions, PRNG seeded by session, or time-based algorithms to ensure the site looks slightly different on each visit. Typography, backgrounds, or element positions have controlled randomness.
9.  **WebAudio API Integration**: Ambient sound design that responds to interactions — subtle sonic feedback that reinforces the visual language. Used sparingly (never autoplay), only when sound is part of the brand identity.
10. **Canvas-Based Custom Text Rendering**: Drawing typography on a Canvas element using custom rasterization. Allows typography to respond to physics, be masked by video, or carry per-pixel shader effects impossible in standard HTML text.

---

## Closing Note

This list will become outdated. Patterns move from Encouraged → Overused → Forbidden as they gain adoption. Consider whether any technique you're using has appeared in more than 10 notable sites in the past year. If yes, reinvent it.
