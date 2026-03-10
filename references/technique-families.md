# The 5 Technique Families: Tier-Based Implementation Patterns

> **Invariant principle:** Every signature interaction lives within a paradigm — Cursor, Scroll, Loading, Hover, Typography, or Layout. The paradigm is the medium; the signature interaction is the message. Choose one paradigm and invent within it.
>
> **Current-era note:** The code examples, library choices, and tier implementations in this file reflect current best practice. If you know of superior techniques for achieving the same effects, use them — honor the paradigm and the brand-to-interaction mapping, not the specific library. The classification of what's Tier 1 vs. Tier 2 vs. Tier 3 may shift as technology evolves.

Each technique family is a paradigm (Cursor, Scroll, Loading, Hover, Typography) with three tiers of increasing complexity. Within each family, choose your tier based on project scope and technical confidence.

---

## Family 1: Cursor

The pointer itself becomes expressive. How the cursor moves, trails, responds to proximity, distorts, or changes based on context.

**Brand gate — answer before implementing any custom cursor:**
1. Can you write one sentence explaining why cursor behaviour is intrinsic to this brand's metaphor — not just "it looks good"?
2. Is the cursor doing something the native cursor cannot, in a way that advances the brand story?
3. If the cursor were removed, would the brand experience feel incomplete?

If you cannot answer YES to all three, use the native cursor. Most premium sites do — restraint is not a failure of craft.

### Tier 1: CSS Cursor Tracking with Variables & Calc

Custom cursor using CSS custom properties updated by JavaScript, no GSAP.

```html
<style>
  :root {
    --cursor-x: 0px;
    --cursor-y: 0px;
  }

  .custom-cursor {
    width: 24px;
    height: 24px;
    border: 2px solid #000;
    border-radius: 50%;
    position: fixed;
    top: calc(var(--cursor-y) - 12px);
    left: calc(var(--cursor-x) - 12px);
    pointer-events: none;
    z-index: 9999;
    cursor: none;
    mix-blend-mode: multiply;
  }

  .interactive:hover ~ .custom-cursor {
    --cursor-scale: 1.5;
  }
</style>

<div class="custom-cursor"></div>
<script>
  document.addEventListener('mousemove', (e) => {
    document.documentElement.style.setProperty('--cursor-x', e.clientX + 'px');
    document.documentElement.style.setProperty('--cursor-y', e.clientY + 'px');
  });

  // Detect interactive elements
  document.querySelectorAll('a, button, [role="button"]').forEach(el => {
    el.addEventListener('mouseenter', () => {
      document.querySelector('.custom-cursor').style.background = '#000';
      document.querySelector('.custom-cursor').style.transform = 'scale(1.5)';
    });
    el.addEventListener('mouseleave', () => {
      document.querySelector('.custom-cursor').style.background = 'transparent';
      document.querySelector('.custom-cursor').style.transform = 'scale(1)';
    });
  });
</script>
```

**When descender safety applies:** Not applicable (cursor is custom element, not text).

**Performance:** < 1kb JavaScript. Runs every mousemove. If you need sub-16ms performance, use CSS animation instead:

```css
@supports (animation-timeline: scroll()) {
  /* CSS-driven cursor for ultimate performance */
  .custom-cursor {
    animation: follow-cursor linear;
    animation-timeline: auto; /* Updates via JS variables */
  }
}
```

**Best for:** Subtle elegance, minimal interactivity, performance-critical sites.

---

### Tier 2: Dual-Element Cursor with GSAP & Magnetic Fields

Main cursor with fast response (0.2s), follower cursor with slow response (0.6s). Magnetic pull toward interactive elements.

```javascript
import gsap from 'gsap';

class DualCursor {
  constructor() {
    this.cursor = document.createElement('div');
    this.follower = document.createElement('div');

    // Main cursor (fast)
    this.cursor.className = 'cursor';
    this.cursor.innerHTML = '<div class="cursor-inner"></div>';

    // Follower (slow)
    this.follower.className = 'cursor-follower';

    document.body.appendChild(this.cursor);
    document.body.appendChild(this.follower);

    this.cursorX = 0;
    this.cursorY = 0;
    this.followerX = 0;
    this.followerY = 0;

    this.init();
  }

  init() {
    // Hide default cursor
    document.documentElement.style.cursor = 'none';

    document.addEventListener('mousemove', (e) => {
      this.cursorX = e.clientX;
      this.cursorY = e.clientY;

      // Update main cursor (no animation, instant)
      gsap.to(this.cursor, {
        x: this.cursorX - 12,
        y: this.cursorY - 12,
        duration: 0,
        overwrite: 'auto'
      });

      // Update follower with lag (0.6s)
      gsap.to(this.follower, {
        x: this.cursorX - 20,
        y: this.cursorY - 20,
        duration: 0.6,
        ease: 'power3.out',
        overwrite: 'auto'
      });

      // Check for interactive elements at cursor position
      this.checkMagneticZones();
    });

    // Interactive element hover
    this.attachInteractiveListeners();
  }

  checkMagneticZones() {
    // Get interactive element under cursor
    const element = document.elementFromPoint(this.cursorX, this.cursorY);
    const interactive = element?.closest('a, button, [role="button"], .interactive');

    if (interactive) {
      const rect = interactive.getBoundingClientRect();
      const centerX = rect.left + rect.width / 2;
      const centerY = rect.top + rect.height / 2;

      // Magnetic pull: cursor moves toward element center
      const distance = Math.hypot(
        this.cursorX - centerX,
        this.cursorY - centerY
      );

      // Only pull if within magnetic radius (100px)
      if (distance < 100) {
        const pull = 1 - (distance / 100); // 0 to 1
        const magneticX = this.cursorX + (centerX - this.cursorX) * pull * 0.3;
        const magneticY = this.cursorY + (centerY - this.cursorY) * pull * 0.3;

        gsap.to(this.cursor, {
          x: magneticX - 12,
          y: magneticY - 12,
          duration: 0.3,
          overwrite: 'auto'
        });
      }

      this.cursor.classList.add('active');
      this.follower.classList.add('active');
    } else {
      this.cursor.classList.remove('active');
      this.follower.classList.remove('active');
    }
  }

  attachInteractiveListeners() {
    document.querySelectorAll('a, button, [role="button"]').forEach(el => {
      el.addEventListener('mouseenter', () => {
        this.cursor.classList.add('hover');
        this.follower.classList.add('hover');
      });

      el.addEventListener('mouseleave', () => {
        this.cursor.classList.remove('hover');
        this.follower.classList.remove('hover');
      });
    });
  }
}

// Initialize
new DualCursor();
```

