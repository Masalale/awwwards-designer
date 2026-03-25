# Stitch Brief: Writing Awwwards-Caliber Prompts for Stitch MCP

This reference defines how to translate an Invention Gate output into a Stitch-compatible prompt that produces high-fidelity, award-level UI designs.

---

## Core Principle

Stitch designs the 2D UI. It has no awareness of animations, 3D, WebGL, scroll behavior, or page transitions. The Stitch brief must describe WHAT THE SITE LOOKS LIKE at rest — not how it moves.

**Never include in a Stitch prompt:**
- Animation instructions (GSAP, scroll triggers, reveals)
- 3D/WebGL references (Three.js, shaders, particles)
- Page transition descriptions
- Scroll behavior specifications
- Interaction patterns (cursor, hover, magnetic)

Stitch designs freely. The Enhancement Layer handles everything else.

---

## Stitch Prompt Structure

Every Stitch prompt should include these elements in order:

### 1. Framework Declaration
State the target framework first. This is always TanStack Start — no exceptions.

> "Build this project using TanStack Start with React. Generate every UI element as a `.tsx` React component. Use Tailwind CSS for all styling. Structure routes using TanStack Start's file-based routing conventions."

### 2. Brand Identity (from Invention Gate)
One paragraph describing the brand: what it does, who it serves, and the emotional tone. Use sensory language Stitch can translate visually.

Example: "A Berlin-based architecture firm specializing in cultural institutions. The brand is monumental, restrained, and structurally precise. Materials are concrete, steel, and glass."

### 3. Aesthetic Direction
Describe the visual feel without prescribing specific solutions:
- Light/dark orientation
- Density (minimal/sparse vs. rich/layered)
- Visual rhythm (uniform vs. varied)
- Mood (clinical, warm, energetic, contemplative)
- Editorial vs. immersive vs. functional

### 4. Typography Guidance
Describe the typographic voice:
- Role of type (dominant/large display vs. supporting/functional)
- Serif vs. sans-serif direction
- Weight range (light/thin vs. bold/heavy)
- Scale ambition (conservative vs. oversized)

### 5. Color Direction
If the user provided brand colors: specify them exactly.
If no brand colors: describe the palette mood. Let Stitch choose.

### 6. Icon System
Specify the icon library explicitly: "Use Lucide icons exclusively."

### 7. Page Structure
List every page with its purpose and content sections. For any interactive or data-driven sections, describe the UI pattern explicitly — Stitch will design the right component and the backend can wire it up later.

```
Home: hero, featured work grid (3-4 items), services overview, testimonial, CTA button
Work: filterable project grid, project cards with image + title + category tag
About: team section, studio philosophy, timeline
Contact: form with name, email, message fields and submit CTA, location map, social links
```

**Functional UI patterns to name explicitly when present:**
- Forms: list every field and the submit action label
- Auth: "login form with email + password fields, forgot password link"
- Dashboard: "stats overview cards, data table with sortable columns, filter sidebar"
- Listings: "product grid with price, rating, add-to-cart button per card"
- Checkout: "order summary sidebar, payment form with card fields"

Stitch designs the UI. What happens when the user submits or clicks is outside Stitch's scope.

### 8. Device Target
Specify: "Design for desktop (1440px) with mobile-responsive awareness."

---

## Quality Signals in Stitch Prompts

Stitch produces better output when the prompt includes:
- **Specificity over abstraction** — "oversized serif headlines on a cream background" beats "elegant and premium"
- **Content hints** — real section names and content types, not "section 1, section 2"
- **Reference vocabulary** — "editorial layout," "asymmetric grid," "full-bleed imagery"
- **Negative constraints** — "no stock photography feel," "avoid centered-everything layouts"

---

## MCP Tool Usage

### Generating Screens
Call `generate_screen_from_text` for each page. Pass the full prompt with all 8 elements. Set `deviceType: "DESKTOP"`.

### Building the Project
After all screens are generated, call `build_site` with:
- `projectId`: the Stitch project ID
- `routes`: array mapping each screenId to its URL path

### Extracting Design Context
Call `extract_design_context` to get the Design DNA (fonts, colors, layouts) from the generated screens. This feeds into the Enhancement Layer as DESIGN.md.

---

## After Stitch Generates

1. Screens appear on stitch.withgoogle.com — reviewable on the canvas.
2. `build_site` outputs a project in the declared framework with Tailwind HTML.
3. `extract_design_context` outputs DESIGN.md — the single source of truth for all design decisions in the Enhancement Layer.
4. The Enhancement Layer reads DESIGN.md + the animation map. All colors, fonts, spacing, and component styles must come from DESIGN.md. No design values are invented.
