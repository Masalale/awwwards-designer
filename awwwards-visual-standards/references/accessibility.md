# Accessibility Deep Dive

> "The power of the Web is in its universality. Access by everyone regardless of disability is an essential aspect." — Tim Berners-Lee

This reference covers WCAG 2.1 AA baseline requirements, color contrast ratios, focus indicators,
keyboard navigation, reduced-motion preferences, semantic HTML, form accessibility, and ARIA usage.

---

## WCAG 2.1 AA Baseline

Web Content Accessibility Guidelines (WCAG) 2.1 Level AA is the minimum standard for all
Antigravity builds. Level AAA is aspirational but not required.

### The Four Principles (POUR)

| Principle          | What It Means                                        |
|-------------------|------------------------------------------------------|
| **Perceivable**   | Users can perceive information (text alternatives, captions, contrast) |
| **Operable**      | Users can operate the interface (keyboard, no seizure risk) |
| **Understandable** | Content and operation are understandable (readable, predictable) |
| **Robust**         | Content works with assistive technologies (valid HTML) |

### Level AA Requirements Checklist

| Criterion | Requirement | Test |
|-----------|-------------|------|
| 1.4.3 Contrast (Minimum) | Text ≥ 4.5:1, Large text ≥ 3:1 | WebAIM Contrast Checker |
| 1.4.4 Resize Text | No loss of content/functionality at 200% zoom | Browser zoom test |
| 1.4.10 Reflow | No horizontal scroll at 320px width | Resize browser |
| 1.4.11 Non-text Contrast | UI components ≥ 3:1 against adjacent color | Manual check |
| 1.4.12 Text Spacing | No content loss with custom text spacing | Override stylesheet |
| 1.4.13 Content on Hover/Focus | Hover/focus content is dismissible, hoverable, persistent | Mouse/keyboard test |
| 2.1.1 Keyboard | All functionality available by keyboard | Tab through page |
| 2.1.2 No Keyboard Trap | Focus can move away without special keys | Tab + Escape |
| 2.4.1 Bypass Blocks | Skip navigation link OR landmark regions | Screen reader test |
| 2.4.3 Focus Order | Focus order follows logical sequence | Tab through page |
| 2.4.4 Link Purpose | Link purpose is clear from link text alone | Read links in context |
| 2.4.6 Headings and Labels | Headings/labels describe topic or purpose | Read headings |
| 2.4.7 Focus Visible | Keyboard focus indicator is visible | Tab without mouse |
| 3.1.1 Language of Page | `<html lang="en">` attribute present | View source |
| 3.2.1 On Focus | No unexpected context change on focus | Tab through inputs |
| 3.2.2 On Input | No unexpected context change on input | Fill and submit forms |
| 3.3.1 Error Identification | Errors are identified in text | Submit invalid form |
| 3.3.2 Labels or Instructions | Labels or instructions provided | Check form fields |
| 3.3.3 Error Suggestion | Error suggestions provided when possible | Submit invalid form |
| 4.1.1 Parsing | No duplicate IDs, proper nesting | Validate HTML |
| 4.1.2 Name, Role, Value | UI components have accessible names and states | Screen reader test |

---

## Color Contrast

### The Contrast Ratio Math

Contrast ratio is calculated using the Relative Luminance formula from WCAG:

```
L = 0.2126 * R + 0.7152 * G + 0.0722 * B

(where R, G, B are linearized from sRGB)

Contrast Ratio = (L1 + 0.05) / (L2 + 0.05)
(L1 = lighter color, L2 = darker color)
```

A ratio of 4.5:1 means the lighter color reflects 4.5x more light than the darker color.

### Contrast Ratio Quick Reference

