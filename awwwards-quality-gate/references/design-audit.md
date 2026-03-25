# Design Quality Gate — Deep Dive

> Load when running Gate 1 (Design Quality). This is the detailed audit checklist for visual and brand decisions.

---

## Typography Audit

**These are automatic failures:**

- [ ] **No default system fonts** — `system-ui`, `Arial`, `Helvetica`, `Times New Roman`, `Georgia` as primary fonts. Custom fonts or quality variable fonts only.
- [ ] **Consistent font stack** — All type uses the same family (or approved secondary). No random font changes mid-page.
- [ ] **Consistent type scale** — Modular scale in use (1.25×, 1.333×, etc.). Not arbitrary random sizes.
- [ ] **Readable hierarchy** — h1 is largest, h2 secondary, h3 tertiary. No skipped levels. Body text at a size that doesn't require zooming.
- [ ] **No clipped descenders** — Letters g, y, p, q, j must not be cut off. **Critical rule**: any text element with `font-size > 48px` must have `overflow: visible` OR adequate `padding-bottom` to prevent glyph clipping. Test with "gypqj" strings at max font size.
- [ ] **Line height appropriate** — Body text: 1.5–1.7. Headings: 1.1–1.3. Tight but not cramped.
- [ ] **Letter spacing intentional** — All caps text should have tracked letter-spacing. No random letter-spacing on body text.
- [ ] **No text overflow** — No text running off containers. No `...` truncation without tooltip/expansion.

---

## Color Audit

**These are automatic failures:**

- [ ] **Coherent palette** — Maximum 2–3 primary colors + neutrals. No more than 6 distinct colors total. More than that = incoherent.
- [ ] **WCAG AA contrast** — All body text ≥4.5:1 ratio. Large text (≥18pt regular / ≥14pt bold) ≥3:1. Check all states: default, hover, active, disabled.
- [ ] **Not generic/template** — The palette must feel intentional to this brand. A tech startup should not look like a law firm. A luxury brand should not look like a SaaS product.
- [ ] **Dark mode / light mode** — If one exists, the other must too. Both must meet contrast requirements.
- [ ] **Color is not decorative-only** — Every color used must serve a purpose: brand, hierarchy, feedback (error/success), or state.
- [ ] **Hover/active states have contrast** — Interactive elements must not lose contrast on hover/active.
- [ ] **No pure #000000 or #FFFFFF** — Unless intentional brand choice. Off-black (#0a0a0a, #111) and off-white (#fafafa, #f5f5f5) feel more premium.

---

## Layout Audit

**These are automatic failures:**

- [ ] **Intentional rhythm** — Sections don't all look the same. There is variety: full-bleed vs. contained, dense vs. airy, single-column vs. multi-column.
- [ ] **Asymmetric where appropriate** — Not everything centered. Hero text left-aligned. Grid offset. Images breaking columns. Asymmetry creates visual interest.
- [ ] **Breathing room** — Generous padding/margin. Content doesn't feel cramped. White space is used intentionally, not as an afterthought.
- [ ] **Consistent spacing scale** — 4px/8px base grid. All spacing is a multiple of 4px (or 8px). No arbitrary spacing values like 37px or 53px.
- [ ] **Grid system** — If multi-column, a consistent grid (12-col, 8-col) in use. Not random widths.
- [ ] **Responsive behavior** — Layout adapts to breakpoints, not just hides things. Mobile layout should feel designed, not broken.
- [ ] **No equal visual weight everywhere** — Some sections/features are more prominent. If everything is "loud," nothing is.

---

## Image Audit

**These are automatic failures:**

- [ ] **High quality** — No pixelated, no stretched, no low-res images. All images should look crisp on retina displays.
- [ ] **Relevant content** — No generic stock photos of "diverse team laughing." Images must be purposeful: brand photography, product shots, or meaningful illustration.
- [ ] **Not stock-heavy** — Awwwwards jury immediately spots stock photos. Maximum 1–2 stock images if they serve a specific purpose. Prefer custom photography, real products, or purpose-built illustration.
- [ ] **Proper aspect ratios** — Images don't jump layout (use `aspect-ratio` CSS). Portrait/landscape/square consistently applied per context.
- [ ] **Optimized formats** — WebP or AVIF with Jpeg fallback. No PNG for photos (only for graphics with transparency).
- [ ] **Responsive images** — `srcset` for different display densities. `sizes` attribute correctly set.
- [ ] **Lazy loading** — Below-fold images use `loading="lazy"`. Above-fold hero images load eagerly.

---

## Icon Audit

**These are automatic failures:**

- [ ] **Single library** — One and only one icon library. **Must be Lucide** for Antigravity builds. Zero exceptions.
- [ ] **Consistent stroke weight** — All icons same stroke width (usually 1.5px–2px). No mixing 1px and 2px icons.
- [ ] **Consistent size** — Icons at fixed sizes (16, 20, 24, 32px). No random scaling.
- [ ] **Purposeful use** — Icons serve a function (navigation, action, status) or reinforce meaning. Not decorative noise.
- [ ] **Accessible** — Icons with no accompanying text have `aria-label`. No `aria-hidden="false"` on icon-only buttons.
- [ ] **No inline SVG spam** — Inline SVGs must be documented. Random inline SVGs are a maintenance hazard.
- [ ] **Check for violations** — Search codebase: `heroicons`, `font-awesome`, `phosphor`, `feather`, `tabler`, `remix-icon`. Any hit = immediate fail.

---

## Spacing Audit

- [ ] **4px/8px base unit** — All spacing values are multiples of 4px. Common values: 4, 8, 12, 16, 24, 32, 48, 64, 96, 128px.
- [ ] **Generous whitespace** — Section padding ≥64px on desktop, ≥32px on mobile. Components have internal spacing. Nothing feels cramped.
- [ ] **No micro-margins** — If spacing is <4px, it should be 0 (or 2px for fine adjustments). No 7px, 11px, 13px values.
- [ ] **Consistent component spacing** — Related elements grouped with consistent gap values. Use CSS custom properties (--space-sm, --space-md, --space-lg) to enforce consistency.

---

## Brand Audit

- [ ] **Design reflects brand** — Does the visual language match what the brand stands for? A fintech brand should feel trustworthy and precise. A creative agency should feel bold and distinctive.
- [ ] **Not template aesthetic** — Recognizable templates (generic hero + 3-column features + footer) are an automatic fail. Every section should feel custom.
- [ ] **Logo treatment correct** — Logo is SVG, correct proportions, correct clear space, correct colors (not forced into a color that breaks it).
- [ ] **No design inconsistency** — Every page feels like part of the same brand. Fonts, colors, spacing, icons all consistent.
- [ ] **Micro-brand moments** — Small details that show craft: custom cursor, branded scrollbar, selection color, favicon, loading state, custom focus ring.