```css
.cursor {
  position: fixed;
  width: 24px;
  height: 24px;
  pointer-events: none;
  z-index: 9999;
  mix-blend-mode: multiply;
}

.cursor-inner {
  width: 100%;
  height: 100%;
  border: 2px solid currentColor;
  border-radius: 50%;
  color: #000;
  transition: transform 0.2s ease, opacity 0.2s ease;
}

.cursor.active .cursor-inner {
  background: rgba(0, 0, 0, 0.1);
  transform: scale(1.5);
}

.cursor.hover .cursor-inner {
  color: #FF6B35;
  border-width: 3px;
  transform: scale(2);
}

.cursor-follower {
  position: fixed;
  width: 40px;
  height: 40px;
  border: 1px solid rgba(0, 0, 0, 0.2);
  border-radius: 50%;
  pointer-events: none;
  z-index: 9998;
  mix-blend-mode: screen;
}

.cursor-follower.active {
  border-color: rgba(0, 0, 0, 0.4);
}

.cursor-follower.hover {
  border-color: rgba(255, 107, 53, 0.6);
}
```

**When descender safety applies:** Not applicable (cursor is custom element).

**Performance:** ~3kb JavaScript. Consider `gsap.ticker.lagSmoothing(0)` if used with other scroll animations to prevent timing conflicts.

**Best for:** Interactive experiences, gallery sites, playful brands.

---

### Tier 3: WebGL Distortion Field with Cursor as Shader Uniform

Cursor position feeds into GLSL shader that distorts everything around it.

```glsl
// vertex.glsl
varying vec2 vUv;

void main() {
  vUv = uv;
  gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
}

// fragment.glsl
uniform vec2 uCursorPos;      // Normalized cursor position (0-1)
uniform float uCursorRadius;  // Influence radius
uniform sampler2D uTexture;

varying vec2 vUv;

void main() {
  vec2 cursorDist = vUv - uCursorPos;
  float dist = length(cursorDist);

  // Distortion factor decreases with distance
  float influence = smoothstep(uCursorRadius, 0.0, dist);

  // Displace UVs toward/away from cursor
  vec2 displaced = vUv + cursorDist * influence * 0.1;

  // Sample texture with displacement
  vec4 color = texture2D(uTexture, displaced);

  // Optional: add color shift near cursor
  color.rgb += vec3(1.0, 0.4, 0.2) * influence * 0.3;

  gl_FragColor = color;
}
```

```javascript
import * as THREE from 'three';

class CursorDistortionField {
  constructor(canvas) {
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(
      75,
      canvas.clientWidth / canvas.clientHeight,
      0.1,
      1000
    );
    this.renderer = new THREE.WebGLRenderer({ canvas });
    this.renderer.setSize(canvas.clientWidth, canvas.clientHeight);
    this.camera.position.z = 5;

    this.cursorX = 0;
    this.cursorY = 0;

    // Create plane with distortion material
    const geometry = new THREE.PlaneGeometry(10, 10);
    const material = new THREE.ShaderMaterial({
      vertexShader: vertexShaderCode,
      fragmentShader: fragmentShaderCode,
      uniforms: {
        uCursorPos: { value: new THREE.Vector2(0.5, 0.5) },
        uCursorRadius: { value: 0.2 },
        uTexture: { value: textureLoader.load('image.jpg') }
      }
    });

    this.mesh = new THREE.Mesh(geometry, material);
    this.scene.add(this.mesh);

    this.attachListeners();
    this.animate();
  }

  attachListeners() {
    document.addEventListener('mousemove', (e) => {
      // Normalize to 0-1 range
      this.cursorX = e.clientX / window.innerWidth;
      this.cursorY = 1.0 - (e.clientY / window.innerHeight); // Flip Y

      // Update shader uniform
      this.mesh.material.uniforms.uCursorPos.value.set(
        this.cursorX,
        this.cursorY
      );
    });
  }

  animate() {
    requestAnimationFrame(() => this.animate());
    this.renderer.render(this.scene, this.camera);
  }
}

// Initialize
const canvas = document.querySelector('canvas');
new CursorDistortionField(canvas);
```

**When descender safety applies:** Not applicable (WebGL scene, no DOM text).

**Performance:** ~50-100kb JavaScript (Three.js). CPU impact minimal if shader is optimized. GPU bound.

**Best for:** Tech companies, VFX-heavy experiences, cutting-edge signal.

---

## Family 2: Scroll

Content movement through time becomes the signature moment. How sections reveal, parallax, pin, animate.

### Tier 1: CSS Scroll-Driven Animations with Animation-Timeline

Pure CSS, no JavaScript animation library needed.

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    @supports (animation-timeline: scroll()) {
      /* Scroll-driven section reveals */
      .section {
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

      /* Sticky scroll parallax */
      .parallax-bg {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        background-attachment: fixed;
        animation: bgScroll linear;
        animation-timeline: scroll();
      }

      @keyframes bgScroll {
        0% {
          background-position: 0 0;
        }
        100% {
          background-position: 0 100px;
        }
      }

      /* Text opacity on scroll */
      .scroll-text {
        animation: textAppear linear;
        animation-timeline: scroll();
        animation-range: 0 1000px;
      }

      @keyframes textAppear {
        0% {
          opacity: 0.3;
        }
        100% {
          opacity: 1;
        }
      }

      /* Rotate element based on scroll */
      .scroll-rotate {
        animation: spinOnScroll linear;
        animation-timeline: scroll();
      }

      @keyframes spinOnScroll {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }
    }

    /* Fallback for non-supporting browsers */
    @supports not (animation-timeline: scroll()) {
      .section {
        opacity: 1;
        transform: translateY(0);
      }
    }
  </style>
</head>
<body>
  <section class="section">
    <h1>Scroll-Driven Section</h1>
  </section>

  <div class="parallax-bg">
    <div class="scroll-text">Text responds to scroll</div>
  </div>

  <div class="scroll-rotate">
    <img src="logo.svg" alt="Logo" />
  </div>
</body>
</html>
```

**Browser support:** Chrome 115+, Safari 17.2+, Edge 115+. Fallback to static for older browsers.

**When descender safety applies:** If animating text, ensure padding-bottom is applied to text elements before animation.

**Performance:** Native browser implementation. 60fps guaranteed if animation is GPU-accelerated (transform, opacity).

**Best for:** Performance-first sites, simple scroll narratives, mobile.

---

### Tier 2: Lenis + GSAP ScrollTrigger Sync Pattern

Smooth scroll library (Lenis) + GSAP ScrollTrigger for sophisticated orchestration.

```typescript
import Lenis from 'lenis';
import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

// Initialize Lenis
const lenis = new Lenis({
  duration: 1.2,                    // Scroll duration (seconds)
  easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)), // easeOutExpo
  smoothWheel: true,
  smoothTouch: false,
  gestureOrientation: 'vertical',
  syncTouch: false
});