| Ratio    | What It Means                                  | WCAG AA |
|----------|------------------------------------------------|---------|
| 21:1     | Black on white                                 | ✅ AAA   |
| 16:1     | Dark gray (#111827) on white                   | ✅ AAA   |
| 10:1     | Medium gray (#374151) on white                  | ✅ AAA   |
| 7:1      | #4b5563 on white — excellent for body text      | ✅ AAA   |
| 4.6:1    | Blue-600 (#2563eb) on white — minimum for AA   | ✅ AA    |
| 4.5:1    | Gray-500 (#6b7280) on white — EXACT minimum    | ✅ AA ⚠️ |
| 3.1:1     | Gray-400 (#9ca3af) on white — large text only  | ✅ AA (large) |
| 3.0:1    | Blue-500 (#3b82f6) on white — large text only   | ✅ AA (large) |
| 2.0:1    | Gray-300 (#d1d5db) on white — FAIL             | ❌      |

### Testing Tools

```html
<!-- Bookmarklet: Color Contrast Checker -->
javascript:(function(){window.open('https://webaim.org/resources/contrastchecker/?fcolor='+((r=document.selection)?r.createRange().text.substring(0,6):((t=document.getSelection())?t.toString().substring(0,6):(prompt('Enter foreground color hex:')||'').replace('#','')))+'&bcolor='+((prompt('Enter background color hex:')||'').replace('#',''))});})();
```

### Contrast in Practice: Gray Text on White

The most common accessibility failure is gray body text that's too light:

```css
/* ❌ DANGEROUS: gray-500 (#6b7280) on white is exactly 4.5:1 */
.text-secondary {
  color: #6b7280; /* Passes technically, fails practically */
}

/* ✅ SAFE: gray-600 (#4b5563) on white is 7.0:1 */
.text-secondary {
  color: #4b5563; /* Comfortably passes AA */
}

/* ✅ FOR CAPTIONS ONLY: gray-500 is acceptable */
.caption {
  color: #6b7280;
  font-size: 0.75rem; /* Small text needs higher contrast anyway */
}
```

### Large Text Definition

WCAG defines "large text" as:
- **18pt+ regular text** (24px+ at 100% zoom)
- **14pt+ bold text** (18.67px+ bold at 100% zoom)

```css
/* Large text can use lower contrast */
.section-label {
  font-size: clamp(1.25rem, 1vw + 0.75rem, 2rem); /* ≥ 18.67px at most viewports */
  /* Contrast of 3.0:1 is acceptable */
  color: #6b7280;
}
```

### Non-Text Contrast (UI Components)

| UI Element           | Required Contrast | Example                             |
|----------------------|-------------------|-------------------------------------|
| Button borders       | 3:1 vs background | Gray button border vs white page   |
| Input borders        | 3:1 vs background | Form field border vs page background |
| Focus indicators     | 3:1 vs both       | Blue focus ring vs button + page    |
| Disabled state icons | 3:1 vs background | Gray icon on white                 |
| Checkboxes/radio     | 3:1 vs background | Border vs background               |

---

## Focus Indicators

### The Visible Focus Requirement

WCAG 2.4.7 requires that keyboard focus is **visible**. The default browser focus ring
is often removed by CSS resets — this must be replaced with a custom, visible indicator.

### Custom Focus Styles

```css
/* ✅ GOOD: High contrast, visible on all backgrounds */
:focus-visible {
  outline: 2px solid #3b82f6;    /* Blue: 4.6:1 on white, 5.2:1 on dark */
  outline-offset: 2px;
  border-radius: 2px;
}

/* ✅ GOOD: Using box-shadow for more control */
:focus-visible {
  box-shadow: 0 0 0 2px #ffffff, 0 0 0 4px #3b82f6;
  /* Inner white ring + outer blue ring */
}

/* ✅ GOOD: For dark backgrounds */
:focus-visible {
  outline: 2px solid #60a5fa;
  outline-offset: 2px;
}

/* ❌ BAD: Low contrast outline */
:focus-visible {
  outline: 1px solid #d1d5db; /* Only ~2.5:1 on white — fails */
}

/* ❌ BAD: No outline offset — butts up against element */
:focus-visible {
  outline: 2px solid #3b82f6;
  outline-offset: 0;
}
```

### Focus on All Interactive Elements

```css
/* Links */
a:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
}

/* Buttons */
button:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
  box-shadow: 0 0 0 4px var(--color-bg-page);
}

/* Inputs */
input:focus-visible,
textarea:focus-visible,
select:focus-visible {
  outline: 2px solid var(--color-accent);
  outline-offset: 0;
  border-color: var(--color-accent);
}

/* Custom controls (checkboxes, toggles, etc.) */
.custom-checkbox:focus-within {
  box-shadow: 0 0 0 2px var(--color-accent);
}
```

### Removing Focus Only When Appropriate

```css
/* Remove focus ONLY for mouse users, keep for keyboard */
:focus:not(:focus-visible) {
  outline: none;
}

/* This allows mouse users to click without seeing focus rings */
/* But keyboard users still get visible focus indicators */
```

---

## Keyboard Navigation

### The No-JavaScript Keyboard Rule

All functionality must be achievable with keyboard alone. This means:
- No `onclick` handlers on non-interactive elements
- No `mousedown` event without corresponding `keydown`
- Tab order follows visual order

### Proper Tab Order

```html
<!-- Logical tab order: follow visual reading order -->
<header>
  <a href="#main" class="skip-link">Skip to content</a>
  <nav>...</nav>           <!-- Tab 1 -->
</header>

<main id="main">
  <h1>Title</h1>           <!-- Not tabbable -->
  <button>Action 1</button> <!-- Tab 2 -->
  <button>Action 2</button> <!-- Tab 3 -->
  <a href="#">Link</a>     <!-- Tab 4 -->
</main>

<footer>
  <nav>...</nav>           <!-- Tab 5 -->
</footer>
```

### Skip Navigation Link

```html
<!-- First focusable element: skip to main content -->
<style>
.skip-link {
  position: absolute;
  top: -100%;
  left: 0;
  background: #2563eb;
  color: white;
  padding: 0.5rem 1rem;
  z-index: 9999;
  text-decoration: none;
  font-weight: 600;
}

.skip-link:focus {
  top: 0;
}
</style>

<a href="#main-content" class="skip-link">Skip to main content</a>

<!-- ... header, nav ... -->

<main id="main-content" tabindex="-1">
  <!-- Skip link lands here when activated -->
</main>
```

### Arrow Key Navigation for Widgets

Custom interactive widgets (dropdowns, menus, carousels, tabs) need arrow key navigation:

```javascript
// Dropdown menu: arrow key navigation
const menuItems = menu.querySelectorAll('[role="menuitem"]');
let currentIndex = 0;

menu.addEventListener('keydown', (e) => {
  if (e.key === 'ArrowDown') {
    e.preventDefault();
    currentIndex = (currentIndex + 1) % menuItems.length;
    menuItems[currentIndex].focus();
  }
  if (e.key === 'ArrowUp') {
    e.preventDefault();
    currentIndex = (currentIndex - 1 + menuItems.length) % menuItems.length;
    menuItems[currentIndex].focus();
  }
  if (e.key === 'Escape') {
    closeMenu();
    trigger.focus();
  }
});
```

### Keyboard Activation

| Key     | Action                                              |
|---------|-----------------------------------------------------|
| Enter   | Activate buttons, links, form submissions            |
| Space   | Activate buttons (toggle), expand/collapse          |
| Escape  | Close modals, menus, tooltips                       |
| Arrow keys | Navigate within widgets (menus, tabs, sliders) |
| Tab     | Move to next focusable element                     |
| Shift+Tab | Move to previous focusable element               |

---

## prefers-reduced-motion

### The Seizure and Vestibular Disorder Concern

Animations can trigger seizures in people with photosensitive epilepsy and cause
nausea/dizziness in people with vestibular disorders. `prefers-reduced-motion` respects
their preferences.

### Implementation

```css
/* Default: full animations */
.animated-element {
  transition: transform 0.3s ease, opacity 0.3s ease;
  animation: fadeSlideIn 0.5s ease;
}

@keyframes fadeSlideIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

/* Reduced motion: instant transitions, no animation */
@media (prefers-reduced-motion: reduce) {
  .animated-element {
    transition: none;
    animation: none;
  }

  /* Or: subtle, non-motion alternatives */
  .animated-element {
    transition: opacity 0.1s ease;
  }
}
```

### What to Disable

| Animation Type              | Disable in reduce-motion? | Alternative                   |
|----------------------------|--------------------------|------------------------------|
| Page transitions            | ✅ Yes                  | Instant swap                 |
| Scroll-linked animations   | ✅ Yes                  | Static positioning            |
| Hover transforms            | ✅ Yes                  | Color change only            |
| Loading spinners           | ✅ Yes                  | Static indicator              |
| Text reveal animations      | ✅ Yes                  | Text visible immediately      |
| Parallax effects           | ✅ Yes                  | No movement                   |
| Background gradients       | ⚠️ Consider             | Static gradient               |
| Color transitions (hovers) | ❌ No                   | Essential for feedback        |
| Focus indicator transitions | ❌ No                   | Essential for feedback        |

### JavaScript Detection

```javascript
const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)');

if (prefersReducedMotion.matches) {
  // Disable GSAP animations
  gsap.globalTimeline.timeScale(0);

  // Or use Lenis with reduced motion
  lenis.options.duration = 0;
  lenis.options.easing = (t) => t; // Linear
}
```

---

## Semantic HTML

### The Foundation of Accessibility

Semantic HTML provides built-in accessibility. A `<button>` is automatically keyboard
accessible, focusable, and announces its role to screen readers. A `<div onclick>` is none of these.

### Interactive Elements

```html
<!-- ❌ WRONG: div pretending to be a button -->
<div class="button" onclick="doSomething()">Click me</div>

<!-- ✅ CORRECT: actual button element -->
<button type="button" onclick="doSomething()">Click me</button>

<!-- ❌ WRONG: anchor pretending to navigate without href -->
<a onclick="doSomething()">Navigate</a>

<!-- ✅ CORRECT: anchor with href -->
<a href="/destination">Navigate</a>

<!-- ❌ WRONG: anchor without href -->
<a>Placeholder</a>

<!-- ✅ CORRECT: button if not a link -->
<button type="button">Placeholder</button>
```

### Headings Structure

```html
<!-- Every page needs exactly one h1 -->
<h1>Page Title</h1>

<!-- Headings must follow logical order (no skipping levels) -->
<section>
  <h2>Section Title</h2>
  <p>...</p>
  <h3>Sub-section</h3>   <!-- ✅ h3 follows h2 -->
  <p>...</p>
  <h4>Detail</h4>         <!-- ✅ h4 follows h3 -->
</section>

<!-- ❌ WRONG: skipping from h2 to h4 -->
<h2>Section</h2>
<h4>Detail (skipped h3!)</h4>
```

### Landmarks

```html
<body>
  <header>               <!-- Banner landmark -->
    <nav aria-label="Main">...</nav>
  </header>

  <main id="main-content">  <!-- Main landmark (one per page) -->
    <article>
      <header>
        <h1>Article Title</h1>
      </header>

      <section aria-labelledby="section-heading">
        <h2 id="section-heading">Section</h2>
        <p>...</p>
      </section>
    </article>
  </main>

  <aside>               <!-- Complementary landmark -->
    <nav aria-label="Related">...</nav>
  </aside>

  <footer>               <!-- Contentinfo landmark -->
    <nav aria-label="Footer">...</nav>
  </footer>
</body>
```

### Tables for Data, Not Layout

```html
<!-- ✅ Data table -->
<table>
  <caption>Quarterly Revenue</caption>
  <thead>
    <tr>
      <th scope="col">Q1</th>
      <th scope="col">Q2</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th scope="row">2024</th>
      <td>$1.2M</td>
      <td>$1.5M</td>
    </tr>
  </tbody>
</table>

<!-- ❌ Layout table: use CSS Grid/Flexbox instead -->
<table>
  <tr><td>Sidebar</td><td>Content</td></tr>
</table>
```

---

## Images and Alt Text

### Alt Text Decision Tree

```
Is the image informative or decorative?
│
├── DECORATIVE (purely visual, no information)
│   └── Use empty alt="" — screen readers skip it
│   └── Example: background pattern, decorative border
│
└── INFORMATIVE (conveys information)
    ├── SHORT description (< 125 chars)
    │   └── alt="Photo of team at annual conference"
    │
    ├── LONG description needed
    │   └── alt="Chart showing 40% increase in Q3"
    │   └── Use longdesc="" or adjacent text
    │
    └── FUNCTIONAL (part of a link/button)
        └── alt="Visit our shop" (not "Picture of shop icon")
```

### Examples

```html
<!-- ✅ Informative: describes the content -->
<img src="team-photo.jpg" alt="Five team members smiling at the office">

<!-- ✅ Decorative: empty alt prevents announcement -->
<img src="decorative-divider.svg" alt="">

<!-- ✅ Functional: describes the action, not the image -->
<a href="/shop">
  <img src="shop-icon.svg" alt="Shop">
</a>

<!-- ❌ BAD: "image of" is redundant -->
<img src="logo.png" alt="Image of company logo">

<!-- ❌ BAD: filename as alt text -->
<img src="IMG_4567.jpg" alt="IMG_4567.jpg">

<!-- ❌ BAD: missing alt entirely -->
<img src="photo.jpg">
<!-- This gets announced as "photo.jpg" by screen readers -->
```

### Complex Images

```html
<!-- Chart with detailed data: short alt + long description -->
<figure>
  <img src="chart.png" alt="Bar chart showing Q3 revenue increased 40% to $2.1M">
  <figcaption>
    <h2>Revenue Growth</h2>
    <p>Full data table follows...</p>
    <table>
      <caption>Quarterly Revenue (Millions)</caption>
      <!-- detailed table -->
    </table>
  </figcaption>
</figure>
```

---

## Form Accessibility

### Labels Are Non-Negotiable

Every form input must have an associated `<label>`. The `for` attribute must match the input's `id`.

```html
<!-- ✅ CORRECT: explicit label association -->
<label for="email">Email address</label>
<input type="email" id="email" name="email" autocomplete="email">

<!-- ✅ CORRECT: label wraps input -->
<label>
  Password
  <input type="password" id="password" name="password">
</label>

<!-- ❌ WRONG: placeholder is not a label -->
<input type="email" placeholder="Enter your email">

<!-- ✅ CORRECT: placeholder AS SUPPLEMENT, not replacement -->
<label for="email">Email address</label>
<input type="email" id="email" placeholder="name@example.com">

<!-- ❌ WRONG: no label at all -->
<input type="email">
```

### Required Field Indication

```html
<!-- ✅ Correct: aria-required + visible indicator -->
<label for="name">
  Full Name
  <span aria-hidden="true">*</span>
  <span class="sr-only">(required)</span>
</label>
<input type="text" id="name" required aria-required="true">

<style>
.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}
</style>
```

### Error Handling

```html
<!-- ✅ Correct: error message linked with aria-describedby -->
<label for="email">Email</label>
<input
  type="email"
  id="email"
  aria-describedby="email-error"
  aria-invalid="true"
>
<span id="email-error" role="alert">
  Please enter a valid email address (e.g., name@example.com)
</span>

<!-- ✅ Use role="alert" for error announcements -->
<!-- Screen readers announce alert content when it appears -->
```

### Fieldset and Legend

```html
<fieldset>
  <legend>Delivery address</legend>

  <label for="street">Street address</label>
  <input type="text" id="street" name="street">

  <label for="city">City</label>
  <input type="text" id="city" name="city">
</fieldset>

<fieldset>
  <legend>Billing address</legend>
  <!-- Same pattern -->
</fieldset>
```

---

## ARIA: Use Sparingly

### The First Rule of ARIA

> "If you can use a native HTML element or attribute with the built-in semantics and behavior,
> do so. Override the semantics of native elements only when you have no alternative."

### When ARIA Is Needed

| Scenario                           | ARIA Needed? | Solution                        |
|-----------------------------------|--------------|---------------------------------|
| Native `<button>`                 | No           | Just use `<button>`             |
| Custom button component           | Yes          | `role="button"`, `tabindex="0"` |
| Modal dialog                      | Yes          | `role="dialog"`, `aria-modal`   |
| Disclosure (show/hide)           | Yes          | `aria-expanded`, `aria-controls` |
| Tabs                              | Yes          | `role="tablist"`, `role="tab"`  |
| Accordion                        | Yes          | `aria-expanded`, `aria-controls` |
| Live regions (updates)            | Yes          | `aria-live`, `aria-atomic`      |
| Hidden content (visually hidden) | Yes          | `aria-hidden="true"`            |

### ARIA for Disclosure

```html
<button
  type="button"
  aria-expanded="false"
  aria-controls="details-content"
  id="details-toggle"
>
  Show details
</button>

<div id="details-content" hidden>
  <!-- Content that shows/hides -->
</div>

<script>
  const toggle = document.getElementById('details-toggle');
  const content = document.getElementById('details-content');

  toggle.addEventListener('click', () => {
    const isExpanded = toggle.getAttribute('aria-expanded') === 'true';
    toggle.setAttribute('aria-expanded', !isExpanded);
    toggle.textContent = isExpanded ? 'Show details' : 'Hide details';
    content.hidden = isExpanded;
  });
</script>
```

### ARIA for Live Regions

```html
<!-- Announce search results count when it changes -->
<div aria-live="polite" aria-atomic="true" class="sr-only">
  <span id="result-count">5 results found</span>
</div>

<!-- For urgent updates (errors, alerts) -->
<div role="alert">
  Your session will expire in 5 minutes.
</div>
```

### Common ARIA Mistakes

| Mistake                        | Why It's Wrong                        | Fix                                  |
|-------------------------------|--------------------------------------|--------------------------------------|
| `role="button"` on `<a>`      | Anchor already has button semantics   | Use `<button>` or keep `<a href>`    |
| `aria-label` without content   | Replaces visible text                | Use visible text when present        |
| `aria-hidden="true"` on focusable | Removes from AT but not keyboard | Don't hide focusable elements        |
| `aria-required="true"` on `<input required>` | Redundant | Just use `required` attribute |
| `role="img"` without alt       | Image has no accessible name          | Add `aria-label` or `aria-labelledby` |

---

## Screen Reader Testing

### Quick Testing Checklist

1. **Navigate with Tab** — Can you reach every interactive element?
2. **Read headings** — Does the heading structure make sense out of context?
3. **Form completion** — Can you complete a form using only a screen reader?
4. **Images** — Are images described appropriately?
5. **Dynamic updates** — Do live regions announce changes?

### Screen Readers to Test With

| Platform  | Screen Reader           | Best For                            |
|-----------|------------------------|-------------------------------------|
| Windows   | NVDA (free)            | Most popular, good all-around       |
| Windows   | JAWS                   | Enterprise, comprehensive           |
| macOS     | VoiceOver (built-in)   | Apple users                         |
| iOS       | VoiceOver (built-in)   | Mobile testing                      |
| Android   | TalkBack (built-in)     | Android mobile testing              |
| Browser   | axe DevTools extension  | Automated accessibility checks       |

### VoiceOver Quick Commands (macOS)

| Command              | Action                          |
|---------------------|---------------------------------|
| Cmd + F5            | Toggle VoiceOver                |
| Tab / Shift+Tab     | Navigate forward/backward       |
| Ctrl + Option + ←→ | Read next/previous element      |
| Ctrl + Option + U   | Open rotor (headings, links)   |
| VoiceOver + H       | Navigate by heading            |
| VoiceOver + L       | Navigate by link               |
