# Usability Quality Gate — Deep Dive

> Load when running Gate 4 (Usability Quality). This is the detailed audit checklist for user experience and accessibility.

---

## Navigation Audit

**These are automatic failures:**

- [ ] **Clear hierarchy** — Primary nav has ≤7 items. Users can find what they need in ≤3 clicks from any page.
- [ ] **Consistent across all pages** — Nav appears in the same position with the same items on every page. Active state is always visible.
- [ ] **Discoverable** — The user always knows where they are and how to get back. Breadcrumbs on deep pages. Back buttons where appropriate.
- [ ] **Mobile nav** — Hamburger menu (or equivalent) works on mobile. All nav items are reachable. Menu closes after selection.
- [ ] **No dead nav links** — Every nav link goes somewhere real. Test every single nav link manually.
- [ ] **Dropdown/sub-menu accessible** — Hover and keyboard-accessible. Closes on click-outside or Escape key. Focus trapped when open.
- [ ] **Search if applicable** — If the site has >10 pages, search exists and works. Results are relevant.

---

## Mobile Audit (375px)

**These are automatic failures:**

- [ ] **No horizontal overflow** — At 375px viewport, zero horizontal scroll. `overflow-x: hidden` is a band-aid, not a fix — the root cause must be resolved.
- [ ] **All features functional** — Every feature that works on desktop must work on mobile. No "desktop only" functionality without mobile equivalent.
- [ ] **Text readable without zooming** — Body text ≥16px. No text too small to read comfortably at default zoom.
- [ ] **Images responsive** — Not too large, not stretched. `object-fit: cover` or `contain` as appropriate.
- [ ] **Horizontal scroll in carousels/sliders** — These must be swipeable within the viewport, not cause page overflow.
- [ ] **Sticky elements don't overlap content** — Fixed/sticky headers or footers don't obscure content or make it untappable.
- [ ] **`100dvh` on full-screen** — NOT `100vh`. Mobile browsers use dynamic viewport height. `100dvh` accounts for the address bar. Using `100vh` causes the address bar to cover content.

---

## Touch Audit

**These are automatic failures:**

- [ ] **No hover-only interactions** — Nothing that only works on hover (tooltips, reveals, menus). Touch devices have no hover state by default.
- [ ] **Tap targets 44×44px minimum** — All buttons, links, and interactive elements are at least 44×44px. Measure in DevTools.
- [ ] **`smoothTouch: false`** — Any element with `scroll-behavior: smooth` must have `touch-action: manipulation` to prevent double-tap zoom delay.
- [ ] **Swipe interactions work** — Carousels, galleries, and swipeable elements respond to touch swipe gestures.
- [ ] **Pull-to-refresh not broken** — If implemented, must work without causing layout issues.
- [ ] **Long-press on mobile** — Context menus or long-press interactions must be discoverable or have a tap alternative.
- [ ] **No `hover` on mobile-only elements** — CSS `:hover` states can fire on tap on mobile. Ensure `:hover` states don't interfere with tap behavior.

---

## Form Audit

**These are automatic failures:**

- [ ] **All inputs functional** — Every input, select, checkbox, radio, textarea accepts input. Nothing is decoration.
- [ ] **Labels present** — Every input has an associated `<label>` (or `aria-label`/`aria-labelledby`). Placeholders are NOT labels.
- [ ] **Inline validation feedback** — Real-time validation as user types. Helpful messages, not just red borders.
- [ ] **Error states clear** — When validation fails, the specific field and the specific error are highlighted. Error messages are human-readable: "Email must include @" not "Invalid field."
- [ ] **Submit states exist** — Loading state (spinner, disabled button, "Submitting..."). Success state (confirmation message). Error state (retry option, helpful message).
- [ ] **Required fields marked** — Asterisk or "(required)" label. Not a surprise at submission time.
- [ ] **Correct input types** — `type="email"`, `type="tel"`, `type="number"`, `type="date"` — correct types trigger correct mobile keyboards.
- [ ] **Form doesn't lose data on error** — If submission fails, the user's input is preserved so they don't have to re-fill.
- [ ] **CAPTCHA / bot protection** — If required, must not block accessibility (audio alternatives, etc.).

---

## Accessibility Audit

**These are automatic failures:**

- [ ] **Keyboard navigable** — Tab through entire site. Every interactive element reachable via keyboard. No keyboard traps.
- [ ] **Focus indicators visible** — Default browser focus is insufficient. Custom `:focus-visible` styles that are obvious and on-brand.
- [ ] **Alt text on all images** — Every `<img>` has an `alt` attribute. Decorative images: `alt=""`. Meaningful images: descriptive alt text.
- [ ] **Semantic HTML** — `<button>` for buttons, `<a>` for links, `<nav>` for navigation, `<main>` for primary content, `<header>`/`<footer>` for landmarks. No `<div>` soup.
- [ ] **ARIA only where needed** — ARIA should enhance semantics, not replace them. If you need `role="button"`, use `<button>` instead.
- [ ] **Color contrast ≥4.5:1** — All text meets WCAG AA. Use browser extension or Figma plugin to verify.
- [ ] **No autoplay media** — No autoplay audio or video. No looping animation without user consent.
- [ ] **Skip link present** — On pages with significant navigation, a "Skip to main content" link is the first focusable element.
- [ ] **Heading hierarchy** — h1 is unique and page-specific. h2–h6 follow logical nesting. No skipped levels.
- [ ] **Lang attribute** — `<html lang="en">` (or appropriate language code) is set.

---

## Links Audit

- [ ] **No dead links** — Every link goes somewhere real. No placeholder `#` hrefs in production. Test with a link checker or crawl.
- [ ] **External links identified** — Links to external sites open in new tab (or clearly indicate this behavior). `rel="noopener noreferrer"` on external links.
- [ ] **Clear link text** — "Click here" and "Read more" are never acceptable. Link text describes the destination.
- [ ] **Download links clear** — Links to downloadable files (PDF, ZIP) clearly indicate this with text or icon: "Download Case Study (PDF, 2.4MB)."
- [ ] **Email/phone links** — `mailto:` and `tel:` links work correctly. Phone numbers use `tel:` for mobile tap-to-call.

---

## 404 Page Audit

- [ ] **Branded 404 page exists** — The 404 page is not a blank white page or a server error. It uses the site's design language.
- [ ] **Helpful message** — Clear message: "This page doesn't exist" (not a scary error code). Friendly tone.
- [ ] **Navigation back to useful pages** — Links to: homepage, sitemap, search, contact, or most popular pages.
- [ ] **Not a dead end** — A user who lands on 404 should be able to find what they need without using the back button.
- [ ] **HTTP status correct** — 404 page returns HTTP 404 status code, not 200 OK with a fake page.

---

## Error Handling Audit

- [ ] **Network errors handled** — If a fetch/API call fails, the user sees a helpful message, not a blank space or a console error.
- [ ] **Empty states designed** — If a list/search/cart is empty, there is a designed empty state with guidance, not a blank white box.
- [ ] **Loading states exist** — Every async operation (form submit, API call, page navigation) has a visible loading state.
- [ ] **Graceful degradation** — If JavaScript fails or is blocked, the core content is still accessible. Forms still submit (as best as possible).
- [ ] **No console errors** — Zero JavaScript errors in the console on any page. Check all pages: home, about, contact, any dynamic routes.
