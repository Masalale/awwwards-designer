# Tech Stack Guide: Tier-Based Setup & Configuration

> **Version policy:** No version numbers are pinned in this skill. Always install the latest version of every library unless the project has a specific reason to pin. Before writing setup or integration code for any library, use Context7 (or an equivalent MCP documentation tool) to pull current API docs — library APIs shift between major versions and guessing from memory produces bugs.

---

## Tier 1: Astro (CSS-Primary)

For sites where design innovation and performance are paramount. No JavaScript framework needed.

### Setup

```bash
# Create new Astro project
bunx create-astro@latest --template=minimal

cd your-project

# Install only what's needed
bun add astro

# Optional: CSS frameworks
bun add clsx  # Conditional classname utility (1kb)
```

### Project Structure

```
/your-project
├── src/
│   ├── components/
│   │   ├── Header.astro
│   │   ├── Footer.astro
│   │   └── Card.astro
│   ├── layouts/
│   │   └── Base.astro
│   ├── pages/
│   │   ├── index.astro
│   │   └── about.astro
│   └── styles/
│       ├── global.css
│       ├── typography.css
│       ├── colors.css
│       └── animations.css
├── public/
│   └── fonts/
└── astro.config.mjs
```

### Astro Config

```javascript
// astro.config.mjs
import { defineConfig } from 'astro/config';

export default defineConfig({
  // Optimize for fastest build and minimal output
  vite: {
    build: {
      minify: 'terser',
      rollupOptions: {
        output: {
          entryFileNames: '[name]-[hash].js',
          chunkFileNames: '[name]-[hash].js',
          assetFileNames: '[name]-[hash].[ext]'
        }
      }
    }
  }
});
```

### CSS Scroll-Driven Animations Setup

```css
/* src/styles/animations.css */

/* Browser support check */
@supports (animation-timeline: scroll()) {

  /* Fade in on scroll into view */
  .fade-in-section {
    animation: fadeInUp linear;
    animation-timeline: view();
    animation-range: entry 0% cover 50%;
  }

  @keyframes fadeInUp {
    0% {
      opacity: 0;
      transform: translateY(100px);
    }
    100% {
      opacity: 1;
      transform: translateY(0);
    }
  }

  /* Text opacity on scroll */
  .scroll-text {
    animation: textReveal linear;
    animation-timeline: scroll();
    animation-range: 0 1000px;
  }

  @keyframes textReveal {
    0% {
      opacity: 0.3;
      color: #ccc;
    }
    100% {
      opacity: 1;
      color: #000;
    }
  }

  /* Rotate based on scroll position */
  .scroll-rotate {
    animation: rotateOnScroll linear;
    animation-timeline: scroll();
  }

  @keyframes rotateOnScroll {
    0% {
      transform: rotate(0deg);
    }
    100% {
      transform: rotate(360deg);
    }
  }

  /* Parallax background */
  .parallax-bg {
    animation: parallaxMove linear;
    animation-timeline: scroll();
  }

  @keyframes parallaxMove {
    0% {
      background-position: 0 0;
    }
    100% {
      background-position: 0 100px;
    }
  }
}

/* Fallback for non-supporting browsers */
@supports not (animation-timeline: scroll()) {
  .fade-in-section {
    opacity: 1;
    transform: translateY(0);
  }
}
```

### Typography System (Golden Ratio)

