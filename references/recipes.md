# Code Cookbook & Recipes

A centralized collection of high-value, copy-pasteable snippets and architectural constraints to accelerate the implementation of Awwwards-caliber sites.

---

## 🏗️ 1. Execution Recipes

### Smooth Scroll (Lenis) + GSAP Sync
```typescript
import Lenis from 'lenis';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

// Initialize Lenis
const lenis = new Lenis({
  duration: 1.2,
  easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
  orientation: 'vertical',
  smoothWheel: true
});

// Sync Lenis with GSAP ScrollTrigger
lenis.on('scroll', ScrollTrigger.update);
gsap.ticker.add((time) => {
  lenis.raf(time * 1000);
});
gsap.ticker.lagSmoothing(0);

requestAnimationFrame(function raf(time) {
  lenis.raf(time);
  requestAnimationFrame(raf);
});
```

### Magnetic Button Effect
```typescript
const button = document.querySelector('.magnetic-btn');

button.addEventListener('mousemove', (e) => {
  const rect = button.getBoundingClientRect();
  const x = e.clientX - rect.left - rect.width / 2;
  const y = e.clientY - rect.top - rect.height / 2;
  
  gsap.to(button, {
    x: x * 0.3, // Strength of the magnetic pull
    y: y * 0.3,
    duration: 0.3,
    ease: 'power2.out'
  });
});

button.addEventListener('mouseleave', () => {
  gsap.to(button, { x: 0, y: 0, duration: 0.7, ease: 'elastic.out(1, 0.3)' });
});
```

### SplitType + GSAP Text Reveal
Accessible, staggered character reveals for massive hero typography.
```typescript
import SplitType from 'split-type';
import gsap from 'gsap';

// Initialize split (splits text into lines, words, and chars)
const text = new SplitType('.hero-title', { types: 'lines, words, chars' });

// Staggered character reveal
gsap.from(text.chars, {
  y: '100%',
  opacity: 0,
  rotationZ: 10,
  duration: 0.8,
  ease: 'power3.out',
  stagger: 0.02,
});
```

### High-Performance Custom Cursor
Avoid React state re-renders by aggressively manipulating the DOM directly using GSAP.
```tsx
import { useEffect } from 'react';
import gsap from 'gsap';

export function CustomCursor() {
  useEffect(() => {
    const cursor = document.querySelector('.custom-cursor');
    // Using GSAP quickSetter for 60fps performance without React state
    const setX = gsap.quickSetter(cursor, 'x', 'px');
    const setY = gsap.quickSetter(cursor, 'y', 'px');

    const onMouseMove = (e: MouseEvent) => {
      setX(e.clientX);
      setY(e.clientY);
    };

    window.addEventListener('mousemove', onMouseMove);
    return () => window.removeEventListener('mousemove', onMouseMove);
  }, []);

  return (
    <div className="custom-cursor fixed top-0 left-0 w-4 h-4 rounded-full bg-white pointer-events-none mix-blend-difference z-[9999]" />
  );
}
```

### Advanced Grid & Layout CSS Patterns

**Bento Grid (Modular)**
```css
.bento-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: repeat(3, 200px);
  gap: var(--space-md);
}
.bento-item:nth-child(1) { grid-column: 1 / 3; grid-row: 1 / 3; }
.bento-item:nth-child(2) { grid-column: 3 / 5; }
.bento-item:nth-child(3) { grid-column: 3 / 4; }
.bento-item:nth-child(4) { grid-column: 4 / 5; grid-row: 2 / 4; }
```

**Diagonal Flow Section**
```css
.diagonal-section {
  position: relative;
  /* Cuts the top and bottom at an angle */
  clip-path: polygon(0 5%, 100% 0, 100% 95%, 0 100%); 
  padding: var(--space-3xl) 0;
}
.diagonal-content {
  transform: skewY(-2deg); /* Offset the content inside */
}
.diagonal-content > * {
  transform: skewY(2deg); /* Counter-skew direct children to remain flat */
}
```

**Bleed Elements (Full-Width Breakouts)**
```css
.bleed-full {
  width: 100vw;
  margin-left: calc(50% - 50vw);
  margin-right: calc(50% - 50vw);
}
```

