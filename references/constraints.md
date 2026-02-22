# Constraints — The Anti-Generic Manifesto

**Status:** ACTIVE | **Version:** 4.0.0
**Goal:** Total eradication of "AI Slop." Absolute design intentionality.

Use this as a pre-delivery checklist. Any violation is a failure.

---

## 🎨 Visual Constraints (Auto-Reject)

### Forbidden Fonts
| Never Use | Why | Instead Use |
|-----------|-----|-------------|
| Inter | Overused "safe" choice | Space Grotesk, Cabinet Grotesk, Neue Montreal |
| Roboto | Android/system default | Satoshi, General Sans, Plus Jakarta Sans |
| Arial | Generic sans | Literally anything else |
| System fonts | No personality | At minimum, use a distinctive Google Font |

### Forbidden Colors
| Pattern | Why | Instead |
|---------|-----|---------|
| Purple gradient on white | "AI slop" signature | Any intentional palette |
| #3B82F6 (Tailwind blue) | Default, unconsidered | HSL-derived brand colors |
| Pure black (#000) | Harsh, lifeless | Off-blacks (#0a0a0a, #111) |
| Pure white (#fff) background | Flat, boring | Subtle off-whites or textured |

### Forbidden Layouts
| Pattern | Why | Instead |
|---------|-----|---------|
| 3-column feature grids | Cliché, lazy | Asymmetric bento, broken grid, diagonal flow |
| Centered hero: Title → Subtitle → CTA | Predictable, boring | Asymmetric, overlapping, unexpected |
| Symmetrical everything | Static, lifeless | Intentional asymmetry |
| Full-width everything | No rhythm | Contained widths with breathing room |

### Forbidden Surfaces
| Pattern | Why | Instead |
|---------|-----|---------|
| Flat solid backgrounds | No depth | Grain overlays, subtle gradients, mesh gradients |
| Standard shadows | Generic | Multi-layer soft shadows, colored shadows |
| No texture | Feels digital/sterile | Film grain, noise, subtle patterns |

---

## 🌊 Motion Constraints

### Forbidden Animation Patterns
| Pattern | Why | Instead |
|---------|-----|---------|
| `transition: all` | Performance killer, imprecise | List explicit properties |
| `ease-in-out` | Generic, boring | Custom cubic-bezier curves |
| Linear motion | Robotic, unnatural | Physics-based easing |
| Simultaneous reveals | No hierarchy | Staggered, orchestrated reveals |
| Continuous animation | Distracting | Purposeful, event-driven motion |

### Required Motion Patterns
- [ ] **Page load orchestration** — Elements reveal in sequence, not all at once
- [ ] **Scroll-driven moments** — Something happens as user scrolls
- [ ] **Hover feedback** — Every interactive element responds
- [ ] **Reduced motion support** — `prefers-reduced-motion` media query honored

---

## 💻 Code Constraints

### HTML Semantics
| Forbidden | Required |
|-----------|----------|
| `<div onClick>` for buttons | `<button>` for actions, `<a>` for navigation |
| `<span>` with click handlers | Semantic elements first |
| Missing heading hierarchy | `<h1>` → `<h2>` → `<h3>` in order |
| `<div>` soup | Landmark elements (`<header>`, `<main>`, `<footer>`) |

### Accessibility (Non-Negotiable)
| Check | Severity |
|-------|----------|
| Images have `alt` text | 🔴 CRITICAL |
| Icon-only buttons have `aria-label` | 🔴 CRITICAL |
| Form inputs have `<label>` | 🔴 CRITICAL |
| Focus states are visible | 🔴 CRITICAL |
| Color contrast 4.5:1 minimum | 🔴 CRITICAL |
| `prefers-reduced-motion` respected | 🟡 HIGH |
| Keyboard navigation works | 🔴 CRITICAL |

### Performance
| Check | Severity |
|-------|----------|
| Images have explicit width/height | 🔴 CRITICAL (prevents CLS) |
| Lazy loading below-fold images | 🟡 HIGH |
| No layout reads in render loop | 🟡 HIGH |
| Animations use `transform`/`opacity` only | 🟡 HIGH |
| Large lists virtualized (>50 items) | 🟡 HIGH |

### CSS Anti-Patterns
| Forbidden | Required |
|-----------|----------|
| `outline: none` without replacement | `outline-none focus-visible:ring-2` |
| `!important` everywhere | Specificity discipline |
| Magic numbers | CSS variables for all values |
| `px` units for typography | `rem` or fluid `clamp()` |

---

## 🔍 Pre-Delivery Checklist

### Visual
- [ ] No generic fonts (Inter, Roboto)
- [ ] No "AI slop" colors (purple gradient white)
- [ ] No 3-column feature grids
- [ ] Texture or depth somewhere
- [ ] Asymmetric or unexpected layout element

### Motion
- [ ] No `transition: all`
- [ ] Custom easing curves used
- [ ] Staggered reveals on load
- [ ] Hover states on all interactives
- [ ] `prefers-reduced-motion` query present

### Code
- [ ] Semantic HTML (no `<div>` buttons)
- [ ] All images have alt text
- [ ] All icon buttons have aria-label
- [ ] All forms have labels
- [ ] Focus states visible
- [ ] Images have explicit dimensions
- [ ] No layout shift on load

### Brand
- [ ] Matches approved design doc
- [ ] Consistent visual language
- [ ] Memorable distinctive element

---

**"If it looks like it came from a template, you have failed."**
