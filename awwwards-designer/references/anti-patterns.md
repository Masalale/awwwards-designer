# Anti-Patterns: Interaction & Code Pattern Blacklist

**TIER 1 — FORBIDDEN** — Never use. No exceptions. No workarounds.

**TIER 2 — OVERUSED** — Document the twist before using. If you can't, don't.

**TIER 3 — ENCOURAGED** — Signal technical ambition. Use with restraint and purpose.

---

## TIER 1: FORBIDDEN

### 1. `transition: all`

**What it is:** Using `transition: all 0.3s ease` on a parent element.

**Instead:** Specify exactly what transitions: `transition: transform 0.3s, opacity 0.3s`. Use separate transitions per element when needed. Use GSAP for multi-property animations.

**Test:** Search the project for `transition: all`. Delete every match.

---

### 2. Mixed Icon Libraries (Icon Verification Reference)

**What it is:** Using more than one icon library — Font Awesome alongside Heroicons, Lucide mixed with Phosphor — or random inline SVG from the internet.

**The rule:** Lucide exclusively. One library, one visual language, always. If a needed icon doesn't exist in Lucide, draw it as a minimal inline SVG matching Lucide's stroke conventions (`stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`, no fill, `viewBox="0 0 24 24"`).

**Verification search terms:** `font-awesome`, `heroicons`, `phosphor`, `feather`, `tabler`. Any match is a violation.

---

### 3. `overflow: hidden` on Hero Without Descender Safety

**What it is:** Using `overflow: hidden` on a hero container with display text (>48px) without implementing the Descender Safety Protocol.

**Instead:**
- `overflow: visible` on all text elements — never `overflow: clip` (clip ignores `padding-bottom`)
- `overflow: hidden` on section containers (respects child padding)
- `padding-bottom: var(--descender-clearance)` on all display text

**Test:** Screenshot every headline. Any letters (g, y, q, p) cut off at the bottom? Fix before launch.

---

## TIER 2: OVERUSED (Requires Documented Twist)

### 1. `mix-blend-mode: difference` Cursor

**Standard usage:** Custom cursor that inverts colors under the cursor.

**How to reinvent it:** Context-aware cursor that changes blend mode based on element type (text vs. image vs. interactive), transitioning smoothly between states.

Use Context7 to fetch current API docs before implementing.

---

### 2. GSAP `y: 40px` Stagger Reveal on Text

**Standard usage:** Text chars or words slide up 40px, fade in, staggered by 0.05s.

**How to reinvent it:** Direction and timing carry meaning. Direction maps to narrative momentum; timing maps to letter anatomy or weight.

Use Context7 to fetch current API docs before implementing.

---

### 3. Standard Magnetic Button

**Standard usage:** Button follows cursor and sticks on hover, returns on leave.

**How to reinvent it:** Physics-based material properties — button material determines damping and elasticity on release.

Use Context7 to fetch current API docs before implementing.

---

### 4. SplitType with Identical Stagger Timing

**Standard usage:** Every character animates with the same 0.05s stagger — mechanical feel.

**How to reinvent it:** Stagger timing reflects letter anatomy — ascenders animate first, descenders last.

Use Context7 to fetch current API docs before implementing.

---

### 5. Standard Mesh Gradient (Shader Behavior Pattern)

**Standard usage:** Animated mesh gradient as background, morphing between color states.

**How to reinvent it:** Generative gradient driven by time, scroll velocity, or session data — never identical between visits. Static animated gradient loops are forbidden. Data-driven gradients are acceptable.

Use Context7 to fetch current API docs before implementing.

---

### 6. Parallax Background Image

**Standard usage:** Background image moves slower than foreground content.

**How to reinvent it:** Parallax speed carries meaning — maps to content importance or thematic weight. More important content moves slower.

Use Context7 to fetch current API docs before implementing.

---

### 7. Marquee / Infinite Ticker

**Standard usage:** Horizontally scrolling strip of repeating text or logos — infinitely looping.

**Gate questions — all three must be yes before using:**
1. Is the content genuinely worth repeating in motion? Real client names, real project titles, real testimonials — not generic copy or made-up brand descriptions.
2. Does perpetual motion fit the brand's emotional trigger from the Invention Gate? Check Metaphor 3.
3. Does the marquee content differ from what the page already communicates elsewhere?

**If any answer is no:** Do not use the marquee.

**How to reinvent it (if all three yes):** Speed responds to scroll velocity, direction reverses on hover, variable font weight increases as items pass the center point, content changes by time of day.

---

## TIER 3: ENCOURAGED

These patterns signal genuine technical depth. Use with purpose — if you can't articulate why this brand needs this technique, it doesn't.