### Modern Surfaces & Depth CSS

**Mesh Gradient (Aurora-like)**
```css
.mesh-gradient {
  background-color: var(--color-background);
  background-image: 
    radial-gradient(at 40% 20%, hsla(280,80%,70%,0.3) 0px, transparent 50%),
    radial-gradient(at 80% 0%, hsla(200,80%,60%,0.3) 0px, transparent 50%),
    radial-gradient(at 0% 50%, hsla(340,80%,70%,0.3) 0px, transparent 50%),
    radial-gradient(at 80% 50%, hsla(160,80%,60%,0.3) 0px, transparent 50%),
    radial-gradient(at 0% 100%, hsla(260,80%,70%,0.3) 0px, transparent 50%);
}
```

**Glassmorphism (Light & Dark adaptation)**
```css
.glass-panel {
  background: rgba(255, 255, 255, 0.1);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.2);
}

[data-theme="dark"] .glass-panel {
  background: rgba(0, 0, 0, 0.3);
  border-color: rgba(255, 255, 255, 0.08); /* Darker, subtler border */
}
```

### React Three Fiber: Floating Elements & Particles

**Floating Hero Object**
```tsx
import { Float } from '@react-three/drei';

function HeroMesh() {
  return (
    <Float
      speed={1.5}             // Animation speed
      rotationIntensity={0.5} // XYZ rotation intensity
      floatIntensity={0.5}    // Up/down float intensity
      floatingRange={[-0.1, 0.1]}
    >
      <mesh>
        <torusKnotGeometry args={[1, 0.3, 128, 32]} />
        <meshStandardMaterial color="white" roughness={0.1} metalness={0.8} />
      </mesh>
    </Float>
  );
}
```

---

## 🚫 2. The "Forbidden" Constraints

Do not hallucinate designs. Strictly obey these overrides and replacements.

| Theme | The Forbidden "AI Slop" | The Requirement/Replacement |
|-------|-------------------------|-----------------------------|
| **Fonts** | Inter, Roboto, Arial, System Fonts | Distinctive typography: Space Grotesk, Clash Display, Playfair Display |
| **Colors** | Tailwind blue (`#3B82F6`), Purple-to-Pink on White | HSL-derived mathematical brand colors. Off-blacks (`#0a0a0a`) & Off-whites (`#fafafa`) |
| **Layouts** | Symmetrical 3-column, Centered Hero blocks | Asymmetric, Bento grids, overlapping elements, generous macro-whitespace |
| **Surfaces** | Flat solid backgrounds with standard drop-shadows | Mesh gradients, multi-layer soft colored shadows, Glassmorphism |
| **Icons** | Emojis, FontAwesome, mixed random SVGs | **Lucide React** icons exclusively. Must be consistently sized. |
| **Motion** | `transition: all`, linear easing, bouncing UI | Explicit transitions, custom `cubic-bezier`, orchestrated staggered reveals |

---

## ✅ 3. Ultimate Pre-Delivery Checklist
Before delivering code to the user, mentally verify the following:

**Visual & Brand**
- [ ] No generic fonts used for headings/display text.
- [ ] No "AI slop" gradient colors unless heavily stylized.
- [ ] Layout features asymmetry, overlaps, or a structural "breakout" (not just safe rows).
- [ ] Only Lucide icons are used.

**Motion**
- [ ] No `transition: all` is present in the CSS.
- [ ] Custom easing curves were utilized.
- [ ] Page load features a staggered orchestration, not simultaneous flashing blocks.
- [ ] Hover feedback is fully implemented on all interactive elements.

**Code Quality & A11y**
- [ ] Semantic HTML is used (`<nav>`, `<main>`, `<article>`, `<button>`). No click events on `<div>` tags if an interactive element suffices.
- [ ] `aria-label` is present on all icon-only buttons.
- [ ] Images have explicit height/width set to prevent Cumulative Layout Shift (CLS).
- [ ] The `prefers-reduced-motion` media query is supported natively in Tailwind/CSS configs.
