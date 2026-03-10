# Pre-Launch Audit: Awwwards-Critical Checks

Run this audit at Step 12. Every unchecked item is a reason to return to that section. Do not declare the site ready until the list is clean.

---

## The 13 Checks

**[ ] 1. Signature interaction survives on touch devices.**
The signature interaction works (or degrades gracefully) on mobile. It doesn't break, disappear without replacement, or create touch-trap states. If the interaction is hover-based, its touch equivalent is implemented and intentional.

**[ ] 2. Descender safety verified at actual viewport sizes.**
Every text element >48px passes the visual check sequence from `references/descender-safety.md` at 375px mobile, 768px tablet, and 1440px desktop. No g/y/q/p characters are clipped at any size. `overflow: clip` appears nowhere on text elements.

**[ ] 3. Typography hierarchy holds at 375px mobile.**
At the smallest breakpoint, H1 > H2 > body creates clear visual hierarchy. The headline still has impact. Type scale doesn't collapse into undifferentiated sizes. `clamp()` minimum values were tested — not just set.

**[ ] 4. Loading sequence is a moment, not a spinner.**
If there is a loading state, it expresses the brand. It is not a CSS spinner, a default browser loader, or a generic progress bar. A visitor would describe it as intentional.

**[ ] 5. `dvh` on all full-screen sections, not `vh`.**
Every section using `100vh` has been converted to `100dvh`. Verified in Chrome DevTools with mobile emulation — the section does not overflow when the address bar appears.

**[ ] 6. Safe area insets applied on notched devices.**
Navigation bars and bottom CTAs use `env(safe-area-inset-top)` and `env(safe-area-inset-bottom)`. Verified in DevTools with an iPhone frame that has a notch.

**[ ] 7. One icon system used throughout — no mixing.**
Every icon on the site comes from the same system. No mixing of Lucide with Font Awesome, Heroicons, Phosphor, or inline SVG from random sources. Stroke weights are consistent.

**[ ] 8. Color contrast passes WCAG AA minimum.**
Body text: 4.5:1 contrast ratio against its background. Large text (>24px bold or >18px regular): 3:1 minimum. Tested with a contrast checker, not estimated by eye.

**[ ] 9. Animation timing serves the brand — not decoration.**
Every animation has a purpose that can be articulated. Hover states feel responsive. Section reveals feel intentional. Nothing is animating simply because the library makes it easy.

**[ ] 10. Touch scroll is not being overridden.**
Lenis (or whatever smooth scroll library is in use) is configured to delegate touch scroll to the browser — not fight it. On a real mobile device or touch simulation, scrolling feels native, not overridden.

**[ ] 11. Pattern Blacklist self-check passed.**
Open `references/anti-patterns.md`. Confirm that no Tier 1 (forbidden) patterns appear in the site. If any Tier 2 (overused) patterns appear, confirm the twist is documented in `INVENTION.md`.

**[ ] 12. `INVENTION.md` is written and accurate.**
`INVENTION.md` exists in the project root. The signature interaction described in it matches what was actually built. The three brand metaphors and the documented twist are accurate — not aspirational notes from before implementation that were never updated.

**[ ] 13. Mobile navigation is usable without hover.**
The mobile menu opens, closes, and navigates correctly using touch only. Touch targets are large enough to tap without precision (minimum 48px). No states require hover to access.