// CRITICAL: Connect Lenis to GSAP ticker
// This ensures ScrollTrigger reads Lenis scroll position, not native
gsap.ticker.add((time) => {
  lenis.raf(time * 1000); // Convert seconds to milliseconds
});

// CRITICAL: Disable GSAP lag smoothing
// Without this, scroll animations will feel delayed/janky
gsap.ticker.lagSmoothing(0);

// Example: Scroll-pinned section
gsap.timeline()
  .to('.hero', {
    scrollTrigger: {
      trigger: '.hero',
      start: 'top top',
      end: 'bottom center',
      scrub: 1,              // 1 = 1 second scrub delay (smooth)
      pin: true,
      markers: false         // Set true for debugging
    },
    scale: 0.9,
    opacity: 0.8,
    duration: 1
  });

// Example: Staggered section reveals
const tl = gsap.timeline();
gsap.utils.toArray('.card').forEach((card, i) => {
  tl.to(
    card,
    {
      opacity: 1,
      y: 0,
      duration: 0.8,
      ease: 'power3.out'
    },
    i * 0.2  // Stagger by 200ms
  );
});

ScrollTrigger.create({
  trigger: '.cards-container',
  start: 'top center',
  onEnter: () => tl.play()
});

// Example: Text animation with SplitType + Descender Safety
import SplitType from 'split-type';

function animateHeadline(selector) {
  const element = document.querySelector(selector);
  const split = new SplitType(selector, { types: 'words,chars' });

  // Apply descender safety
  const clearance = '0.18em'; // Adjust per font
  split.lines?.forEach(line => {
    line.style.paddingBottom = clearance;
    line.style.overflow = 'visible'; // NOT 'clip' — clip ignores padding
  });

  gsap.from(split.chars, {
    scrollTrigger: {
      trigger: selector,
      start: 'top 80%',
      end: 'top 20%',
      scrub: 1
    },
    opacity: 0.5,
    y: 20,
    stagger: 0.05,
    duration: 0.6,
    ease: 'back.out'
  });
}

animateHeadline('.section-headline');

// Cleanup on page navigation
if (window.gsap?.context) {
  const ctx = gsap.context(() => {
    // All animations here
  });

  // On page unload/navigate
  return () => {
    ctx.revert();
    ScrollTrigger.getAll().forEach(trigger => trigger.kill());
    lenis.destroy();
  };
}
```

**Critical setup notes:**
- `gsap.ticker.add()` connects Lenis to GSAP's internal ticker
- `gsap.ticker.lagSmoothing(0)` prevents scroll delay artifacts
- Always use Astro's `view:visible` for client:visible islands with Lenis
- Wrap animations in `gsap.context()` for cleanup

**Bundle size:** ~40kb (Lenis + GSAP + ScrollTrigger)

**When descender safety applies:** If animating text with SplitType, add padding-bottom to every line wrapper (shown in example).

**Performance:** 60fps on most devices. Test on mid-range mobile.

**Best for:** Premium experiences, narrative-driven sites, sophisticated scroll interactions.

---

### Tier 3: Scroll-Velocity Shaders

Scroll velocity drives GLSL uniform, affecting shader calculations in real-time.

```glsl
// fragment.glsl
uniform float uScrollVelocity;  // 0 to 1, normalized
uniform sampler2D uTexture;
varying vec2 vUv;

void main() {
  // Distort UV based on scroll velocity
  vec2 distorted = vUv;
  distorted.x += sin(vUv.y + uScrollVelocity) * 0.1 * uScrollVelocity;
  distorted.y += cos(vUv.x + uScrollVelocity) * 0.15 * uScrollVelocity;

  vec4 color = texture2D(uTexture, distorted);

  // Color shift intensity increases with velocity
  vec3 velocity_color = mix(
    vec3(1.0, 0.5, 0.2),  // warm
    vec3(0.2, 0.5, 1.0),  // cool
    uScrollVelocity
  );

  color.rgb = mix(color.rgb, velocity_color, uScrollVelocity * 0.3);

  gl_FragColor = color;
}
```

```javascript
import * as THREE from 'three';

class ScrollVelocityShader {
  constructor(canvas, options = {}) {
    this.scrollVelocity = 0;
    this.lastScrollPos = 0;
    this.maxVelocity = options.maxVelocity || 50;

    // Three.js setup
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(75, canvas.clientWidth / canvas.clientHeight, 0.1, 1000);
    this.renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
    this.renderer.setSize(canvas.clientWidth, canvas.clientHeight);
    this.camera.position.z = 5;

    // Material with scroll velocity uniform
    this.material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      uniforms: {
        uScrollVelocity: { value: 0.0 },
        uTexture: { value: new THREE.TextureLoader().load('image.jpg') }
      }
    });

    const geometry = new THREE.PlaneGeometry(10, 10);
    this.mesh = new THREE.Mesh(geometry, this.material);
    this.scene.add(this.mesh);

    this.attachListeners();
    this.animate();
  }

  attachListeners() {
    window.addEventListener('scroll', () => {
      // Calculate velocity from scroll delta
      const currentScroll = window.scrollY;
      const delta = currentScroll - this.lastScrollPos;

      // Normalize velocity (0 to 1)
      this.scrollVelocity = Math.min(
        Math.abs(delta) / this.maxVelocity,
        1.0
      );

      // Smoothly decay velocity when not scrolling
      if (delta === 0) {
        this.scrollVelocity *= 0.95;
      }

      this.lastScrollPos = currentScroll;
    });
  }

  animate() {
    requestAnimationFrame(() => this.animate());

    // Update shader uniform every frame
    this.material.uniforms.uScrollVelocity.value = this.scrollVelocity;

    this.renderer.render(this.scene, this.camera);
  }
}

