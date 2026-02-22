# Animation Systems

Motion as meaning. Every animation communicates purpose.

---

## Animation Decision Matrix

| Library | Best For | Bundle Size | Learning Curve |
|---------|----------|-------------|----------------|
| **GSAP + ScrollTrigger** | Complex scroll sequences, pinning, timeline control | ~35kb | Medium |
| **Framer Motion** | React orchestration, gestures, layout animations | ~40kb | Low |
| **Three.js / R3F** | 3D scenes, WebGL, immersive experiences | ~150kb+ | High |
| **Lenis** | Smooth scrolling foundation | ~3kb | Low |
| **CSS Animations** | Simple transitions, hover states | 0kb | Low |

**Rule:** Start with CSS → Escalate to GSAP/Framer → Three.js only for immersive

---

## GSAP Patterns

### Basic Timeline

```typescript
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

// Orchestrated entrance
gsap.timeline({ defaults: { ease: 'expo.out' } })
  .from('.hero-title', { y: 100, opacity: 0, duration: 1 })
  .from('.hero-subtitle', { y: 50, opacity: 0, duration: 0.8 }, '-=0.6')
  .from('.hero-cta', { scale: 0.8, opacity: 0, duration: 0.6 }, '-=0.4');
```

### ScrollTrigger Patterns

```typescript
// Pin section while content scrolls
ScrollTrigger.create({
  trigger: '.pinned-section',
  start: 'top top',
  end: '+=200%',
  pin: true,
  scrub: 1
});

// Scrub animation with scroll
gsap.to('.scroll-element', {
  x: 500,
  rotation: 360,
  scrollTrigger: {
    trigger: '.scroll-element',
    start: 'top 80%',
    end: 'top 20%',
    scrub: true
  }
});

// Batch reveals (staggered on scroll)
ScrollTrigger.batch('.reveal-item', {
  onEnter: batch => gsap.to(batch, {
    opacity: 1,
    y: 0,
    stagger: 0.1,
    overwrite: true
  }),
  start: 'top 85%'
});
```

### Cleanup (Critical)

```typescript
useEffect(() => {
  const ctx = gsap.context(() => {
    // All GSAP code here
  }, containerRef);
  
  return () => ctx.revert(); // Kills all animations in context
}, []);
```

### Easing Reference

```typescript
// Hadnoir standard easings
const easings = {
  expoOut: 'expo.out',      // Entrances
  expoIn: 'expo.in',        // Exits
  smooth: 'power2.out',     // General
  elastic: 'elastic.out(1, 0.5)', // Playful
  dramatic: 'power4.inOut'  // Hero moments
};
```

---

## Framer Motion Patterns

### Orchestrated Entrance

```tsx
import { motion } from 'framer-motion';

const container = {
  hidden: { opacity: 0 },
  show: {
    opacity: 1,
    transition: {
      staggerChildren: 0.1,
      delayChildren: 0.3
    }
  }
};

const item = {
  hidden: { y: 20, opacity: 0 },
  show: { 
    y: 0, 
    opacity: 1,
    transition: {
      ease: [0.16, 1, 0.3, 1], // expoOut
      duration: 0.6
    }
  }
};

function Hero() {
  return (
    <motion.div variants={container} initial="hidden" animate="show">
      <motion.h1 variants={item}>Title</motion.h1>
      <motion.p variants={item}>Subtitle</motion.p>
      <motion.button variants={item}>CTA</motion.button>
    </motion.div>
  );
}
```

### Scroll-Linked Animations

```tsx
import { useScroll, useTransform, motion } from 'framer-motion';

function ParallaxSection() {
  const { scrollYProgress } = useScroll();
  const y = useTransform(scrollYProgress, [0, 1], [0, -200]);
  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  
  return (
    <motion.div style={{ y, opacity }}>
      Content
    </motion.div>
  );
}
```

### Layout Animations

```tsx
// Automatic layout transitions
<motion.div
  layout
  layoutId="unique-id"
  transition={{ type: 'spring', stiffness: 300, damping: 30 }}
>
  Content that changes size
</motion.div>
```

### Gestures

```tsx
<motion.div
  whileHover={{ scale: 1.02 }}
  whileTap={{ scale: 0.98 }}
  whileDrag={{ scale: 1.1 }}
  drag="x"
  dragConstraints={{ left: 0, right: 0 }}
>
  Interactive element
</motion.div>
```

### AnimatePresence (Enter/Exit)

```tsx
import { AnimatePresence, motion } from 'framer-motion';

function Modal({ isOpen, onClose }) {
  return (
    <AnimatePresence>
      {isOpen && (
        <motion.div
          initial={{ opacity: 0, scale: 0.95 }}
          animate={{ opacity: 1, scale: 1 }}
          exit={{ opacity: 0, scale: 0.95 }}
          transition={{ ease: [0.16, 1, 0.3, 1], duration: 0.3 }}
        >
          Modal content
        </motion.div>
      )}
    </AnimatePresence>
  );
}
```

