# Anti-Patterns: Pattern Blacklist

**TIER 1 — FORBIDDEN** — Never use. No exceptions. No workarounds.

**TIER 2 — OVERUSED** — Document the twist before using. If you can't, don't.

**TIER 3 — ENCOURAGED** — Signal technical ambition. Use with restraint and purpose.

---

## TIER 1: FORBIDDEN

### 1. Generic Display Fonts

**What it is:** Using Poppins, Nunito, Lato, Raleway, Inter, or Montserrat as headline fonts.

**Instead:**
- Luxury: Editorial New, Freight Display, Canela, Lyon
- Technical: PP Neue Machina, Söhne Mono
- Impact: Druk, Aktiv Grotesk Extended, Suisse Int'l
- Unique: Custom font licensing from Colophon, Process Type
- If an icon doesn't exist in Lucide, draw a minimal inline SVG matching its stroke conventions

**Test:** Open a premium design award entry. Look at the headline font. If it's Poppins, it lost.

---

### 2. Default Tailwind Blue (#3B82F6)

**What it is:** Using `bg-blue-500` (#3B82F6) as a primary brand color.

**Instead:** Define a custom color system with at least 3-shade variants (light, mid, dark). Ensure it has a distinct warmth or coolness — not pure saturated blue.

**Test:** If your primary color was lifted from Tailwind defaults, redesign.

---

### 3. Defaulting to Dark Palettes Without Brand Justification

**What it is:** Choosing a dark background because it "feels premium" — without explicit brand direction, user-provided color, or a brand metaphor that requires darkness.

**The rule:** If the user has not provided a color palette — stop and ask before proceeding. Do not default to dark. Do not default to light. No color decisions before user direction is received.

If the user has provided colors — use them exactly as given. Do not darken, adjust saturation, or add warmth "for premium feel."

**Test:** Did the user provide a color? If no, and you have chosen colors, stop and ask.

---

### 4. Pure #000000 or #FFFFFF Backgrounds

**What it is:** Using pure black or pure white as the primary background color.

**Instead:**
- Off-black: #0A0A0F, #0F0F14, #1A1A1F
- Off-white: #F5EDD6, #F5F7FA, #FAFAF8

**Test:** Put your background color next to pure #000 or #FFF. If they look identical, fix it.

---

### 5. `transition: all`

**What it is:** Using `transition: all 0.3s ease` on a parent element.

**Instead:** Specify exactly what transitions: `transition: transform 0.3s, opacity 0.3s`. Use separate transitions per element when needed. Use GSAP for multi-property animations.

**Test:** Search the project for `transition: all`. Delete every match.

---

### 6. Mixed Icon Libraries

**What it is:** Using more than one icon library — Font Awesome alongside Heroicons, Lucide mixed with Phosphor — or random inline SVG from the internet.

**The rule:** Lucide exclusively. One library, one visual language, always. If a needed icon doesn't exist in Lucide, draw it as a minimal inline SVG matching Lucide's stroke conventions (`stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`, no fill, `viewBox="0 0 24 24"`).

**Test:** Search for `font-awesome`, `heroicons`, `phosphor`, `feather`, `tabler`. Any match is a violation.

---

### 7. Rigid Perfect Symmetry Everywhere

**What it is:** Every element perfectly centered, perfectly aligned, perfectly spaced — mirror symmetry in layout, typography, and spacing.

**Instead:**
- Offset columns by 20% widths
- Different margins on different sides
- One element intentionally off-axis for visual tension

**Test:** Can you draw a vertical center line and see identical elements on both sides? If yes, break it.

---

### 8. Stock Photography (Unmodified)

**What it is:** Using unmodified, uncontextualized stock photography from Unsplash, Pexels, or Shutterstock.

**Instead:** Commission custom photography, or heavily color-grade, crop, and overlay the stock image until it is unrecognizable as stock.

**Test:** Could someone find this exact image on Pexels? If yes, modify heavily or replace.

---

### 9. `overflow: hidden` on Hero Without Descender Safety

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

```javascript
const element = document.elementFromPoint(mouseX, mouseY);
if (element.tagName === 'A') {
  cursor.style.mixBlendMode = 'lighten';
} else if (element.classList.contains('image')) {
  cursor.style.mixBlendMode = 'multiply';
}
```

---

### 2. GSAP `y: 40px` Stagger Reveal on Text

**Standard usage:** Text chars or words slide up 40px, fade in, staggered by 0.05s.

**How to reinvent it:** Direction and timing carry meaning. Direction maps to narrative momentum; timing maps to letter anatomy or weight.

```javascript
const direction = brand.momentum === 'forward' ? 1 : -1;
gsap.from(split.chars, {
  x: 40 * direction,
  opacity: 0,
  stagger: (index) => {
    const weight = 400 + (fontWeights[index] || 0);
    return index * 0.03 * (weight / 400);
  },
  duration: 0.8
});
```

---

### 3. Standard Magnetic Button

**Standard usage:** Button follows cursor and sticks on hover, returns on leave.

**How to reinvent it:** Physics-based material properties — button material determines damping and elasticity on release.

```javascript
const materials = {
  rubber: { damping: 0.2, elasticity: 1.5 },
  metal:  { damping: 0.8, elasticity: 0.3 }
};
const material = materials[buttonMaterial];

// On hover
gsap.to(button, {
  x: magneticX, y: magneticY,
  duration: 0.3,
  ease: `power${1 + material.damping}`,
  overwrite: 'auto'
});

// On release
gsap.to(button, {
  x: 0, y: 0,
  overwrite: 'auto',
  ease: `elastic.out(1, ${material.elasticity})`
});
```

---

### 4. SplitType with Identical Stagger Timing

**Standard usage:** Every character animates with the same 0.05s stagger — mechanical feel.

**How to reinvent it:** Stagger timing reflects letter anatomy — ascenders animate first, descenders last.

```javascript
const ascenders = ['b', 'd', 'f', 'h', 'k', 'l', 't'];
const descenders = ['g', 'y', 'p', 'q', 'j'];

gsap.from(split.chars, {
  opacity: 0,
  y: 20,
  stagger: (index, target) => {
    const char = target.textContent.toLowerCase();
    let factor = 1;
    if (descenders.includes(char)) factor = 2;   // last
    if (ascenders.includes(char)) factor = 0.5;  // first
    return index * 0.03 * factor;
  },
  duration: 0.8
});
```

---

### 5. Standard Mesh Gradient

**Standard usage:** Animated mesh gradient as background, morphing between color states.

**How to reinvent it:** Generative gradient driven by time, scroll velocity, or session data — never identical between visits.

```glsl
uniform float uTime;
varying vec2 vUv;

vec3 generateGradient(vec2 uv, float time) {
  vec3 color1 = vec3(0.5 + 0.5 * sin(time), 0.3, 0.8);
  vec3 color2 = vec3(0.2, 0.5 + 0.5 * cos(time), 0.6);
  float blend = smoothstep(0.0, 0.5, uv.y);
  return mix(color1, color2, blend);
}

void main() {
  gl_FragColor = vec4(generateGradient(vUv, uTime), 1.0);
}
```

---

### 6. Parallax Background Image

**Standard usage:** Background image moves slower than foreground content.

**How to reinvent it:** Parallax speed carries meaning — maps to content importance or thematic weight.

```javascript
// More important content moves slower
gsap.from('.hero-bg', {
  scrollTrigger: { trigger: '.hero', start: 'top top', end: 'bottom top', scrub: 1 },
  y: -200
});

gsap.from('.secondary-bg', {
  scrollTrigger: { trigger: '.secondary', start: 'top top', end: 'bottom top', scrub: 1 },
  y: -100
});
```

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

### 8. Floating Navigation with Blur Backdrop

**Standard usage:** Fixed nav with `backdrop-filter: blur()` background.

**How to reinvent it:** Nav reflects brand state — color shifts based on content behind it, brand mark animates on scroll.

```css
.nav {
  backdrop-filter: blur(10px);
  background: hsl(var(--nav-hue), 50%, 10%);
  transition: background 0.6s ease;
}
.nav.dark-bg  { --nav-hue: 200; }
.nav.light-bg { --nav-hue: 30;  }
```

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
Browser-native page transitions without JavaScript animation libraries. Use where simplicity is a virtue — content sites, portfolios with clean layouts. For highly choreographed multi-element transitions, Barba.js + GSAP still offers more control.

### 14. Image Sequences with Alpha Compositing
Pre-rendered animation frames composited on 2D canvas — JPEG color data combined with PNG alpha. Keep sequences short (2–5 seconds), loop seamlessly. Scroll-scrubbed sequences are significantly more engaging than auto-looping.

---

## Decision Tree

When designing an interaction:

1. **Is this a forbidden pattern?** → STOP. Redesign.
2. **Is this an overused pattern (Tier 2)?** → Proceed only with a documented twist. Write it in INVENTION.md before building.
3. **Is this an encouraged pattern (Tier 3)?** → Implement if technical confidence and timeline allow.
4. **Is this something new?** → Verify it's not a forbidden or overused pattern underneath.

```
"I want a custom cursor."
├─ "Is it mix-blend-mode: difference?" → Forbidden
├─ "Is it context-aware?" → Overused → needs documented twist
└─ "Is it physics-based or DOM-to-shader?" → Encouraged

Conclusion: Context-aware with documented twist = Tier 2 (allowed)
```

---

## Audit Checklist

Before launch:

- [ ] No generic display fonts (Poppins, Nunito, Lato, Raleway, Inter, Montserrat)
- [ ] No Tailwind default colors (#3B82F6)
- [ ] No pure #000 or #FFF backgrounds
- [ ] No dark palette chosen without user-provided color direction — if user hasn't provided colors, stop and ask
- [ ] No `transition: all` anywhere
- [ ] No mixed icon libraries — Lucide only (search: `font-awesome`, `heroicons`, `phosphor`)
- [ ] No perfectly symmetric layouts throughout
- [ ] No unmodified stock photography
- [ ] No `overflow: hidden` on hero without descender safety
- [ ] If marquee present: all three gate questions answered yes, twist documented
- [ ] Every Tier 2 pattern has documented twist in INVENTION.md
- [ ] At least one Tier 3 pattern if targeting high distinction
- [ ] Visual validation complete (descender check, mobile test, device testing)