const canvas = document.querySelector('canvas');
new ScrollVelocityShader(canvas, { maxVelocity: 50 });
```

**When descender safety applies:** Not applicable (WebGL scene).

**Performance:** GPU-bound. Requires WebGL 2.0.

**Best for:** Cutting-edge experiences, tech companies, VFX-heavy narratives.

---

## Family 3: Loading/Reveal

The first moment the user encounters the site (loading sequence, hero reveal) is the signature moment.

### Tier 1: CSS @starting-style + View Transitions

Native CSS for entrance animations without JavaScript.

```html
<!DOCTYPE html>
<html>
<head>
  <style>
    @view-transition {
      navigation: auto;
    }

    ::view-transition-old(root) {
      animation: fadeOut 0.3s ease-out forwards;
    }

    ::view-transition-new(root) {
      animation: fadeIn 0.3s ease-in forwards;
    }

    @keyframes fadeOut {
      to { opacity: 0; }
    }

    @keyframes fadeIn {
      from { opacity: 0; }
    }

    /* Initial state (before render) */
    .hero {
      @starting-style {
        opacity: 0;
        transform: translateY(40px);
      }
      opacity: 1;
      transform: translateY(0);
      transition: opacity 0.8s cubic-bezier(0.34, 1.56, 0.64, 1),
                  transform 0.8s cubic-bezier(0.34, 1.56, 0.64, 1);
    }

    .hero-content {
      @starting-style {
        clip-path: polygon(0 0, 100% 0, 100% 0, 0 0);
      }
      clip-path: polygon(0 0, 100% 0, 100% 100%, 0 100%);
      transition: clip-path 1.2s ease;
    }

    /* Staggered children */
    .hero h1,
    .hero p {
      @starting-style {
        opacity: 0;
      }
      opacity: 1;
      transition: opacity 0.8s ease;
      transition-delay: calc(var(--child-index, 0) * 0.15s);
    }
  </style>
</head>
<body>
  <div class="hero">
    <div class="hero-content">
      <h1 style="--child-index: 1;">Welcome</h1>
      <p style="--child-index: 2;">Explore our work</p>
    </div>
  </div>
</body>
</html>
```

**Browser support:** Chrome 119+, Safari 18+. Fallback to instant display for older browsers.

**When descender safety applies:** Hero h1 should have padding-bottom and overflow: visible (never clip).

**Performance:** 60fps. Native implementation.

**Best for:** Simple, elegant reveals. First-time visitors.

---

### Tier 2: SplitType + GSAP with Particle Assembly

Text characters appear one by one as particles assemble.

```javascript
import gsap from 'gsap';
import SplitType from 'split-type';

function heroLoadingSequence() {
  const headline = document.querySelector('.hero h1');
  const subheading = document.querySelector('.hero p');

  // Create timeline for entire sequence
  const tl = gsap.timeline();

  // 1. Fade in backdrop
  tl.to('.hero', { opacity: 1, duration: 0.3 }, 0);

  // 2. Split headline text
  const split = new SplitType('.hero h1', { types: 'chars' });

  // Apply descender safety
  split.lines?.forEach(line => {
    line.style.paddingBottom = '0.18em';
    line.style.overflow = 'visible'; // NOT 'clip' — clip ignores padding
  });

  // 3. Animate characters as particles
  // Characters start scaled down and offset, then animate to normal
  tl.from(
    split.chars,
    {
      opacity: 0,
      scale: 0.5,
      y: 40,
      rotation: -10,
      stagger: {
        amount: 0.6,        // Total stagger duration
        from: 'random'      // Random order (feels more organic)
      },
      duration: 0.8,
      ease: 'back.out'
    },
    0.2  // Start 200ms after backdrop fade
  );

  // 4. Subheading appears
  tl.from(
    subheading,
    {
      opacity: 0,
      y: 20,
      duration: 0.6,
      ease: 'power2.out'
    },
    0.8  // Overlap with character animation ending
  );

  // 5. Call-to-action button
  tl.from(
    '.hero-cta',
    {
      opacity: 0,
      scale: 0.8,
      duration: 0.5,
      ease: 'elastic.out(1, 0.5)'
    },
    '+=0.3'  // 300ms after subheading
  );

  return tl;
}

// Initialize on page load
window.addEventListener('DOMContentLoaded', heroLoadingSequence);
```

**Bundle size:** ~50kb (GSAP + SplitType)

**When descender safety applies:** Critical. Every line from SplitType must have padding-bottom.

**Performance:** 60fps. Consider reduced motion with prefers-reduced-motion query.

**Best for:** Premium landing pages, portfolio intros, storytelling.

---

### Tier 3: Matter.js Particle System with Physics

Particle assembly with gravity, collision, and natural motion.

```javascript
import Matter from 'matter-js';

class ParticleLoadingSequence {
  constructor(canvasElement) {
    this.canvas = canvasElement;
    this.engine = Matter.Engine.create();
    this.world = this.engine.world;
    this.world.gravity.y = 1.5;

    this.renderer = Matter.Renderer.create({
      canvas: this.canvas,
      engine: this.engine,
      options: {
        width: window.innerWidth,
        height: window.innerHeight,
        wireframes: false
      }
    });

    this.bodies = [];
    this.createTextParticles();
    this.animate();
  }

  createTextParticles() {
    // Create particles that spell out text
    const text = 'WELCOME';
    const positions = this.getTextPositions(text);

    positions.forEach((pos, i) => {
      // Stagger particle creation
      setTimeout(() => {
        const body = Matter.Bodies.circle(
          window.innerWidth / 2,
          window.innerHeight / 2,
          8,
          {
            restitution: 0.8,
            friction: 0.5,
            frictionAir: 0.02,
            label: `particle-${i}`
          }
        );

        // Set random velocity for entry
        Matter.Body.setVelocity(body, {
          x: (Math.random() - 0.5) * 20,
          y: (Math.random() - 0.5) * 20
        });

        Matter.World.add(this.world, body);
        this.bodies.push({ body, target: pos, index: i });

        // Render particle text inside circle
        this.renderParticle(body, text[i]);
      }, i * 100);
    });

    // Create floor to catch particles
    const floor = Matter.Bodies.rectangle(
      window.innerWidth / 2,
      window.innerHeight - 50,
      window.innerWidth,
      100,
      { isStatic: true }
    );
    Matter.World.add(this.world, floor);
  }

  getTextPositions(text) {
    // Calculate positions where text should settle
    const spacing = 50;
    const startX = (window.innerWidth - text.length * spacing) / 2;
    return Array.from(text).map((_, i) => ({
      x: startX + i * spacing,
      y: window.innerHeight / 2
    }));
  }

  renderParticle(body, char) {
    // In production, render text inside particle using Canvas or WebGL
    // For now, just visual representation
    const circle = document.createElement('div');
    circle.textContent = char;
    circle.style.cssText = `
      position: fixed;
      width: 20px;
      height: 20px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 12px;
      font-weight: bold;
      color: #000;
    `;
    document.body.appendChild(circle);

    // Update position every frame (handled in animate)
  }

  animate() {
    Matter.Engine.update(this.engine);

    // Apply gravitational pull to target positions
    this.bodies.forEach(({ body, target }) => {
      const distance = Math.hypot(
        body.position.x - target.x,
        body.position.y - target.y
      );

      // Only apply pull once particles are near settlement
      if (distance > 5) {
        const force = {
          x: (target.x - body.position.x) * 0.0005,
          y: (target.y - body.position.y) * 0.0005
        };
        Matter.Body.applyForce(body, body.position, force);
      }
    });

    Matter.Renderer.run(this.renderer);
    requestAnimationFrame(() => this.animate());
  }
}