```css
/* src/styles/typography.css */

:root {
  /* Golden Ratio: 1.618 */
  /* Base: 1rem = 16px */

  --font-base: 1rem;
  --font-ratio: 1.618;

  /* Responsive typography with clamp() */
  --font-body: clamp(1rem, 1.5vw, 1.125rem);
  --font-lead: clamp(1.25rem, 1.875vw, 1.406rem);
  --font-subheading: clamp(1.625rem, 3vw, 2.25rem);
  --font-heading: clamp(2.625rem, 5vw, 3.5rem);
  --font-display: clamp(4.25rem, 8vw, 5.75rem);
  --font-hero: clamp(6.854rem, 12vw, 9.5rem);

  /* Line heights */
  --lh-body: 1.6;
  --lh-subheading: 1.35;
  --lh-heading: 1.2;
  --lh-display: 1.1;
  --lh-hero: 1.05;

  /* Letter spacing */
  --ls-normal: 0;
  --ls-tight: -0.02em;
  --ls-caps: 0.05em;

  /* Font families (premium) */
  --font-serif: 'Editorial New', Georgia, serif;
  --font-sans: 'Söhne', -apple-system, BlinkMacSystemFont, sans-serif;
  --font-mono: 'PP Neue Machina Mono', monospace;

  /* Descender clearance (per font) */
  --descender-clearance: 0.18em;
}

body {
  font-family: var(--font-sans);
  font-size: var(--font-body);
  line-height: var(--lh-body);
  color: #1a1a1a;
  background: #fafaf8;
}

h1 {
  font-family: var(--font-serif);
  font-size: var(--font-hero);
  line-height: var(--lh-hero);
  font-weight: 600;
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
}

h2 {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 500;
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
}

h3 {
  font-family: var(--font-sans);
  font-size: var(--font-heading);
  line-height: var(--lh-heading);
  font-weight: 600;
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
}

p {
  font-size: var(--font-body);
  line-height: var(--lh-body);
  margin-bottom: 1.5rem;
}

.lead {
  font-size: var(--font-lead);
  line-height: 1.5;
  color: #666;
}

/* All caps */
.caps {
  text-transform: uppercase;
  letter-spacing: var(--ls-caps);
  font-weight: 600;
  font-size: 0.875em;
}

/* Display class */
.display {
  font-family: var(--font-serif);
  font-size: var(--font-display);
  line-height: var(--lh-display);
  font-weight: 600;
  letter-spacing: var(--ls-tight);
  padding-bottom: var(--descender-clearance);
  overflow: visible; /* NOT clip — clip ignores padding */
}
```

### Font Loading Strategy

```astro
<!-- In Base.astro or layout -->
<head>
  <!-- Preload critical fonts -->
  <link
    rel="preload"
    href="/fonts/editorial-new-bold.woff2"
    as="font"
    type="font/woff2"
    crossorigin
  />
  <link
    rel="preload"
    href="/fonts/sohne-regular.woff2"
    as="font"
    type="font/woff2"
    crossorigin
  />

  <!-- Font face declarations with font-display: swap -->
  <style>
    @font-face {
      font-family: 'Editorial New';
      src: url('/fonts/editorial-new-bold.woff2') format('woff2');
      font-weight: 600;
      font-display: swap;
      font-stretch: 100%;
    }

    @font-face {
      font-family: 'Söhne';
      src: url('/fonts/sohne-regular.woff2') format('woff2');
      font-weight: 400;
      font-display: swap;
    }

    @font-face {
      font-family: 'Söhne';
      src: url('/fonts/sohne-bold.woff2') format('woff2');
      font-weight: 600;
      font-display: swap;
    }
  </style>
</head>
```

### Performance Targets

- **FCP (First Contentful Paint):** < 1.0s
- **LCP (Largest Contentful Paint):** < 2.5s
- **CLS (Cumulative Layout Shift):** < 0.1
- **Bundle size:** < 20kb JavaScript
- **CSS size:** < 50kb (minified, compressed)

### Build & Deploy

```bash
# Build for production
bun run build

# Output is in dist/
# Deploy to Vercel, Netlify, or any static host

# Lighthouse test
bun run preview
# Open http://localhost:3000 in Chrome DevTools
```

---

## Tier 2: Astro + GSAP + Lenis

For sophisticated motion, scroll interactions, and text animation. GSAP handles complex sequencing.

### Setup

```bash
# Start with Astro base
bunx create-astro@latest --template=minimal

# Add animation libraries
bun add gsap lenis split-type
```

### Critical Pattern: Lenis + ScrollTrigger Sync

This is the most important pattern for Tier 2. Incorrect implementation causes janky animations.

```javascript
// src/scripts/scroll-setup.ts
import Lenis from 'lenis';
import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function initializeLenisSync() {
  // Create Lenis instance
  const lenis = new Lenis({
    duration: 1.2,
    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)), // easeOutExpo
    smoothWheel: true,
    smoothTouch: false,
    gestureOrientation: 'vertical',
    syncTouch: false
  });

  // CRITICAL: Connect Lenis to GSAP's internal clock
  // This ensures ScrollTrigger reads Lenis scroll, not native
  gsap.ticker.add((time) => {
    lenis.raf(time * 1000); // Convert seconds to milliseconds
  });

  // CRITICAL: Disable lag smoothing
  // Without this, scrolled animations feel delayed/janky
  gsap.ticker.lagSmoothing(0);

  // Sync ScrollTrigger when Lenis scrolls
  lenis.on('scroll', ScrollTrigger.update);

  return lenis;
}
```

### View Transitions Integration (Astro)

Astro's View Transitions allow animations between page navigations:

```typescript
// src/scripts/page-transitions.ts
import gsap from 'gsap';

export function setupViewTransitions() {
  // Animate out on page navigation
  document.addEventListener('astro:before-swap', (e) => {
    const tl = gsap.timeline();
    tl.to(document.documentElement, {
      opacity: 0,
      duration: 0.3,
      ease: 'power2.in'
    });

    // Return promise to signal completion
    return new Promise((resolve) => {
      tl.add(resolve);
    });
  });

  // Animate in on page load
  document.addEventListener('astro:after-swap', () => {
    const tl = gsap.timeline();
    tl.from(document.documentElement, {
      opacity: 0,
      duration: 0.3,
      ease: 'power2.out'
    });
  });
}
```

### GSAP Context API for Cleanup

Always wrap animations in `gsap.context()` to prevent animation conflicts on page transitions:

```javascript
import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function animateHeroSection(selector: string) {
  const container = document.querySelector(selector);
  if (!container) return;

  // Create context for this component
  const ctx = gsap.context(() => {
    // All animations created here are scoped to this context

    // Scroll-triggered animation
    gsap.to('.hero-content', {
      scrollTrigger: {
        trigger: '.hero',
        start: 'top top',
        end: 'bottom center',
        scrub: 1,
        pin: true
      },
      opacity: 0.5,
      y: -100,
      duration: 1
    });

    // Text animation with SplitType
    const split = new SplitType('.hero h1', { types: 'words,chars' });

    // Apply descender safety
    split.lines?.forEach((line) => {
      line.style.paddingBottom = '0.18em';
      line.style.overflow = 'visible'; // NOT clip — clip ignores padding
    });

    gsap.from(split.chars, {
      scrollTrigger: {
        trigger: '.hero',
        start: 'top 80%'
      },
      opacity: 0.3,
      y: 20,
      stagger: 0.05,
      duration: 0.6,
      ease: 'back.out'
    });
  }, container);

  // Return cleanup function
  return () => {
    ctx.revert(); // Kills all animations in this context
    ScrollTrigger.getAll().forEach((trigger) => {
      if (trigger.vars.trigger === container) {
        trigger.kill();
      }
    });
  };
}
```

### Astro Component with GSAP + Cleanup

```astro
---
// src/components/ScrollSection.astro
import { animateHeroSection } from '../scripts/animations.ts';

const { title, description } = Astro.props;
---

<section class="hero" id="hero-section">
  <h1>{title}</h1>
  <p class="lead">{description}</p>
  <div class="hero-content">
    <!-- content -->
  </div>
</section>

<script define:vars={{ title, description }}>
  // This runs client-side only
  import { animateHeroSection } from '../scripts/animations.ts';

  // Initialize animation
  const cleanup = animateHeroSection('#hero-section');

  // Cleanup on page navigation (Astro View Transitions)
  document.addEventListener('astro:before-swap', () => {
    cleanup();
  });
</script>

<style>
  .hero {
    position: relative;
    min-height: 100dvh; /* dvh accounts for mobile address bar resize */
    display: flex;
    flex-direction: column;
    justify-content: center;
    padding: 120px 40px;
  }

  h1 {
    font-size: clamp(3rem, 10vw, 6rem);
    line-height: 1.05;
    margin-bottom: 1rem;
  }

  .lead {
    font-size: clamp(1.25rem, 3vw, 1.5rem);
    line-height: 1.4;
    max-width: 600px;
    color: #666;
  }
</style>
```

### Bundle Analysis & Optimization

```bash
# Check bundle size
bun run build

# Analyze (if using Vite)
bun add -D @vitejs/plugin-visualizer
```

```javascript
// astro.config.mjs
import visualizer from 'rollup-plugin-visualizer';

export default defineConfig({
  vite: {
    plugins: [
      visualizer({
        open: true,
        filename: 'dist/stats.html'
      })
    ]
  }
});
```

**Target bundle breakdown:**
- gsap: ~32kb gzipped (check bundlephobia for current size)
- lenis: ~8kb gzipped
- split-type: ~8kb gzipped
- Custom code: keep lean
- **Goal: < 120kb total JS** — run `bun run build` and check the output before shipping

### Performance Targets

- **FCP:** < 1.2s
- **LCP:** < 2.5s
- **CLS:** < 0.1
- **INP:** < 200ms
- **Bundle JS:** < 120kb (gzipped)

### Deploy with View Transitions Support

View Transitions require specific headers. Configure your hosting:

```json
// vercel.json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "Accept-CH",
          "value": "Viewport-Width, DPR"
        }
      ]
    }
  ]
}
```

---

## Tier 3: TanStack Start OR Astro + R3F

For cutting-edge experiences: 3D, generative, or highly interactive applications.

### Option A: TanStack Start + Three.js

