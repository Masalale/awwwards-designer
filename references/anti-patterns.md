# Anti-Patterns: The Convergence Classification

> **Invariant principle:** Visual convergence — all premium web design looking like everyone else's — is the enemy. The patterns classified here define what convergence looks like. This classification is permanently useful because AI training data accumulates "proven" patterns faster than it accumulates genuine innovation.
>
> **Current-era note:** The specific patterns listed as Tier 1 Forbidden and Tier 2 Overused reflect what is overused today. As years pass, new patterns will become overused and new ones will signal ambition. If you can identify patterns that have become saturated beyond what's listed here, treat them as Tier 1 or Tier 2 accordingly. The principle — document your twist or don't use it — is permanent.
>
> **This is also the canonical Pattern Blacklist** referenced by `references/invention-gate.md`. Run the self-check from this file before finalizing any signature interaction.

The goal of awwwards-v8 is to prevent visual convergence—the phenomenon where all premium web design looks like everyone else's work. These anti-patterns define what convergence looks like.

They are organized in three tiers:

**TIER 1 — FORBIDDEN** — Never use these. No exceptions. No workarounds. If you use them, the site signals template work.

**TIER 2 — OVERUSED** — You can use these, but only if you have documented the twist that makes your usage unique. If you use them without innovation, the site looks derivative.

**TIER 3 — ENCOURAGED** — These patterns signal technical ambition and creative depth. They are rare enough to suggest genuine innovation.

---

## TIER 1: FORBIDDEN

These patterns must never appear in your work without explicit client directive to reproduce competitor work. They are instant tells of non-professional execution.

### 1. Generic Display Fonts

**What it is:**
Using Poppins, Nunito, Lato, Raleway, Inter, or Montserrat as headline fonts in premium web design.

**Why forbidden:**
These are the default sans-serifs in Figma. Every design student, every template, every Webflow site uses them. Using them signals: "I didn't think about typography. I used what Figma gave me."

**Evidence:**
- Poppins: 500k+ downloads on Google Fonts, used on 12+ million websites
- Nunito: The default fallback in Figma prototypes
- Lato: Screams "standard web design from 2015"

**Instead:**
- Luxury: Editorial New, Freight Display, Canela, Lyon
- Technical: PP Neue Machina, Söhne Mono
- Impact: Druk, Aktiv Grotesk Extended, Suisse Int'l
- Unique: Custom font licensing from Colophon, Process Type

**Test:** Open a premium design award entry. Look at the headline font. If it's Poppins, it lost.

---

### 2. Default Tailwind Blue (#3B82F6)

