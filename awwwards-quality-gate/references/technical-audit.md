# Technical Quality Gate — Deep Dive

> Load when running Gate 7 (Technical Quality). This is the detailed audit checklist for code-level checks.

---

## Build Audit

**These are automatic failures:**

- [ ] **`bun run build` succeeds** — Zero build errors. Zero TypeScript errors. Zero ESLint errors.
- [ ] **No build warnings** — Warnings should not be ignored. Treat warnings as errors.
- [ ] **Production build** — Build output is production-ready (minified, tree-shaken, not in dev mode).
- [ ] **Bundle size within tier budget** — Check `bun run build` output for bundle sizes. JS bundle should be ≤200KB gzipped for a standard landing/small site. If using a framework, know your tier budget.
- [ ] **No `bun run dev` dependency** — The built output doesn't require a dev server to run.

---

## Route Audit

- [ ] **All routes render content** — Every defined route (e.g., `/about`, `/contact`, `/blog/:slug`) renders real, complete content. No blank pages.
- [ ] **No dead nav links** — Every link in the nav goes to a working route. Test all manually.
- [ ] **Dynamic routes handle invalid params** — `/blog/non-existent-slug` shows a 404 or "not found" state, not a crash or blank page.
- [ ] **Redirects work** — Any legacy URLs or redirects in place are tested and work correctly.
- [ ] **Sitemap.xml exists** — All public pages are included in `sitemap.xml`.
- [ ] **robots.txt exists** — Correct `robots.txt` present, allowing/disallowing as intended.

---

## Asset Audit

- [ ] **No 404 assets** — Open Network tab. Load every page. Zero 404 responses for images, fonts, scripts, or other assets.
- [ ] **Images resolve** — All `<img src>` and `background-image` URLs return 200 OK.
- [ ] **Fonts resolve** — All custom fonts load successfully. No 404 on font files.
- [ ] **CDN assets resolve** — Any CDN-hosted assets (analytics, maps, etc.) return 200.
- [ ] **Video/audio assets** — If using `<video>` or `<audio>`, the source files resolve. Fallback poster image exists.

---

## Semantic HTML Audit

**These are automatic failures:**

- [ ] **Proper heading hierarchy** — h1 (one per page, page-specific), h2 for major sections, h3 for subsections. No skipped levels (e.g., h1→h3 with no h2).
- [ ] **Landmark elements** — `<header>`, `<main>`, `<footer>`, `<nav>`, `<aside>` used correctly. One `<main>` per page.
- [ ] **Button vs. link** — `<button>` for actions (submit, open, toggle). `<a>` for navigation. Never use `<a>` without `href`. Never use `<button>` for links.
- [ ] **Lists for lists** — `<ul>`, `<ol>`, `<dl>` for list content. Not `<div>` groups.
- [ ] **Tables for tabular data** — Use `<table>` for data tables. Not for layout.
- [ ] **Figures** — Images with captions use `<figure>` and `<figcaption>`.
- [ ] **Time elements** — Dates/times use `<time>` with `datetime` attribute.
- [ ] **No div soup** — A page full of `<div>` elements with no semantic meaning is a fail. Each `<div>` should have a purpose.

---

## Icon Audit (Technical)

**These are automatic failures:**

- [ ] **Lucide only** — The project uses **only** the Lucide icon library. No Font Awesome, Heroicons, Phosphor, Feather, Tabler, or any other icon library.
- [ ] **Search for violations** — Run in project root:
  ```bash
  grep -r "font-awesome\|heroicons\|phosphor\|feather-icons\|tabler-icons" --include="*.html" --include="*.jsx" --include="*.tsx" --include="*.vue" .
  ```
  Any hit = immediate fail.
- [ ] **Icons as React/Svelte components** — Icons imported from `lucide-react` or `lucide-svelte`. Not inline SVG strings scattered across code.
- [ ] **Consistent sizing** — Icons use a consistent size prop (16, 20, 24, 32). Not random pixel values.

