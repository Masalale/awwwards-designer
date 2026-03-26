# Stitch Brief: Writing Awwwards-Caliber Prompts for Stitch MCP

This reference defines how to translate an Invention Gate output into a Stitch-compatible prompt that produces high-fidelity, award-level UI designs.

---

## Core Principle

Stitch designs the static 2D visual layer — what the site looks like at rest. The Enhancement Layer in Phase 4 owns everything that moves, animates, or transitions, as well as the TanStack Start project structure.

---

## Injecting the Invention Gate Output

The Invention Gate produces the richest creative material in the pipeline. The brand metaphors, visual implications, and emotional grounding should be injected directly into the Stitch prompt — not summarized or translated. Summarizing loses information. Injection preserves it.

**What to inject into the Aesthetic Direction section:**
1. The full brand metaphors from INVENTION.md — all three, with their concepts verbatim
2. Followed by the visual vocabulary each metaphor implies at rest: layout terms, design shorthand, and at least 3 negative constraints derived from what the metaphors reject

Stitch extracts what is visually relevant. Giving it the complete creative brief gives it the best possible material to work from.

---

## Stitch Prompt Structure

Every Stitch prompt includes these elements in order:

### 1. Brand Identity

**Brand Name:** The actual name of the brand or store. If the user has not provided one, ask before writing the prompt. The creative metaphor codename from the Invention Gate is an internal reference — it must not appear as the brand name in the prompt.

**Brand Description:** One paragraph — what the brand does, who it serves, and the emotional tone, in sensory language.

Example: "Stratum Studio — a Berlin-based architecture firm specializing in cultural institutions. Monumental, restrained, structurally precise. Materials: concrete, steel, glass."

### 2. Aesthetic Direction

Paste the brand metaphors from INVENTION.md here verbatim. Follow them immediately with the visual vocabulary derived from each:
- Layout and composition implications (what each metaphor looks like at rest)
- Reference vocabulary: specific design shorthand Stitch can act on (e.g., `asymmetric editorial grid`, `glassmorphic layering`, `full-bleed product imagery`, `extreme typographic scale contrast`)
- Negative constraints: at minimum 3, derived from what each metaphor explicitly rejects

### 3. Typography Guidance

Describe the typographic voice:
- Role of type — dominant display vs. supporting/functional
- Serif vs. sans-serif direction
- Weight range — light/thin vs. bold/heavy
- Scale ambition — conservative vs. oversized

### 4. Color Direction

If the user provided brand colors: specify them exactly.
If not: describe the palette mood and let Stitch choose.

### 5. Icon System

Specify the icon library: "Use Lucide icons exclusively."

### 6. Shared Components

Define any UI components that appear on every page — particularly the navigation and footer. Because each screen is generated in a separate MCP call, Stitch has no memory of the previous page's design. Without an explicit shared component spec, the nav and footer will differ across pages.

**Navigation:** Specify exactly — brand name position, link labels and order, right-side elements. Write it out as a single sentence Stitch can apply verbatim to every screen.

Example: "[Brand Name] wordmark left-aligned | Center links: STORE · NOTES · INSPO | Right: Search, Cart, Account (Lucide icons)"

**Footer:** Specify the footer content and structure in the same way.

Include these specs in every individual page description in section 7 to ensure consistency across all generated screens.

### 7. Page Structure

List every page with its sections and content. Begin each page description with the shared nav and footer spec from section 6.

For interactive or data-driven sections, describe the UI pattern explicitly — Stitch designs the component and the backend wires it up later.

```
Home: [nav spec] | Hero section | Trending grid (product cards) | New Arrivals | Categories (Him/Her/Unisex) | On Sale | [footer spec]
Store: [nav spec] | Search bar | Filter sidebar (Categories, Notes, Price) | Product grid with "Clone of" tags and Add to Cart | [footer spec]
```

**Functional UI patterns to name explicitly:**
- Listings: "product grid with image, name, price, 'Clone of [Brand]' tag, Add to Cart button per card"
- Filters: "sidebar with checkbox groups for Category and Notes, range slider for Price"
- Auth: "login form with email + password fields, forgot password link"
- Checkout: "order summary sidebar, payment form with card fields"

### 8. Device Target

"Design for desktop (1440px) with mobile-responsive awareness."

---

## Quality Signals

Stitch produces better output when the prompt includes:
- **Specificity over abstraction** — "oversized condensed headlines on a near-white background" beats "elegant and premium"
- **Real content** — actual section names, product types, link labels, not placeholder text
- **Reference vocabulary** — "asymmetric editorial grid," "full-bleed imagery," "glassmorphic nav"
- **Negative constraints** — derived from the metaphors, not generic

---

## MCP Tool Usage

### Generating Screens
Call `generate_screen_from_text` for each page. Pass the full prompt. Set `deviceType: "DESKTOP"`.

Each call is independent — Stitch has no memory of other screens in the same project when generating a new one. Collect every `screenId` returned as screens complete.

### Cross-Page Harmonization
After all screens are generated, call `edit_screens` once with every `screenId` in `selectedScreenIds`. This is the only step where Stitch has simultaneous visibility across all pages — use it to enforce consistency in navigation, footer, typography, button styles, card styles, and color usage across the entire site.

### Building the Project
After the user confirms the screens on the canvas, call `build_site` with:
- `projectId`: the Stitch project ID
- `routes`: array mapping each screenId to its URL path

`build_site` outputs HTML pages with Tailwind CSS. The TanStack Start project structure is established in Phase 4 using these HTML files as the visual foundation.

### Extracting Design Context
Call `extract_design_context` to capture the Design DNA (fonts, colors, layouts) from all generated screens. Save as DESIGN.md — the single source of truth for all design decisions in Phase 4.