**What it is:**
Using `bg-blue-500` (#3B82F6) or `text-blue-600` from Tailwind's default palette as a primary brand color.

**Why forbidden:**
It is instantly recognizable as "I used Tailwind's defaults without customizing." Premium brands have authored colors.

**Evidence:**
- #3B82F6 is the default in Tailwind CSS v3
- Judges have seen it in 10,000 portfolio sites
- It's the color of "placeholder" design

**Instead:**
- Define a custom color system
- Use at least 3-shade variants (light, mid, dark)
- Ensure it has warmth or coolness (not pure saturated blue)
- Test it against competitors in the same category

**Test:** If you lifted your primary color from Tailwind defaults, redesign.

---

### 3. Defaulting to Dark Palettes Without Brand Justification

**What it is:**
Choosing a dark background as the primary palette because it "feels premium" — without explicit brand direction, user-provided color, or a documented brand metaphor that demands darkness.

**Why forbidden:**
Dark is not premium. Dark is the training data's default for "sophisticated website." It's the same gravitational pull as parallax backgrounds and stagger reveals — the safe choice that feels like a choice but isn't. When every generated site is dark, dark stops signaling anything. Judges have seen thousands of dark sites. Color restraint signals design confidence. Default dark signals prompt completion.

**The rule:**
If the user has not provided a color palette — stop. Ask before proceeding. Do not derive colors. Do not default to dark. Do not default to light. The palette is the user's decision, not the agent's. This is a HARD STOP: no color decisions before user direction is received.

**If the user has provided colors:**
Use them as given. Do not darken them "for premium feel." Do not adjust saturation. Do not add warmth or coolness. The user's colors are the palette.

**Test:** Did the user provide a color? If no, and you have chosen colors, stop and ask.

---

### 4. Pure #000000 or #FFFFFF Backgrounds

**What it is:**
Using pure black (#000000) or pure white (#FFFFFF) as the primary background color without modification.

**Why forbidden:**
Pure black and white are flat, lifeless, devoid of warmth or depth. Premium design has colored blacks and whites.

**Evidence:**
- Pure white feels like default paper, not intentional design
- Pure black feels harsh, not premium
- Luxury brands use off-black (#0A0A0F, #1A1A1F) or off-white (#F5F5F5, #FEFEFE)

**Instead:**
- Off-black: #0A0A0F, #0F0F14, #1A1A1F (warmth from blue or brown undertone)
- Off-white: #F5EDD6, #F5F7FA, #FAFAF8 (warmth from cream or cool undertone)
- Add texture or subtle gradient
- Test legibility at actual viewing distance

**Test:** Put your background color next to pure #000 or #FFF. If they look identical, fix it.

---

### 4. `transition: all`

**What it is:**
Using `transition: all 0.3s ease` or similar catch-all transition on a parent element.

**Why forbidden:**
- Transitions properties you don't intend to transition (box-shadow, padding, margin, etc.)
- Kills performance by animating unexpected properties
- Creates janky animations when child elements have their own transitions
- Shows unfocused thinking

**Evidence:**
- CSS performance benchmarks show 3x jank with `transition: all`
- Forces browser to calculate all animatable properties every frame
- Creates animation conflicts in complex layouts

**Instead:**
- Specify exactly which properties should transition: `transition: transform 0.3s, opacity 0.3s`
- Use separate transitions for different elements: buttons transition color, containers transform
- Use GSAP for complex multi-property animations (handles timing conflicts)

**Test:** Open DevTools. Look for `transition: all` anywhere. Delete it.

---

### 5. Mixed Icon Libraries

**What it is:**
Using more than one icon library in a project — Font Awesome alongside Heroicons, or Lucide mixed with Phosphor — or using Font Awesome / random SVGs instead of a coherent system.

**Why forbidden:**
- Different libraries have different stroke weights, corner radii, and optical sizing — mixing them creates visual noise that the conscious eye can't name but the subconscious eye rejects
- Font Awesome is the Poppins of icon libraries: ubiquitous, functional, completely anonymous
- Copy-pasted SVG icons from random sources have no system — each icon is from a different designer with different visual assumptions

**The rule:**
This skill uses **Lucide exclusively**. One library, one visual language, always. If a needed icon doesn't exist in Lucide, draw a matching inline SVG using Lucide's stroke conventions (`stroke-width="1.5"`, `stroke-linecap="round"`, `stroke-linejoin="round"`, no fill, `viewBox="0 0 24 24"`).

**Test:** Search the project for `font-awesome`, `heroicons`, `phosphor`, `feather`, `tabler`. Any match is a violation.

---

### 6. Rigid Perfect Symmetry Everywhere


**What it is:**
Every element perfectly centered, perfectly aligned, perfectly spaced. Mirror symmetry in layout, typography, and spacing.

**Why forbidden:**
- Symmetry is static, boring, gives no reason to explore
- No visual tension = no reason to look
- Says "automated layout" not "designed by a human"

**Evidence:**
- Nature avoids perfect symmetry (Fibonacci, golden ratio, broken grid)
- Prize-winning design has intentional asymmetry
- Perfect centering was popular in 2010, now signals outdated thinking

**Instead:**
- Broken grid: offset columns by 20% widths
- Asymmetric spacing: different margins on different sides
- Intentional visual tension: one element "wrong" for a reason
- Whitespace not equal on all sides

**Test:** Can you draw a vertical center line and see identical elements on both sides? If yes, break it.

---

### 7. Stock Photography (Art-Directed)

**What it is:**
Using unmodified, uncontextualized stock photography from Unsplash, Pexels, or Shutterstock without art direction.

**Why forbidden:**
- It's anonymous—anyone could have chosen it
- It says "I needed an image, not I chose this specific image for this specific reason"
- Judges can identify stock photography instantly

**Evidence:**
- "Woman at computer smiling at camera" shots are in 100,000 websites
- Stock photography has a visual language that screams "not original"
- Premium brands shoot custom photography

**Instead:**
- Commission custom photography (even if expensive, one hero shot + 3-4 supporting)
- Crop stock photography heavily, add text overlay, blend with graphics
- Use illustration instead of photography
- If you must use stock: heavily color-grade it, blur backgrounds, adjust composition

**Test:** Could someone find this exact image on Pexels? If yes, either modify it heavily or replace it.

---

### 8. `overflow: hidden` on Hero Without Descender Safety

**What it is:**
Using `overflow: hidden` on a hero container with display text (>48px) without implementing the Descender Safety Protocol.

**Why forbidden:**
- Descenders of g, y, q, p get clipped
- It's the most obvious tell of non-professional work
- Judges have trained their eye to spot it

**Evidence:**
- Every non-professional site with large text has clipped descenders
- It shows lack of QA and visual validation

**Instead:**
- Use `overflow: visible` on text elements (NOT `clip` — clip ignores padding and cuts descenders)
- Use `overflow: hidden` on section containers (respects child padding unlike `clip`)
- Apply `padding-bottom: var(--descender-clearance)` to all display text
- Test visually at actual viewport before launch

**Test:** Screenshot every headline. Look at the bottom edge. Any letters cut off? Fix it before launch.

---

## TIER 2: OVERUSED (Requires Documented Twist)

You may use these patterns, but only with explicit innovation. If you use them as-is, the site is derivative.

### 1. `mix-blend-mode: difference` Cursor

**Standard usage:**
Custom cursor that uses `mix-blend-mode: difference` to invert colors under the cursor.

**Why overused:**
Every interactive agency has used this. It's been on Awwwards since 2018. Judges have seen it hundreds of times.

**How to reinvent it:**
- Context-aware cursor that changes based on element type:
  - On text: inverts colors
  - On interactive: becomes a hand
  - On image: becomes an eye
  - Transitions smoothly between states
- Documentation: "Cursor communicates content type through metaphor"

**Example twist:**
```javascript
// Instead of static difference mode, change based on element
const element = document.elementFromPoint(mouseX, mouseY);
if (element.tagName === 'A') {
  cursor.style.mixBlendMode = 'lighten';
} else if (element.classList.contains('image')) {
  cursor.style.mixBlendMode = 'multiply';
}
```

---

### 2. GSAP `y: 40px` Stagger Reveal on Text

**Standard usage:**
Text characters or words fade in and slide up by 40px, staggered by 0.05s.

```javascript
// FORBIDDEN STANDARD
gsap.from(split.chars, {
  y: 40,
  opacity: 0,
  stagger: 0.05,
  duration: 0.6
});
```

**Why overused:**
It's the first GSAP animation in every tutorial. Every junior developer defaults to this.

**How to reinvent it:**
- Directional reveals where direction carries meaning:
  - Slide left-to-right if moving forward in narrative
  - Slide right-to-left if moving backward
  - Rotate as sliding based on emotional tone
- Variable timing based on character weight (heavy characters slower)
- Stagger based on character category (consonants vs vowels)
- Documentation: "Character reveals mirror narrative direction"

**Example twist:**
```javascript
// Direction corresponds to brand momentum
const direction = brands.momentum === 'forward' ? 1 : -1;
gsap.from(split.chars, {
  x: 40 * direction,
  opacity: 0,
  stagger: (index) => {
    // Heavier characters animate slower
    const weight = 400 + (fontWeights[index] || 0);
    return index * 0.03 * (weight / 400);
  },
  duration: 0.8
});
```

---

### 3. Standard Magnetic Button

**Standard usage:**
Button that follows the cursor and "sticks" when you hover, then returns when you move away.

**Why overused:**
It's a Codepen favorite. Every interaction design course teaches it.

**How to reinvent it:**
- Physics-based button: instead of magnetic pull, apply momentum and drag simulation
- Button doesn't just move—it lags, overshoots, bounces back with elasticity
- Different materials feel different: rubber button bounces more, metal button damped
- Documentation: "Button motion maps to material properties"

**Example twist:**
```javascript
// Material property determines damping and elasticity
const materials = {
  rubber: { damping: 0.2, elasticity: 1.5 },
  metal: { damping: 0.8, elasticity: 0.3 }
};

const material = materials[buttonMaterial];

gsap.to(button, {
  x: magneticX,
  y: magneticY,
  duration: 0.3,
  ease: `power${1 + material.damping}`,
  overwrite: 'auto'
});

// Apply overshoot on release
gsap.to(button, {
  x: 0,
  y: 0,
  overwrite: 'auto',
  ease: `elastic.out(1, ${material.elasticity})`
});
```

---

### 4. SplitType with Identical Stagger Timing

**Standard usage:**
Every character animates with the same 0.05s stagger, creating mechanical feel.

**Why overused:**
Default SplitType behavior.

**How to reinvent it:**
- Variable stagger based on character properties:
  - Ascending letters (b, d, f, h) animate first
  - Descenders (g, y, p, q) animate last (thematic: they fall)
  - Vowels vs consonants have different timing
- Randomized within bounds (feels organic, not mechanical)
- Documentation: "Stagger timing reflects letter anatomy"

**Example twist:**
```javascript
const ascenders = ['b', 'd', 'f', 'h', 'k', 'l', 't'];
const descenders = ['g', 'y', 'p', 'q', 'j'];
const vowels = ['a', 'e', 'i', 'o', 'u'];

gsap.from(split.chars, {
  opacity: 0,
  y: 20,
  stagger: (index, target) => {
    const char = target.textContent.toLowerCase();
    let staggerFactor = 1;

    if (descenders.includes(char)) staggerFactor = 2;    // Last
    if (ascenders.includes(char)) staggerFactor = 0.5;   // First
    if (vowels.includes(char)) staggerFactor = 1.2;      // Middle-to-late

    return index * 0.03 * staggerFactor;
  },
  duration: 0.8
});
```

---

### 5. Standard Mesh Gradient

**Standard usage:**
Animated mesh gradient (Figma export) as background, morphing between color states.

**Why overused:**
2024 cliché. Every SaaS site has a mesh gradient hero.

**How to reinvent it:**
- Generative gradient that responds to time or interaction:
  - Gradient changes based on time of day (sunrise → noon → sunset)
  - Gradient responds to user scroll velocity
  - Gradient includes procedural noise (never identical between page loads)
- Documentation: "Gradient is generative, not static"

**Example twist:**
```glsl
// Fragment shader: generative gradient based on time
uniform float uTime;
varying vec2 vUv;

vec3 generateGradient(vec2 uv, float time) {
  vec3 color1 = vec3(0.5 + 0.5 * sin(time), 0.3, 0.8);
  vec3 color2 = vec3(0.2, 0.5 + 0.5 * cos(time), 0.6);
  vec3 color3 = vec3(0.7, 0.2 + 0.5 * sin(time * 0.5), 0.4);

  float blend1 = smoothstep(0.0, 0.5, uv.y);
  float blend2 = smoothstep(0.3, 0.8, uv.x);

  vec3 result = mix(color1, color2, blend1);
  result = mix(result, color3, blend2);

  return result;
}

void main() {
  vec3 color = generateGradient(vUv, uTime);
  gl_FragColor = vec4(color, 1.0);
}
```

---

### 6. Parallax Background Image

**Standard usage:**
Background image moves at a different rate than foreground content (slower, creating depth).

**Why overused:**
Every portfolio site uses parallax. It's dated (2015 peak popularity).

**How to reinvent it:**
- Parallax carries narrative meaning:
  - Parallax speed = thematic weight (heavy topics move slower)
  - Parallax direction changes based on scroll direction
  - Parallax distance correlates to image importance
- Documentation: "Parallax speed maps to content hierarchy"

**Example twist:**
```javascript
// Parallax speed correlates to content importance
gsap.from('.hero-bg', {
  scrollTrigger: {
    trigger: '.hero',
    start: 'top top',
    end: 'bottom top',
    scrub: 1
  },
  y: -200,  // Moves slower (more important)
  duration: 1
});

gsap.from('.secondary-bg', {
  scrollTrigger: {
    trigger: '.secondary',
    start: 'top top',
    end: 'bottom top',
    scrub: 1
  },
  y: -100,  // Moves faster (less important)
  duration: 1
});
```

---

### 7. Marquee / Infinite Ticker

**Standard usage:**
A horizontally scrolling strip of repeating text or logos — infinitely looping, always in motion, often at a 45° angle or as a section divider.

**Why overused:**
It is now in every agency site, portfolio, and Awwwards nominee. It became a signal of sophistication in 2022-2023. It is now a signal of following a template. Judges have seen it so many times it has become invisible — which is the opposite of what a signature moment should do. Adding a marquee because "it looks good" is using decoration as a substitute for invention.

**Gate questions — answer ALL THREE yes before using it:**

1. **Is the content genuinely worth repeating in motion?** Real client names, real project titles, real testimonials — not lorem ipsum, not generic service descriptions, not made-up brand copy. If the content doesn't earn the repetition, the marquee has nothing to say.

2. **Does perpetual motion fit the brand's emotional trigger from the Invention Gate?** A documentary photography collective about witnessing suffering has no business with a perpetual motion element. A studio that moves fast and ships constantly might. The brand's Metaphor 3 (emotional trigger) must be compatible with endless repetition.

3. **Is the marquee content different from what the page already communicates?** If the marquee repeats information already visible in the hero or navigation, it adds visual noise without adding information. The marquee should say something the rest of the page doesn't.

**If any answer is no:** Do not use the marquee. Find a different way to create visual rhythm or brand energy.

**How to reinvent it (if all three answers are yes):**
- Speed that responds to scroll velocity (fast scrolling = fast marquee)
- Marquee that reverses direction on hover, pause on focus
- Variable font weight that increases as items pass the center point
- Content that changes based on time of day or session count
- Documentation: "Marquee [specific twist that makes it unrepeatable]"

---

### 8. Floating Navigation with Blur Backdrop

**Standard usage:**
Fixed navigation bar that floats above content with `backdrop-filter: blur()` background.

**Why overused:**
It's the Tailwind template default. Every new site uses it.

**How to reinvent it:**
- Navigation reveals brand character:
  - Color shifts as you scroll (warm → cool → warm)
  - Brand icon/mark animates on scroll
  - Navigation text changes opacity based on content contrast
- Documentation: "Navigation is brand mirror, not decoration"

**Example twist:**
```css
.nav {
  backdrop-filter: blur(10px);
  --nav-hue: 0;
  background: hsl(var(--nav-hue), 50%, 10%);
  transition: --nav-hue 0.6s ease;
}

.nav.dark-bg {
  --nav-hue: 200;  /* Shift to cool blue */
}

.nav.light-bg {
  --nav-hue: 30;   /* Shift to warm orange */
}
```

---

## TIER 3: ENCOURAGED

These patterns signal genuine technical depth and creative ambition. They are rare enough on the web that their presence alone tells judges: this team knows what they're doing. Using them well — with restraint, purpose, and polish — is what separates SOTD contenders from the crowd.

The descriptions below are philosophy-first. They explain *what* the pattern is and *why* it matters, not how to code it. Implementation details belong in technique-families.md or in the agent's own research for the specific project.

### 1. MSDF 3D Text Rendering

**What it is:** Multi-channel signed distance field text rendered as 3D geometry in WebGL. Text that exists in three-dimensional space, with depth, lighting, and camera perspective — not a flat DOM element with a CSS transform.

**Why it matters:** DOM text, even with the most aggressive GSAP animations, still lives on a flat plane. MSDF text lives *inside* the scene. It can catch light, cast shadows, rotate in 3D space, and interact with particles or geometry around it. When a headline feels like a physical object in a room rather than words on a screen, judges notice the craftsmanship.

**Taste principles:** Use MSDF text for hero moments or key brand statements — never for body copy or navigation. The text should feel monumental. If you can't articulate why this headline needs to exist in 3D space, it doesn't. Ensure the font choice works at the resolution of your atlas; thin weights and small serifs can break down in MSDF rendering.

---

### 2. DOM-to-Shader Sync

**What it is:** CSS custom properties, scroll position, cursor coordinates, or other DOM-layer values are piped into GLSL shader uniforms in real-time. The DOM controls the GPU.

**Why it matters:** Most WebGL effects exist in isolation — a background canvas doing its thing, disconnected from the page's interactivity. DOM-to-shader sync erases that boundary. A scroll progress variable in CSS drives a distortion intensity in a fragment shader. A hover state in the DOM triggers a ripple in a vertex shader. The result feels like one unified system rather than a website with a fancy background.

**Taste principles:** The sync should feel inevitable, not decorative. If removing the shader connection wouldn't change the user's experience, the connection is pointless. The best implementations make you forget there are two rendering systems working together. Avoid syncing too many values — one or two well-chosen connections (scroll progress, cursor proximity) create coherence; five create noise.

---

### 3. Scroll-Velocity Shaders

**What it is:** Scroll *speed* (not position) drives a GLSL uniform that affects visual output in real-time. Fast scrolling creates one visual state; slow scrolling creates another; stopping creates a third.

**Why it matters:** Position-based scroll effects are common — every parallax layer does this. Velocity-based effects are rare because they require smoothing, dampening, and careful calibration. The payoff: the site *responds to how you move*, not just where you are. It rewards curiosity. Judges who scroll fast and then slow down will notice the difference.

**Taste principles:** The velocity response should feel physical — like dragging your hand through water. Avoid harsh thresholds; the transition between states should be continuous and eased. On mobile, velocity behavior is fundamentally different (momentum scrolling vs. direct manipulation), so consider reducing or disabling the effect on touch devices rather than producing a broken version.

---

### 4. Cinematic Timeline Sequencing

**What it is:** Multi-track, precisely timed animation orchestration — the animation equivalent of film editing. Libraries like Theatre.js or complex GSAP timeline nesting where dozens of properties across many elements are choreographed to musical precision.

**Why it matters:** Most web animation is "thing fades in, then next thing fades in." Cinematic sequencing is: "camera pulls back while text splits and tracks left, background shifts hue, particles accelerate, and a secondary element slides into frame — all hitting their marks within a 1.2-second window." The difference is the difference between a slideshow and a Pixar film.

**Taste principles:** Timing is everything. A 50ms offset between two elements entering can be the difference between "choreographed" and "laggy." Study film title sequences for rhythm — the best web animations borrow from motion design, not from other websites. Every element in the sequence should have a reason to move when it does. If you can't explain the timing, simplify.

---

### 5. FBO (Framebuffer Object) Particles

**What it is:** Particle simulations running entirely on the GPU via framebuffer objects. Instead of calculating thousands of particle positions on the CPU and uploading them each frame, the positions are stored in textures and updated via shader passes.

**Why it matters:** CPU-based particles top out at a few hundred before frame drops. FBO particles can simulate tens of thousands — or hundreds of thousands — at 60fps. This enables particle fields, flocking behaviors, fluid simulations, and data visualizations that simply aren't possible with DOM or Canvas 2D approaches.

**Taste principles:** More particles is not better. The beauty of FBO particles is in their *behavior* — flocking, responding to attractors, forming and dissolving shapes. A thousand particles moving with purpose is more impressive than a million particles drifting randomly. Ensure the particle system serves the narrative; particles as background noise are a waste of GPU power.

---

### 6. Gaussian Splatting on the Web

**What it is:** 3D Gaussian splatting — a neural rendering technique that reconstructs 3D scenes from photographs — displayed in a WebGL context. Real-world environments and objects rendered as navigable 3D scenes in the browser.

**Why it matters:** This is one of the most cutting-edge intersections of machine learning and web technology. When a user can orbit around a photorealistic 3D capture of an object or space directly in the browser, it creates a moment of genuine wonder. Judges who follow the ML/graphics space will immediately recognize the technical sophistication.

**Taste principles:** The capture quality matters enormously — a sloppy splat looks worse than no splat. Use it for moments that benefit from spatial exploration: product showcases, architectural walkthroughs, art installations. Load times are significant, so treat the loading experience as part of the design. Consider mobile carefully — splat rendering is GPU-intensive and may need a fallback or reduced resolution on mobile devices.

---

### 7. Variable Font Axes as Living Typography

**What it is:** Font-variation-settings axes (`wght`, `wdth`, `slnt`, `ital`, or custom axes) driven in real-time by interaction — scroll velocity, cursor position, time of day, audio input, or data feeds.

**Why it matters:** Typography that breathes. Letters that get heavier as you scroll faster, or wider as your cursor moves across them, or that shift weight based on the time of day. This transforms type from static content into a living, responsive material. It signals a deep understanding of both typography and interaction design.

**Taste principles:** The axis changes should feel organic, not twitchy. Smooth the input values aggressively — raw mouse coordinates or scroll velocities produce jittery results. Limit yourself to one or two axes per interaction; animating weight AND width AND slant simultaneously looks chaotic. The font must actually support the axes you're animating (many variable fonts only have `wght`). Test at the extremes — some fonts break down at their minimum or maximum axis values.

**Note:** While interaction-driven variable fonts remain encouraged, be aware that basic scroll-linked weight changes have become more common since 2024. To stay in Tier 3 territory, push beyond simple weight animation — use custom axes, combine with SplitType for per-character control, or drive axes from unexpected data sources.

---

### 8. Generative Variation

**What it is:** Procedural algorithms ensure no two visits produce identical visual output. Layout, color, typography, particle behavior, or compositional elements are generated algorithmically, creating a unique experience each time.

**Why it matters:** The web is full of identical experiences. Generative variation turns a website into a living system — something that rewards return visits and creates a sense of discovery. It also signals algorithmic sophistication; the designer didn't just make one layout, they designed a *system* that produces infinite valid layouts.

**Taste principles:** The variation must be *bounded* — every generated output should look intentional and beautiful, not random. This requires defining constraints carefully: acceptable color ranges, minimum contrast ratios, layout grids that flex but don't break. The worst generative sites produce occasional ugly outputs. The best make you want to refresh just to see what happens next. Seed-based generation (where the URL or timestamp determines the output) lets users share specific variations, which adds a social dimension.

---

### 9. Generative WebAudio

**What it is:** Sound that is generated or modulated in real-time based on interaction, scroll position, or visual state — not a pre-recorded track with play/pause. The audio is as dynamic as the visuals.

**Why it matters:** 99% of websites are silent. Of the 1% that have audio, most just play a background track. Generative audio — tones that shift as you scroll, ambient textures that respond to cursor movement, rhythmic elements that sync with animation beats — creates a genuinely multisensory experience. This is the frontier that most designers haven't even considered.

**Taste principles:** Audio must be opt-in. Always. No autoplay. Provide a clear, persistent mute toggle. The audio should enhance, not distract — ambient and textural is almost always better than melodic. Test on speakers AND headphones; what sounds subtle on laptop speakers might be overwhelming in headphones. Keep volume conservative; it's better to be too quiet than too loud. Consider that many users browse in public spaces.

---

### 10. Canvas Text Decomposition

**What it is:** Text rendered to a hidden canvas, then the pixel data extracted and used to drive particle systems, displacement maps, or per-pixel animations. The text becomes a data source rather than a display element.

**Why it matters:** DOM text can be animated with transforms, opacity, and SplitType character splits. Canvas text decomposition goes further — each pixel of a letterform becomes an independent point that can scatter, reform, flow like liquid, or respond to forces. It's the bridge between typography and particle art.

**Taste principles:** The text must remain legible at its rest state. The decomposition effect should feel purposeful — text that shatters on interaction and reforms, or text that assembles from particles on scroll. Avoid effects where the text is permanently illegible; if the user can't read it, it's not typography anymore, it's abstract art (which may be fine, but be intentional about it). Performance varies dramatically based on canvas resolution — test on lower-end devices.

---

### 11. Physics-Driven UI

**What it is:** 2D or 3D physics engines (Matter.js, Rapier.js, Cannon.js) powering interface interactions. Elements that fall, collide, bounce, stack, and respond to forces like gravity, friction, and user-applied impulses.

**Why it matters:** Physics creates delight through surprise. When navigation items tumble into place, or portfolio cards stack and scatter with realistic weight, or a cursor drags elements that swing on invisible springs — the site feels alive in a way that eased transforms never achieve. Real physics is chaotic in a beautiful way.

**Taste principles:** Physics should feel like a design choice, not a tech demo. Use it for specific moments (a playful 404 page, an interactive portfolio grid, a loading sequence) rather than applying it to everything. The physics parameters (gravity, restitution, friction) should be tuned to feel right, not realistic — web physics should feel lighter and snappier than real-world physics. On mobile, consider replacing complex physics with simpler spring animations that capture the same feeling without the CPU overhead.

---

### 12. WebGPU Compute Shaders

**What it is:** Using the WebGPU API's compute shader capability for parallel processing directly in the browser — fluid simulations, complex particle systems, real-time image processing, or neural network inference on the GPU.

**Why it matters:** WebGPU is the successor to WebGL, and compute shaders are its most powerful feature. They unlock general-purpose GPU computing in the browser — capabilities that were previously impossible without native applications. A site running fluid dynamics or real-time style transfer via compute shaders signals that the team is working at the absolute bleeding edge of web technology.

**Taste principles:** WebGPU support is still limited (Chrome and Edge primarily, with Firefox and Safari in progress). Always provide a WebGL or even a CSS fallback. The compute shader should solve a problem that WebGL genuinely can't — if the same effect is achievable with a fragment shader, use the more widely supported approach. Frame the fallback as a first-class experience, not a broken version.

---

### 13. View Transitions API (Native Browser)

**What it is:** The browser-native View Transitions API, which enables smooth animated transitions between DOM states or page navigations without JavaScript animation libraries. The browser handles the snapshot, cross-fade, and position interpolation natively.

**Why it matters:** This is the web platform catching up to what Barba.js + GSAP have been doing for years — but with native performance, accessibility, and simplicity. Using View Transitions signals awareness of where the platform is heading. For multi-page sites, it can replace heavy JS transition libraries with a few lines of CSS and a single API call.

**Taste principles:** Native View Transitions are powerful but still limited in their choreography compared to GSAP-driven transitions. Use them where simplicity is a virtue — content sites, blogs, portfolios with clean layouts. For highly choreographed, multi-element transitions (FLIP morphs, staggered reveals, complex overlays), Barba.js + GSAP still offers more control. The best approach may be hybrid: View Transitions for the base transition, enhanced with GSAP for specific elements. Always test cross-browser — Safari support is still evolving.

---

### 14. Image Sequences with Alpha Compositing

**What it is:** Pre-rendered animation frames composited on 2D canvas — JPEG color data combined with a separate PNG alpha channel — creating filmstrip-like animations with transparency, without video codecs or dozens of individual image files.

**Why it matters:** Video elements can't have transparency. Animated PNGs are enormous. GIFs are limited to 256 colors. Image sequence compositing solves all of these — delivering video-quality animation with alpha transparency at reasonable file sizes. It's a clever technical solution that shows engineering thinking.

**Taste principles:** The animation quality is only as good as the source material — pre-render at high quality. Keep sequences short (2-5 seconds) and loop seamlessly. The canvas rendering should be synced to scroll or interaction, not just auto-playing — a scroll-scrubbed image sequence is significantly more engaging than an auto-looping one. Consider lazy-loading the image strips and showing a static first frame while loading.

---

## Decision Tree: Choosing Your Tier

When you're designing an interaction, ask:

1. **Is this a forbidden pattern?** → STOP. Redesign.

2. **Is this an overused pattern (Tier 2)?** → Proceed only if you can document the twist. Write it down. Verify it's unrepeatable.

3. **Is this an encouraged pattern (Tier 3)?** → Implement it if you have technical confidence and timeline.

4. **Is this something new?** → Verify it's not hiding a forbidden or overused pattern underneath.

Example flow:

```
"I want a custom cursor."
├─ "Is it mix-blend-mode: difference?" (Forbidden)
├─ "Is it context-aware?" (Overused → needs twist)
└─ "Is it physics-based or DOM-to-shader?" (Encouraged)

Conclusion: Context-aware cursor with documentation = Tier 2 (allowed with twist)
```

---

## Audit Your Design

Before launching, scan your interaction for anti-patterns:

- [ ] No generic display fonts (Poppins, Nunito, Lato)
- [ ] No Tailwind default colors (#3B82F6)
- [ ] No pure #000 or #FFF backgrounds
- [ ] No dark palette chosen without user-provided color direction — if user hasn't provided colors, stop and ask
- [ ] No `transition: all` anywhere
- [ ] No mixed icon libraries — Lucide only (search for `font-awesome`, `heroicons`, `phosphor`)
- [ ] No perfectly symmetric layouts
- [ ] No unmodified stock photography
- [ ] No `overflow: hidden` on hero without descender safety
- [ ] If a marquee is present: all three gate questions answered yes and the twist is documented
- [ ] Every Tier 2 pattern has documented twist
- [ ] At least one Tier 3 pattern if aiming for high distinction
- [ ] Visual validation completed (descender check, mobile test, device testing)

If you fail any Tier 1 check, fix it. If you use Tier 2, document the twist. If you can incorporate Tier 3, your judges will notice.