---

## Three.js / React Three Fiber Patterns

### Scene Setup

```tsx
import { Canvas } from '@react-three/fiber';
import { OrbitControls, Environment } from '@react-three/drei';

function Scene() {
  return (
    <Canvas
      camera={{ position: [0, 0, 5], fov: 50 }}
      dpr={[1, 2]} // Responsive pixel ratio
    >
      <Environment preset="city" />
      <ambientLight intensity={0.5} />
      <directionalLight position={[10, 10, 5]} />
      
      <Mesh />
      <OrbitControls enableZoom={false} />
    </Canvas>
  );
}
```

### Scroll-Linked 3D

```tsx
import { useScroll } from '@react-three/drei';
import { useFrame } from '@react-three/fiber';

function ScrollMesh() {
  const scroll = useScroll();
  
  useFrame(() => {
    // scroll.offset is 0-1 through page
    meshRef.current.rotation.y = scroll.offset * Math.PI * 2;
  });
  
  return <mesh ref={meshRef}>...</mesh>;
}
```

### Performance Rules
- Use `dpr={[1, 2]}` for responsive pixel ratio
- Limit lights (max 2-3)
- Use instancing for repeated geometry
- Always include fallback for WebGL errors

---

## Lenis Smooth Scroll

### Setup

```typescript
import Lenis from 'lenis';

const lenis = new Lenis({
  duration: 1.2,
  easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
  orientation: 'vertical',
  smoothWheel: true
});

function raf(time: number) {
  lenis.raf(time);
  requestAnimationFrame(raf);
}
requestAnimationFrame(raf);

// Integrate with GSAP ScrollTrigger
lenis.on('scroll', ScrollTrigger.update);
gsap.ticker.add((time) => {
  lenis.raf(time * 1000);
});
gsap.ticker.lagSmoothing(0);
```

---

## CSS Animation Patterns

### Prefer CSS For:
- Hover states
- Simple transitions
- Infinite loops (marquees)
- Reduced motion fallbacks

```css
/* Hover transition */
.interactive {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
.interactive:hover {
  transform: scale(1.02);
}

/* Staggered entrance */
@keyframes fadeUp {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.stagger-item {
  animation: fadeUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) backwards;
}
.stagger-item:nth-child(1) { animation-delay: 0ms; }
.stagger-item:nth-child(2) { animation-delay: 100ms; }
.stagger-item:nth-child(3) { animation-delay: 200ms; }

/* Reduced motion */
@media (prefers-reduced-motion: reduce) {
  *, *::before, *::after {
    animation-duration: 0.01ms !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## Stagger Patterns

### Fibonacci (Natural Feel)
```typescript
const fibonacciStagger = [0, 1, 1, 2, 3, 5, 8, 13].map(n => n * 50);
```

### Equal (Uniform)
```typescript
const equalStagger = (index: number, base: number = 100) => index * base;
```

### Decelerating (Fast Start)
```typescript
const decelStagger = (index: number) => Math.sqrt(index) * 100;
```

### Accelerating (Slow Build)
```typescript
const accelStagger = (index: number) => Math.pow(index, 1.5) * 50;
```

---

## Animation Performance

### ✅ Do
- Animate `transform` and `opacity` only
- Use `will-change` sparingly (add before, remove after)
- Use CSS containment: `contain: layout style paint`
- Throttle scroll events

### ❌ Don't
- Animate `width`, `height`, `top`, `left` (triggers layout)
- Animate `filter: blur()` during scroll
- Use unthrottled mousemove animations
- Create too many simultaneous animations

---

## Common Animation Recipes

### Page Load Orchestration
```typescript
gsap.timeline()
  .from('nav', { y: -20, opacity: 0, duration: 0.8 })
  .from('.hero-title', { y: 100, opacity: 0, duration: 1 }, '-=0.4')
  .from('.hero-subtitle', { y: 50, opacity: 0, duration: 0.8 }, '-=0.6')
  .from('.hero-cta', { scale: 0.8, opacity: 0, duration: 0.6 }, '-=0.4');
```

### Scroll Reveal
```typescript
ScrollTrigger.batch('.reveal', {
  onEnter: batch => gsap.from(batch, {
    y: 50,
    opacity: 0,
    stagger: 0.1,
    duration: 0.8,
    ease: 'expo.out'
  }),
  start: 'top 85%'
});
```

### Magnetic Button
```typescript
const button = document.querySelector('.magnetic');
button.addEventListener('mousemove', (e) => {
  const rect = button.getBoundingClientRect();
  const x = e.clientX - rect.left - rect.width / 2;
  const y = e.clientY - rect.top - rect.height / 2;
  
  gsap.to(button, {
    x: x * 0.3,
    y: y * 0.3,
    duration: 0.3,
    ease: 'power2.out'
  });
});
```