// Initialize
const canvas = document.querySelector('canvas');
new ParticleLoadingSequence(canvas);
```

**When descender safety applies:** Not applicable (particle system, not DOM text).

**Bundle size:** ~50kb (Matter.js)

**Performance:** GPU-accelerated. May impact performance on low-end devices.

**Best for:** Cutting-edge reveals, tech companies, impressive first impression.

---

## Family 4: Hover

Engagement moments become the signature (what reveals on hover, focus, interaction).

### Tier 1: CSS Hover with Custom Properties & Transitions

```css
/* Basic hover reveal */
.card {
  --scale: 1;
  --color-shift: 0%;
  --shadow-blur: 10px;

  transform: scale(var(--scale));
  box-shadow: 0 10px var(--shadow-blur) rgba(0, 0, 0, 0.1);
  background: hsl(120, var(--color-shift), 50%);

  transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
              box-shadow 0.3s cubic-bezier(0.34, 1.56, 0.64, 1),
              background 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.card:hover {
  --scale: 1.05;
  --color-shift: 30%;
  --shadow-blur: 20px;
}

/* Gradient animation on hover */
.cta-button {
  --gradient-x: 0%;

  background: linear-gradient(
    90deg,
    #667eea var(--gradient-x),
    #764ba2 calc(var(--gradient-x) + 50px)
  );
  background-size: 200% 100%;
  background-position: var(--gradient-x) 0;

  transition: --gradient-x 0.6s ease;
}

.cta-button:hover {
  --gradient-x: 100%;
}

/* Text underline reveal from center */
.link {
  position: relative;
  text-decoration: none;
  color: #000;
}

.link::after {
  content: '';
  position: absolute;
  bottom: -2px;
  left: 50%;
  width: 0;
  height: 2px;
  background: #000;
  transform: translateX(-50%);
  transition: width 0.3s ease;
}

.link:hover::after {
  width: 100%;
}

/* Rotate on hover */
.icon {
  transition: transform 0.3s ease;
}

.icon:hover {
  transform: rotate(180deg);
}
```

**When descender safety applies:** Not applicable (CSS transitions).

**Performance:** 60fps. GPU-accelerated (transform, opacity).

**Browser support:** All modern browsers.

**Best for:** Simple elegance, minimal overhead.

---

### Tier 2: GSAP FLIP with Magnetic Pull

Layout transitions and magnetic button behavior.

```javascript
import gsap from 'gsap';

class MagneticButton {
  constructor(button) {
    this.button = button;
    this.inner = button.querySelector('.button-inner');
    this.isDragging = false;

    this.init();
  }

  init() {
    this.button.addEventListener('mouseenter', (e) => {
      this.onMouseEnter(e);
    });

    this.button.addEventListener('mousemove', (e) => {
      this.onMouseMove(e);
    });

    this.button.addEventListener('mouseleave', (e) => {
      this.onMouseLeave(e);
    });

    this.button.addEventListener('mousedown', () => {
      this.isDragging = true;
      gsap.to(this.inner, {
        scale: 0.95,
        duration: 0.2
      });
    });

    document.addEventListener('mouseup', () => {
      this.isDragging = false;
      gsap.to(this.inner, {
        scale: 1,
        duration: 0.3,
        ease: 'elastic.out(1, 0.5)'
      });
    });
  }

  onMouseEnter() {
    gsap.to(this.inner, {
      scale: 1.1,
      duration: 0.4,
      ease: 'back.out'
    });
  }

  onMouseMove(e) {
    if (this.isDragging) return;

    const rect = this.button.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;

    const distX = (e.clientX - centerX) * 0.3;
    const distY = (e.clientY - centerY) * 0.3;

    gsap.to(this.inner, {
      x: distX,
      y: distY,
      duration: 0.3,
      overwrite: 'auto'
    });
  }

  onMouseLeave() {
    gsap.to(this.inner, {
      x: 0,
      y: 0,
      scale: 1,
      duration: 0.4,
      ease: 'elastic.out(1, 0.5)',
      overwrite: 'auto'
    });
  }
}

// Initialize all magnetic buttons
document.querySelectorAll('.magnetic-button').forEach(button => {
  new MagneticButton(button);
});

// FLIP layout transition
class FlipLayoutCard {
  constructor(card) {
    this.card = card;
    this.isFlipped = false;

    this.card.addEventListener('click', (e) => {
      this.flip();
    });
  }

  flip() {
    // FLIP: First
    const first = this.card.getBoundingClientRect();

    // Change DOM state
    this.card.classList.toggle('flipped');
    this.isFlipped = !this.isFlipped;

    // FLIP: Last
    const last = this.card.getBoundingClientRect();

    // FLIP: Invert
    const deltaX = first.left - last.left;
    const deltaY = first.top - last.top;
    const deltaW = first.width / last.width;
    const deltaH = first.height / last.height;

    // FLIP: Play
    gsap.from(this.card, {
      x: deltaX,
      y: deltaY,
      scaleX: deltaW,
      scaleY: deltaH,
      opacity: 0.7,
      duration: 0.6,
      ease: 'power2.out'
    });
  }
}

document.querySelectorAll('.flip-card').forEach(card => {
  new FlipLayoutCard(card);
});
```

**When descender safety applies:** Not applicable (no text animation).

**Bundle size:** ~40kb (GSAP)

**Performance:** 60fps if using transform animations only.

**Best for:** Interactive cards, CTA buttons, gallery experiences.

---

### Tier 3: Fragment Shader Distortion

Hover position drives fragment shader distortion.

```glsl
// fragment.glsl
uniform vec2 uMouse;
uniform sampler2D uTexture;
varying vec2 vUv;

void main() {
  // Distance from fragment to mouse
  float dist = distance(vUv, uMouse);

  // Distortion amount (stronger closer to mouse)
  float distortion = sin(dist * 10.0) * (1.0 - dist) * 0.1;

  // Displace UVs
  vec2 displaced = vUv + distortion;

  // Sample texture with displacement
  vec4 color = texture2D(uTexture, displaced);

  gl_FragColor = color;
}
```

```javascript
import * as THREE from 'three';

class HoverDistortionShader {
  constructor(canvas) {
    this.scene = new THREE.Scene();
    this.camera = new THREE.PerspectiveCamera(75, canvas.clientWidth / canvas.clientHeight, 0.1, 1000);
    this.renderer = new THREE.WebGLRenderer({ canvas });
    this.renderer.setSize(canvas.clientWidth, canvas.clientHeight);
    this.camera.position.z = 5;

    this.mouse = new THREE.Vector2(0.5, 0.5);

    // Create plane with hover shader
    const geometry = new THREE.PlaneGeometry(10, 10);
    const material = new THREE.ShaderMaterial({
      vertexShader,
      fragmentShader,
      uniforms: {
        uMouse: { value: this.mouse },
        uTexture: { value: new THREE.TextureLoader().load('image.jpg') }
      }
    });

    const mesh = new THREE.Mesh(geometry, material);
    this.scene.add(mesh);

    this.attachListeners(material);
    this.animate();
  }

  attachListeners(material) {
    document.addEventListener('mousemove', (e) => {
      // Normalize mouse to 0-1
      this.mouse.x = e.clientX / window.innerWidth;
      this.mouse.y = 1.0 - (e.clientY / window.innerHeight);

      material.uniforms.uMouse.value = this.mouse;
    });
  }

  animate() {
    requestAnimationFrame(() => this.animate());
    this.renderer.render(this.scene, this.camera);
  }
}
```

**When descender safety applies:** Not applicable (WebGL scene).

**Bundle size:** ~50kb (Three.js)

**Performance:** GPU-bound.

**Best for:** VFX galleries, cutting-edge experiences.

---

## Family 5: Typography

Text itself becomes the medium of expression.

### Tier 1: Variable Fonts Driven by Scroll Timeline

```css
@import url('https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght@9..144,400..900&display=swap');

body {
  font-family: 'Fraunces', serif;
  font-optical-sizing: auto;
}

/* Weight changes based on scroll */
h1 {
  font-variation-settings: 'wght' var(--scroll-weight, 400);
  animation: weightChange linear;
  animation-timeline: scroll();
  animation-range: 0 800px;
}

@keyframes weightChange {
  0% {
    font-variation-settings: 'wght' 400;
  }
  100% {
    font-variation-settings: 'wght' 900;
  }
}

/* Width morphing */
.display-text {
  font-variation-settings: 'wdth' var(--scroll-width, 100%);
  animation: widthChange linear;
  animation-timeline: scroll();
}

@keyframes widthChange {
  0% {
    font-variation-settings: 'wdth' 75%;
  }
  100% {
    font-variation-settings: 'wdth' 100%;
  }
}
```

**Browser support:** All modern browsers with variable font support.

**When descender safety applies:** Add padding-bottom and overflow: visible to display text (never clip).

**Performance:** Native, 60fps, no JavaScript.

**Best for:** Performance-first, elegant reveals.

---

### Tier 2: SplitType + Variable Fonts + GSAP

```javascript
import gsap from 'gsap';
import SplitType from 'split-type';

class VariableFontAnimation {
  constructor(selector) {
    this.element = document.querySelector(selector);
    this.split = new SplitType(selector, { types: 'chars' });

    // Apply descender safety
    this.split.lines?.forEach(line => {
      line.style.paddingBottom = '0.18em';
      line.style.overflow = 'visible'; // NOT 'clip' — clip ignores padding
    });

    this.animate();
  }

  animate() {
    const tl = gsap.timeline();

    // Animate character weight based on position
    tl.to(
      this.split.chars,
      {
        fontVariationSettings: 'wght' 900,
        onUpdate: function() {
          // Weight increases character by character
          gsap.utils.toArray(this.split.chars).forEach((char, i) => {
            const progress = i / this.split.chars.length;
            const weight = 400 + (500 * progress);
            gsap.set(char, { fontVariationSettings: `'wght' ${weight}` });
          });
        },
        duration: 1.2,
        ease: 'power2.inOut'
      },
      0
    );

    // Also animate color shift
    tl.to(
      this.split.chars,
      {
        color: '#FF6B35',
        stagger: 0.05,
        duration: 0.8
      },
      0.2
    );
  }
}

new VariableFontAnimation('.headline');
```

**When descender safety applies:** Mandatory for all display text.

**Bundle size:** ~50kb

**Performance:** 60fps if using font-variation-settings on transform/opacity timeline.

**Best for:** Editorial sites, premium landing pages.

---

### Tier 3: Canvas Text Rendering with Custom Rasterization

```javascript
class CanvasTextAnimation {
  constructor(canvas, text, options = {}) {
    this.canvas = canvas;
    this.ctx = canvas.getContext('2d');
    this.text = text;
    this.fontSize = options.fontSize || 100;
    this.fontFamily = options.fontFamily || 'serif';

    this.canvas.width = window.innerWidth;
    this.canvas.height = window.innerHeight;

    // Render text to canvas
    this.renderTextParticles();
  }

  renderTextParticles() {
    this.ctx.font = `${this.fontSize}px ${this.fontFamily}`;
    this.ctx.fillStyle = '#000';
    this.ctx.textAlign = 'center';
    this.ctx.textBaseline = 'middle';

    const centerX = this.canvas.width / 2;
    const centerY = this.canvas.height / 2;

    // Get pixel data from text rendering
    this.ctx.fillText(this.text, centerX, centerY);
    const imageData = this.ctx.getImageData(0, 0, this.canvas.width, this.canvas.height);
    const data = imageData.data;

    // Extract particles from pixels
    this.particles = [];
    for (let i = 0; i < data.length; i += 4) {
      if (data[i + 3] > 128) {  // Alpha channel
        const pixelIndex = i / 4;
        const x = (pixelIndex % this.canvas.width);
        const y = Math.floor(pixelIndex / this.canvas.width);

        this.particles.push({
          x: x,
          y: y,
          vx: (Math.random() - 0.5) * 2,
          vy: (Math.random() - 0.5) * 2
        });
      }
    }

    this.animate();
  }

  animate() {
    // Clear canvas
    this.ctx.clearRect(0, 0, this.canvas.width, this.canvas.height);

    // Update and render particles
    this.particles.forEach(p => {
      p.x += p.vx;
      p.y += p.vy;
      p.vx *= 0.98;  // Friction
      p.vy *= 0.98;

      this.ctx.fillStyle = '#000';
      this.ctx.fillRect(p.x, p.y, 2, 2);
    });

    requestAnimationFrame(() => this.animate());
  }
}

const canvas = document.querySelector('canvas');
new CanvasTextAnimation(canvas, 'EXPLODE', {
  fontSize: 200,
  fontFamily: 'Arial, sans-serif'
});
```

**When descender safety applies:** Not applicable (canvas rendering, not DOM).

**Bundle size:** ~5kb (custom code only)

**Performance:** GPU-accelerated canvas rendering.

**Best for:** Experimental, eye-catching reveals, particle effects.

---

## Summary Table: Technique Family Tiers

| Family | Tier 1 | Tier 2 | Tier 3 |
|--------|--------|--------|--------|
| **Cursor** | CSS vars (1kb) | GSAP dual (3kb) | WebGL distortion (50kb) |
| **Scroll** | CSS animation-timeline (0kb) | Lenis + GSAP (40kb) | Scroll-velocity shaders (80kb) |
| **Loading** | @starting-style (0kb) | SplitType + GSAP (50kb) | Matter.js particles (50kb) |
| **Hover** | CSS transitions (1kb) | GSAP FLIP (40kb) | Fragment shader (50kb) |
| **Typography** | Variable fonts (0kb) | SplitType + fonts (50kb) | Canvas text (5kb) |

Each family, each tier, is production-ready. Choose based on brand ambition, timeline, and technical confidence.

---

## Family 6: Page Transitions (Tier 2+)

The emotional contract of a page transition is this: when a user clicks a link, the site promises that the destination isn't a separate place — it's the next room in the same building. The browser's default behavior (white flash, full reload, content popping in) breaks that promise. Page transitions keep it.

This is the single most common trait across Awwwards SOTD winners. Studios like Osmo have built 35+ winners around Barba.js + GSAP as their transition engine. Barba intercepts navigation, fetches the new page via AJAX, and provides lifecycle hooks where GSAP animations run. The result is SPA-like behavior without a JavaScript framework.

**See references/page-transitions.md for the complete implementation guide.**

### The taste principles

**Transition type should match navigation intent.** A clip-path wipe suits moving between major sections (Home → Work). A crossfade suits moving between peers (Project A → Project B). A FLIP morph suits diving deeper (thumbnail → full project). Using the same transition everywhere feels lazy.

**Speed matters more than complexity.** A 500ms crossfade that feels instant beats a 2-second elaborate wipe that makes users wait. The transition should be fast enough that users don't notice it as a "thing" — they just notice the absence of jarring navigation.

**Persistent elements create continuity.** Navigation, custom cursor, and audio should live outside Barba's swap container and persist across transitions. Watching the nav rebuild on every page click destroys the illusion.

**Lenis must be destroyed and recreated after every transition.** This is the most common bug — smooth scroll breaks silently because the old Lenis instance is bound to a DOM that no longer exists. ScrollTrigger instances must also be killed and refreshed.

**For single-page sites:** Page transitions don't apply, but the *feeling* they create should be replicated through section transitions — scroll-driven crossfades, cinematic loaders, pinned storytelling sections.

**Mobile consideration:** Page transitions work identically on mobile. The key risk is that heavy transition animations (large clip-paths, FLIP calculations on many elements) can stutter on mid-range devices. Keep mobile transitions simpler — a fast crossfade rather than a complex morph.

---

## Family 7: Marquee / Infinite Ticker (Brand Justified Only)

A marquee adds perpetual motion to the page when content is worth repeating in motion. It has become a near-universal pattern in portfolio and agency sites — which means judges have seen it hundreds of times. It only earns its place when the content inside genuinely justifies the motion.

**Brand gate — answer before building:**
1. Does this brand have content worth repeating? (Real client logos, real project names, distinctive testimonials — not generic skill words)
2. Would this content feel strong and specific in a static layout? If not, motion doesn't fix weak content.
3. Does perpetual motion fit the brand's emotional trigger? A brand whose metaphor is "silence and pause" should not have a marquee.

If YES to all three, build it. If not, replace it with something that actually serves the brand.

### How it works

The mechanic is simple: duplicate the content so the track is twice as wide as needed, then translate it by -50% in a loop. When the first copy scrolls out of view, the second copy is already seamlessly in position. The loop is invisible.

At Tier 1, this is pure CSS — a `@keyframes` animation on `translateX(-50%)` with `linear infinite` timing. At Tier 2, GSAP drives the position and the speed responds to Lenis scroll velocity — faster when the user is actively scrolling, slower when idle, creating a feeling that the page breathes with the user.

### The taste principles

**Content must be meaningful.** Client logos, project names, skill tags, testimonials, location coordinates — never placeholder text or lorem ipsum. The marquee is a content vehicle, not a decoration.

**Speed should feel unhurried.** 15-25 seconds for a full cycle. Faster feels anxious. Slower feels broken. The user should be able to read each item as it passes without chasing it.

**Pause on hover** is expected. It signals interactivity and lets users read content they're interested in.

**Use at transition points.** Marquees work best as section dividers — between the hero and content, between content and footer. They create rhythm in the page's vertical flow. Placing one mid-section feels disruptive; placing one between sections feels like a palate cleanser.

**Alternate directions.** If using two marquees (common in SOTD winners), have them move in opposite directions. The visual tension between left-moving and right-moving strips creates dynamism.

**Mobile:** Marquees work well on mobile because they're touch-passive — the user doesn't interact with them. Just ensure the text size is readable at 375px and that the marquee doesn't interfere with vertical scroll.

---

## Family 8: Horizontal Scroll (Tier 2+)

Horizontal scroll breaks the tyranny of vertical. The user is scrolling down, and suddenly content moves sideways. It's a spatial surprise — a moment where the page demonstrates it has a sense of direction, not just a sense of down.

### How it works

A wrapper section pins in place using ScrollTrigger's `pin: true`. Inside it, a flex track of panels is translated along the x-axis as the user continues scrolling vertically. The scroll distance equals the track width, so each panel gets roughly one viewport of scroll. `invalidateOnRefresh: true` is essential — it recalculates dimensions when the browser resizes.

### The taste principles

**Maximum one per site.** Horizontal scroll is a moment, not a layout strategy. Two horizontal sections back to back feels like a different website.

**Each panel must justify a full screen.** If a panel would work as a regular stacked section, it doesn't belong in a horizontal track. Use horizontal scroll for content that benefits from lateral comparison — project showcases, timeline progressions, before/after reveals.

**Mobile adaptation is critical.** On mobile, horizontal scroll sections should collapse to a standard vertical stack or a swipeable carousel. Pinned horizontal scrolling on a phone with a narrow viewport feels claustrophobic and confusing — the user can't tell if they're scrolling the page or the section. Detect touch devices and provide a graceful alternative.

**Progress indicators help.** A small "2/5" counter or a thin progress bar at the top of the pinned section tells the user how much content remains. Without this, horizontal scroll feels like being lost in a tunnel.

**Don't fight scroll direction on touch.** If you keep horizontal scroll on mobile, ensure the gesture is horizontal swipe (native feeling) rather than vertical-scroll-mapped-to-horizontal-movement (confusing). Consider using CSS `scroll-snap-type: x mandatory` for a native-feeling horizontal swipe on mobile.

---

## Family 9: Text Mask / Clip Reveals (Tier 2+)

Text that acts as a window into imagery or video beneath it. The letters become the mask; the media is the content. As the user scrolls, the media shifts or reveals through the letterforms. It's the technique behind many viral Awwwards screenshots — enormous bold type with imagery peeking through.

### How it works

Two approaches: CSS `background-clip: text` is simpler — set an image as the text element's background, clip it to the text shape, and make the text fill transparent. The image shows only where the text is. SVG `<clipPath>` is more powerful — you can animate the clip region, use it with video, and control it with ScrollTrigger.

### The taste principles

**Bold, heavy fonts only.** This technique requires maximum surface area. Weights of 700-900, ideally condensed or extended widths. Thin fonts don't mask enough area — the image becomes illegible fragments rather than readable text.

**The media should be cinematic.** Slow-motion video, high-contrast photography, or gradients with movement. Static images work but feel less dynamic. The whole point is the interplay between the rigid letterforms and the flowing content behind them.

**Scroll-driven parallax makes it sing.** If the background image shifts position as the user scrolls (via `background-attachment: fixed` or a ScrollTrigger-driven transform), the reveal becomes dynamic rather than static. The text stays still; the world moves behind it.

**On mobile:** `background-attachment: fixed` doesn't work on iOS — it's a known browser limitation. Use a ScrollTrigger-driven `background-position` shift instead. Also reduce the font size — at mobile scale, text mask becomes harder to read, so increase letter-spacing and consider using fewer, shorter words.

**Accessibility:** Text mask content is technically invisible to screen readers if you use `-webkit-text-fill-color: transparent`. Ensure the text content is available via `aria-label` or a visually hidden duplicate.

---

## Family 10: Sticky Scrollytelling (Tier 2+)

A section pins in place while internal content transforms as the user scrolls — text swaps, images crossfade, counters animate, progress indicators advance. This is the narrative backbone of editorial and product-story SOTD winners. It turns scrolling into a controlled timeline where the creator, not the user, determines the pacing.

### How it works

ScrollTrigger pins the section to the viewport. A GSAP timeline is scrubbed by scroll position. Inside the timeline, child elements fade in and out in sequence. The `end` value determines how much scroll distance the section consumes — `+=300%` means three viewports of scrolling through one section.

### The taste principles

**Give each step generous scroll distance.** At least 100vh per step, ideally more. Rushing through steps — five transitions in one viewport of scroll — destroys the narrative pacing and makes the section feel like a flickering slideshow. The user needs time to read, absorb, and move on.

**Visual anchoring prevents disorientation.** Something must stay constant while other things change. A progress bar, a section number, a persistent image with changing captions — the anchor tells the user "you're still in the same place, the content is advancing." Without it, pinned sections feel like the page is broken.

**Entry and exit should be graceful.** The section shouldn't snap into pinned mode abruptly. Ease into it — the scroll velocity naturally slows as the pin takes hold if using Lenis. When the section unpins, the next section should already be partially visible, creating a seamless handoff.

**Mobile: reduce the scope.** A 5-step scrollytelling section that consumes 500% of viewport height on mobile is exhausting. Consider reducing to 3 steps on mobile, or collapsing the section to a simple vertical flow with subtle scroll-triggered reveals instead. The narrative can be preserved without the pin mechanic.

**Don't confuse it with a slider.** Scrollytelling is scroll-driven — the user controls the pace. A slider is click-driven or auto-advancing. Mixing the two (auto-advancing content inside a pinned section) creates a timing conflict where the user is scrolling at one speed and the content is advancing at another.

---

## Summary Table

| Family | Tier 1 | Tier 2 | Tier 3 |
|--------|--------|--------|--------|
| **Cursor** | CSS vars | GSAP dual + magnetic | WebGL distortion field |
| **Scroll** | CSS animation-timeline | Lenis + GSAP ScrollTrigger | Scroll-velocity shaders |
| **Loading** | CSS @starting-style | SplitType + GSAP timeline | Physics particle assembly |
| **Hover** | CSS transitions + custom props | GSAP FLIP + magnetic buttons | Fragment shader distortion |
| **Typography** | Variable fonts + scroll | SplitType + variable axes | Canvas text rasterization |
| **Page Transitions** | — | Barba.js + GSAP | + FLIP shared-element morphs |
| **Marquee** | CSS @keyframes infinite | GSAP scroll-velocity responsive | — |
| **Horizontal Scroll** | — | ScrollTrigger pin + translate | + parallax depth layers |
| **Text Mask** | — | CSS background-clip: text | SVG clipPath + scroll-driven |
| **Scrollytelling** | — | Pinned section + scrub timeline | + media crossfades + counters |

---

## Micro-Interactions: Brand Moments at the Section Level

Every section must contain at least ONE small interaction that reveals the brand's personality. These are not signature interactions — they are the texture that proves intentionality. Awwwards-winning sites have them throughout; judges notice their absence more than their presence.

**What a micro-interaction is:** A small, contained interaction — 200ms to 600ms — that responds to user action and communicates something specific about the brand. Not a full animation. Not decoration. A precise moment.

**10 patterns by context:**

- **Hover on text link:** Font weight momentarily increases (variable font `wght` axis). Text gets a background color that reveals whitespace design. A subtle underline draws in from one end. Duration: 200ms.

- **Scroll into section:** A decorative line or shape appears first — signals "something is about to happen." The headline animates after. The preparatory element has variable opacity tied to scroll progress.

- **Hover on image:** A scan-line effect (overlaid div with linear-gradient moving top to bottom). Or a color shift via `mix-blend-mode`. Not a zoom — something smaller and more considered.

- **Loading state:** Instead of a spinner: dots fade in sequence with irregular timing (not mechanically perfect). Or brand acronym letters appear one by one, each with a different easing curve.

- **Cursor idle (2 seconds):** A small hint appears near the cursor — "scroll", "explore", "play" — in the brand's typographic voice. Fades in at low opacity. Disappears on movement. Never intrusive.

- **Form input focus:** The label doesn't just move — it rotates slightly, becomes a brand color, and the input gets a bottom border that draws from left to right via `clip-path` animation.

- **Card hover:** Shadow changes in both opacity AND color (cool → warm, or vice versa). A small accent appears (fade-in 200ms). Card does not scale — it stays fixed size. Scaling reads as template.

- **Number counter on scroll:** Numbers animate from zero to final value as the section enters view. Font weight also increases subtly (variable font axis). Creates a feeling of data "arriving."

- **Color shift on scroll:** Background transitions through 3-4 brand colors based on scroll position. Smooth with 100ms delay between shifts. Not jarring — the user notices it 2 seconds after it happens.

- **Text underline bloom:** The underline doesn't grow left-to-right. It appears as a dot, expands upward, then grows outward in both directions. 300ms total. Distinctive and unrepeatable.

**The test:** If you removed the micro-interaction, would the section feel colder, more generic, less considered? If yes, it's doing its job.