Use TanStack Start when you need a full app framework with real-time interactions.

```bash
# Initialize TanStack Start
bun create @tanstack/start@latest my-app
cd my-app

# Add 3D libraries
bun add three @react-three/fiber @react-three/drei
bun add glsl-shader-loader
```

### Option B: Astro + R3F (Recommended for Content + 3D)

Mix content-driven Astro with React Three Fiber islands for 3D sections.

```bash
# Start with Astro
bunx create-astro@latest

# Add React and Three.js
bun add react @react-three/fiber @react-three/drei three
```

```astro
---
// src/components/ThreeScene.astro
import ThreeViewer from './ThreeViewer.jsx';
---

<div id="three-root" class="full-bleed">
  <ThreeViewer client:visible />
</div>

<style>
  #three-root {
    width: 100%;
    height: 100dvh; /* dvh accounts for mobile address bar resize */
  }
</style>
```

```jsx
// src/components/ThreeViewer.jsx
import { Suspense } from 'react';
import { Canvas } from '@react-three/fiber';
import { Mesh } from './Mesh';

export default function ThreeViewer() {
  return (
    <Canvas
      camera={{ position: [0, 0, 8], fov: 50 }}
      gl={{ antialias: true, alpha: true }}
    >
      <Suspense fallback={null}>
        <Mesh />
      </Suspense>
    </Canvas>
  );
}
```

### Custom GLSL Shader Setup

```glsl
// shaders/fragment.glsl
uniform float uTime;
uniform vec2 uMouse;
uniform sampler2D uTexture;

varying vec2 vUv;

void main() {
  vec2 uv = vUv;

  // Distortion based on time and mouse
  float distortion = sin(uv.y + uTime) * 0.1;
  distortion += sin((uMouse.x - uv.x) * 5.0) * 0.05;

  uv.x += distortion;

  vec4 color = texture2D(uTexture, uv);

  gl_FragColor = color;
}
```

```jsx
// src/components/ShaderMaterial.jsx
import * as THREE from 'three';
import { useShader } from '@react-three/fiber';

export function CustomMesh() {
  const [shader, setShader] = useShader();

  return (
    <mesh>
      <bufferGeometry />
      <shaderMaterial
        uniforms={{
          uTime: { value: 0 },
          uMouse: { value: new THREE.Vector2(0, 0) },
          uTexture: { value: new THREE.Texture() }
        }}
        vertexShader={vertexShader}
        fragmentShader={fragmentShader}
      />
    </mesh>
  );
}
```

### Theatre.js for Cinematic Control

```javascript
// src/scripts/theatre-setup.ts
import Theatre from '@theatre/core';

export function createCinematicTimeline() {
  const project = Theatre.getProject('Project');
  const sheet = project.sheet('Cinematic');

  const cameraObj = sheet.object('Camera', {
    position: { x: 0, y: 0, z: 10 },
    rotation: { x: 0, y: 0, z: 0 }
  });

  const materialObj = sheet.object('Material', {
    opacity: 1,
    roughness: 0.5
  });

  // Create editable timeline in UI
  const sequence = sheet.sequence;

  return {
    cameraObj,
    materialObj,
    sequence
  };
}
```

### FBO Particles Pattern

```glsl
// Particle simulation shader
#version 300 es
precision highp float;

uniform sampler2D positions;
uniform sampler2D velocities;
uniform float deltaTime;

void main() {
  vec2 uv = gl_FragCoord.xy / resolution.xy;

  vec4 pos = texture(positions, uv);
  vec4 vel = texture(velocities, uv);

  // Apply physics
  vel.y -= 0.98 * deltaTime; // gravity
  pos.xyz += vel.xyz * deltaTime;

  // Bounce off boundaries
  if (pos.y < -10.0) {
    pos.y = 10.0;
    vel.y *= -0.8;
  }

  gl_FragColor = pos;
}
```

### Performance Targets

- **FCP:** < 1.5s (higher due to shader compilation)
- **LCP:** < 3.0s
- **CLS:** < 0.1
- **Bundle JS:** < 300kb (code split aggressive)
- **GPU:** WebGL 2.0 or higher

### Deployment Considerations

Tier 3 sites must still work on mobile — Awwwards judges test on phones. Provide graceful fallbacks for GPU-intensive effects:

- Test on lower-end GPUs (iPad Air, mid-range Android)
- Provide fallback for devices without WebGL 2.0 (static gradient, CSS animation)
- Reduce particle count and shader complexity on mobile via `matchMedia('(pointer: coarse)')`
- Use feature detection:

```javascript
function supportsWebGL2() {
  try {
    const canvas = document.createElement('canvas');
    return !!canvas.getContext('webgl2');
  } catch {
    return false;
  }
}

if (!supportsWebGL2()) {
  // Show static fallback
}
```

---

## Core Web Vitals Optimization (All Tiers)

### FCP (First Contentful Paint) < 1.5s

**Critical:** Inline critical CSS, defer non-critical CSS

```astro
<head>
  <!-- Inline critical CSS for above-fold -->
  <style>
    /* Hero section, typography base styles */
  </style>

  <!-- Defer non-critical CSS -->
  <link rel="preload" href="/styles/components.css" as="style">
  <link rel="stylesheet" href="/styles/components.css" media="print" onload="this.media='all'">
</head>
```

### LCP (Largest Contentful Paint) < 2.5-3.0s

**Critical:** Image optimization, preload hero image

```html
<!-- Preload largest image -->
<link
  rel="preload"
  as="image"
  href="/images/hero.jpg"
  imagesrcset="/images/hero-1920.jpg 1920w, /images/hero-1280.jpg 1280w"
  imagesizes="100vw"
/>

<!-- Responsive image with AVIF/WebP -->
<picture>
  <source srcset="/images/hero.avif" type="image/avif" />
  <source srcset="/images/hero.webp" type="image/webp" />
  <img
    src="/images/hero.jpg"
    alt="Hero"
    fetchpriority="high"
    width="1920"
    height="1080"
  />
</picture>
```

### CLS (Cumulative Layout Shift) < 0.1

**Critical:** Reserve space for images, dynamic content

```css
/* Reserve aspect ratio -->
img {
  aspect-ratio: 16 / 9;
}

/* Or use container queries -->
@container (min-width: 400px) {
  .card {
    height: 300px;
  }
}
```

### INP (Interaction to Next Paint) < 200ms

**Critical:** Debounce scroll/resize, use requestAnimationFrame

```javascript
// Good: Batches updates
function handleScroll() {
  requestAnimationFrame(() => {
    // Update DOM here
  });
}

// Bad: Causes jank
document.addEventListener('scroll', () => {
  document.body.style.background = newColor; // Synchronous reflow
});
```

---

## Font Loading Strategy (All Tiers)

```css
@font-face {
  font-family: 'Premium Font';
  src: url('/fonts/premium-bold.woff2') format('woff2');
  font-weight: 600;
  font-display: swap;  /* Show fallback immediately */
  font-stretch: 100%;
}
```

**font-display options:**
- `swap` — Fast: Show fallback, swap when custom font loads
- `optional` — Safest: Only use custom font if already cached
- `block` — Slowest: Hide text until custom font loads (avoid)

---

## Lighthouse Optimization Checklist (All Tiers)

- [ ] FCP < target (by tier)
- [ ] LCP < target (by tier)
- [ ] CLS < 0.1 (all tiers)
- [ ] INP < 200ms (all tiers)
- [ ] Accessibility score > 90
- [ ] Best practices score > 90
- [ ] SEO score > 90
- [ ] No unused JavaScript
- [ ] No unused CSS
- [ ] Images optimized (AVIF/WebP)
- [ ] Fonts subset/preloaded
- [ ] Third-party scripts deferred
- [ ] Critical resources preloaded

**Run audit:**
```bash
# Chrome DevTools → Lighthouse
# Or CI/CD integration
bun add -D @lighthouse-ci/cli
```

---

## Monitoring & Analytics (Production)

```javascript
// Web Vitals monitoring
import { getCLS, getFCP, getFID, getLCP, getTTFB } from 'web-vitals';

getCLS(console.log);
getFCP(console.log);
getFID(console.log);
getLCP(console.log);
getTTFB(console.log);

// Send to analytics
function sendToAnalytics(metric) {
  navigator.sendBeacon('/api/metrics', JSON.stringify(metric));
}
```

---

## Summary: Tier Decision Matrix

| Metric | Tier 1 | Tier 2 | Tier 3 |
|--------|--------|--------|--------|
| Framework | Astro (latest) | Astro + GSAP + Lenis | TanStack Start / Astro + R3F |
| FCP target | < 1.0s | < 1.2s | < 1.5s |
| LCP target | < 2.5s | < 2.5s | < 3.0s |
| JS goal | minimal | < 120kb | < 300kb |
| Setup time | 2 hours | 4 hours | 8+ hours |
| Performance impact | Minimal | Medium | High (GPU-bound) |
| Complexity | Low | Medium | High |

Choose based on brand ambition, timeline, and technical confidence. Build from the tier up—don't try Tier 3 if you're unsure.