### 1. MSDF 3D Text Rendering
Text rendered as 3D geometry in WebGL — exists in three-dimensional space with depth, lighting, and camera perspective. Use for hero moments or key brand statements only. Never body copy or navigation.

### 2. DOM-to-Shader Sync
CSS custom properties, scroll position, or cursor coordinates piped into GLSL shader uniforms in real-time. The sync should feel inevitable — if removing it wouldn't change the user's experience, the connection is pointless. One or two well-chosen connections create coherence; five create noise.

### 3. Scroll-Velocity Shaders
Scroll *speed* (not position) drives a GLSL uniform. Fast scrolling creates one visual state; slow scrolling creates another; stopping creates a third. The velocity response should feel physical — like dragging through water. Reduce or disable on touch devices rather than producing a broken version.

### 4. Cinematic Timeline Sequencing
Multi-track, precisely timed animation orchestration — Theatre.js or complex GSAP timeline nesting. Every element in the sequence must have a reason to move when it does. Study film title sequences for rhythm; the best web animations borrow from motion design, not from other websites.

### 5. FBO (Framebuffer Object) Particles
Particle simulations running entirely on the GPU via framebuffer objects. More particles is not better — beauty is in behavior: flocking, attractor response, formation and dissolution. Ensure the system serves the narrative.

### 6. Gaussian Splatting on the Web
3D Gaussian splatting displayed in a WebGL context. Use for moments that benefit from spatial exploration: product showcases, architectural walkthroughs. Treat loading as part of the design. Provide a mobile fallback — splat rendering is GPU-intensive.

### 7. Variable Font Axes as Living Typography
Font axes (`wght`, `wdth`, `slnt`, or custom) driven in real-time by scroll velocity, cursor position, or data feeds. Smooth input values aggressively. Limit to one or two axes per interaction — animating all axes simultaneously looks chaotic. Push beyond simple weight animation: use custom axes, per-character SplitType control, or unexpected data sources.

### 8. Generative Variation
Procedural algorithms ensure no two visits produce identical output. The variation must be *bounded* — every generated output should look intentional, not random. Seed-based generation (URL or timestamp determines output) lets users share specific variations.

### 9. Generative WebAudio
Sound generated or modulated in real-time based on interaction or visual state — not a pre-recorded track. Always opt-in with a visible persistent mute toggle. Ambient and textural is almost always better than melodic. Test on both speakers and headphones.

### 10. Canvas Text Decomposition
Text rendered to a hidden canvas, pixel data extracted and used to drive particle systems or per-pixel animations. The text must remain legible at its rest state. The decomposition effect must feel purposeful — test performance on lower-end devices.

### 11. Physics-Driven UI
2D or 3D physics engines (Matter.js, Rapier.js, Cannon.js) powering interface interactions. Use for specific moments — a 404 page, an interactive grid, a loading sequence — not applied to everything. Tune parameters (gravity, restitution, friction) to feel right, not realistic.

### 12. WebGPU Compute Shaders
WebGPU compute shaders for fluid simulations, complex particles, or real-time image processing. Always provide a WebGL fallback — WebGPU support is limited to Chrome and Edge. Frame the fallback as a first-class experience.

### 13. View Transitions API (Native Browser)
Browser-native page transitions without JavaScript animation libraries. Use where simplicity is a virtue — content sites, portfolios with clean layouts. For highly choreographed multi-element transitions, TanStack Router hooks + GSAP still offer more control.

### 14. Image Sequences with Alpha Compositing
Pre-rendered animation frames composited on 2D canvas — JPEG color data combined with PNG alpha. Keep sequences short (2-5 seconds), loop seamlessly. Scroll-scrubbed sequences are significantly more engaging than auto-looping.

---

## Decision Tree

When designing an interaction:

1. **Is this a forbidden pattern?** → STOP. Redesign.
2. **Is this an overused pattern (Tier 2)?** → Proceed only with a documented twist. Write it in the animation map before building.
3. **Is this an encouraged pattern (Tier 3)?** → Implement if technical confidence and timeline allow.
4. **Is this something new?** → Verify it's not a forbidden or overused pattern underneath.

---

## Audit Checklist

Before launch:

- [ ] No `transition: all` anywhere in the codebase
- [ ] No mixed icon libraries — Lucide only (search: `font-awesome`, `heroicons`, `phosphor`, `feather`, `tabler`)
- [ ] No `overflow: hidden` on hero without descender safety protocol
- [ ] If marquee present: all three gate questions answered yes, twist documented
- [ ] Every Tier 2 pattern has documented twist in the animation map
- [ ] At least one Tier 3 pattern if targeting high distinction