---

## CSS Audit

**These are automatic failures:**

- [ ] **No `transition: all`** — Every `transition` must specify exact properties. `transition: all` is forbidden. Example: `transition: opacity 0.3s ease, transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1)`.
- [ ] **No `animation: linear`** — Linear easing is robotic. Use `ease`, custom `cubic-bezier`, or named easing functions.
- [ ] **No `overflow: clip` on text** — `overflow: clip` hides text and breaks accessibility. Use `overflow: hidden` with `text-overflow: ellipsis` for truncation, or `overflow: visible`.
- [ ] **No `100vh` on mobile full-screen** — Use `100dvh` (dynamic viewport height) on any element intended to be full-screen on mobile. `100vh` causes address bar overlap.
- [ ] **Descender safety** — Any text element with `font-size > 48px` must have `overflow: visible` on the container, OR adequate `padding-bottom` (≥4px) to prevent glyph clipping on letters g, y, p, q, j.
- [ ] **Custom properties defined** — Design tokens (colors, spacing, fonts) as CSS custom properties in `:root`. No magic numbers in component CSS.
- [ ] **No `!important` abuse** — `!important` should be rare (utility classes, responsive overrides). Not in component styles.
- [ ] **Responsive at 375px** — `@media` queries handle 375px mobile without breaking. No horizontal scroll.
- [ ] **`prefers-reduced-motion` respected** — All animations wrapped in `@media (prefers-reduced-motion: no-preference)` or use `animation-play-state`.

---

## JavaScript Audit

- [ ] **No mixed libraries** — Choose one framework (React, Svelte, Vue) and use it consistently. No jQuery + React. No Alpine + Vue.
- [ ] **No jQuery** — jQuery is a red flag. Zero jQuery in the codebase. `grep -r "jquery" .` should return nothing.
- [ ] **Bundle within tier budget** — JS bundle ≤200KB gzipped for standard sites. Check with `bun run build && bunx bundlephobia-cli [module]`.
- [ ] **No inline scripts** — All JS in modules/files. No `<script>` tags with code in HTML (except minimal analytics snippets).
- [ ] **No console.log in production** — Debug `console.log` removed. Error tracking via proper error boundaries or monitoring.
- [ ] **Event delegation where appropriate** — Don't attach individual listeners to every item; use delegation on parent.
- [ ] **`defer` or `async` on scripts** — Non-critical scripts use `defer`. Analytics/scripts that can run async use `async`.

---

## Descender Safety (Critical)

**This is the most commonly missed technical detail.**

Text clipping on letters g, y, p, q, j happens when:
- Container has `overflow: hidden` or `overflow: clip`
- Container is exactly the height of the font size
- No bottom padding to account for descender space

**Rule:** Any text element where `font-size > 48px` must have:
```css
/* Option 1: overflow visible */
.oversized-text {
  font-size: 72px;
  overflow: visible;
  /* Add padding-bottom to prevent visual collision */
  padding-bottom: 8px;
}

/* Option 2: explicit line-height */
.oversized-text {
  font-size: 72px;
  line-height: 1.1; /* enough to contain descenders */
}
```

Test: Render "gypqj" at max font size and verify full glyph visibility.

---

## Viewport / Mobile Safety

- [ ] **`100dvh` on full-screen sections** — Mobile browsers use dynamic viewport height. `100dvh` = actual visible area (minus browser chrome).
  ```css
  /* WRONG */
  .hero { height: 100vh; }
  
  /* CORRECT */
  .hero { height: 100dvh; }
  ```
- [ ] **`min-height` not `height` on dynamic content** — Use `min-height` for sections that grow with content. `height` causes overflow.
- [ ] **`100dvh` + `padding-bottom`** — When using `100dvh` for a hero, account for the fact that the visible area may shrink when scrolling. Consider `min-height: 100dvh` instead of fixed `height`.
