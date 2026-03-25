# Animation Map: Schema & Reference

The animation map is the primary output of the Invention Gate. It defines WHAT moves, WHERE it moves, and HOW it moves — for every section of the site. The Enhancement Layer reads this map and implements it on top of the Stitch-generated project output.

---

## Schema

The animation map is a structured document with these sections:

### 1. Global Settings

```yaml
tier: 2           # 1 | 2 | 2.5 | 3
easing_language: "slow, heavy, deliberate"  # derived from brand metaphor
scroll_behavior: lenis  # lenis preferred for Tier 2+; any non-touch-hijacking impl acceptable
page_transitions: tanstack-router  # TanStack Router hooks + GSAP
signature_interaction: "liquid cursor that pools on hover"  # one unique interaction
```

### 2. Per-Page Animation Assignments

For each page in the site, list every section and its animation treatment:

```yaml
home:
  hero:
    type: webgl_overlay       # webgl_overlay | scroll_reveal | scroll_pin | static
    description: "WebGL particle field, overlaid on Stitch hero design"
    trigger: page_load
  section_work:
    type: scroll_pin
    description: "Horizontal scroll gallery, ScrollTrigger pin"
    trigger: scroll_enter
  section_about:
    type: scroll_reveal
    description: "Character stagger on headline, fade-up on body"
    trigger: scroll_enter
  footer:
    type: static
    description: "No animation. Lenis snap point."

work:
  hero:
    type: scroll_reveal
    description: "Title reveal with character split, stagger 0.03s"
    trigger: page_load
  project_grid:
    type: scroll_reveal
    description: "Cards fade-up with stagger on scroll"
    trigger: scroll_enter
```

### 3. WebGL/3D Overlay Zones (Tier 2.5+ only)

For sections where a WebGL canvas overlays on top of Stitch's design:

```yaml
webgl_overlays:
  - page: home
    section: hero
    canvas_position: "absolute, full-section, z-index above Stitch HTML"
    scene_type: "particle field"
    interaction: "particles respond to cursor position"
    mobile_fallback: "hide canvas, show Stitch design only"
  - page: work
    section: project_detail_hero
    canvas_position: "absolute, full-width, behind text"
    scene_type: "noise displacement plane"
    interaction: "scroll-driven distortion intensity"
    mobile_fallback: "static gradient"
```

### 4. Animated Text Targets

List every text element that requires character or word-level animation:

```yaml
animated_text_targets:
  - selector: "h1"
    split: chars
    animation: stagger_reveal
    stagger: 0.03
  - selector: ".section-title"
    split: words
    animation: fade_up
    stagger: 0.05
```

### 5. Scroll-Pinned Sections

List every section that gets pinned during scroll:

```yaml
scroll_pins:
  - section: ".horizontal-gallery"
    pin: true
    scrub: 1
    description: "Horizontal scroll within pinned container"
  - section: ".hero"
    pin: true
    scrub: false
    description: "Hero stays fixed while content scrolls over"
```

---

## Easing Language

The easing language is derived from the brand metaphor during the Invention Gate. It defines the motion personality of the entire site.

### Derivation Process

1. Extract the brand's physical qualities from the metaphor (heavy/light, fast/slow, rigid/fluid, mechanical/organic)
2. Map to easing characteristics:

| Brand Quality | Easing Direction |
|---|---|
| Heavy, monumental | Long ease-out, no bounce. `power4.out` |
| Light, airy | Short ease-in-out, slight overshoot. `back.out(1.2)` |
| Precise, mechanical | Linear or stepped. `steps(8)` |
| Organic, fluid | Custom cubic-bezier with asymmetric curves. `power2.inOut` |
| Energetic, fast | Quick ease-in, snap to position. `power3.in` |
| Contemplative, slow | Very long duration (1.2s+), gentle ease-out. `power1.out` |

3. Define 3 named easings for the project:
   - `ease-primary`: main interaction easing (buttons, links, hover)
   - `ease-reveal`: content reveal easing (scroll enters, page loads)
   - `ease-transition`: page transition easing (TanStack Router + GSAP)

---

## Section Architecture Patterns

The animation map's per-page structure follows one of these patterns:

### Linear (Default)
Sections flow top-to-bottom. Each section triggers independently on scroll entry. Standard for most sites.

### Cyclical
Sections loop back to the beginning — last section connects visually/thematically to the first. Good for portfolio sites where "work" cycles back to "home."

### Branching
A central hub (usually hero) with sections that expand on interaction rather than scroll. Good for exploratory/interactive experiences.

### Portal
Each section is a self-contained world. Page transitions between sections are dramatic (full-screen wipes, 3D camera moves). Good for narrative/storytelling sites.

Choose the pattern during the Invention Gate based on brand metaphor and content structure. The pattern determines ScrollTrigger configuration and the TanStack Router transition style.

---

## How the Enhancement Layer Uses This Map

1. Read the animation map
2. Read Stitch's DESIGN.md (for color/type tokens to maintain visual coherence in animations)
3. Read the TanStack Start output from build_site
4. For each page:
   a. Identify sections by semantic HTML structure
   b. Match sections to animation map assignments
   c. Implement animations using the specified type, trigger, and easing
5. Implement global concerns:
   a. Smooth scroll instance (Lenis preferred, `smoothTouch: false`) if required by tier
   b. TanStack Router transition hooks + animation library (global, using `ease-transition`)
   c. WebGL/3D overlays (where specified)
6. Run site-wide — never page-by-page. TanStack Router transitions and Lenis require global context in `__root.tsx`.
