# Tech Stack & Implementation Guide

This guide outlines the technical foundations for building Awwwards-caliber web experiences. It prioritizes flexibility, performance, and creative control, aligning with the 3-tier complexity model.

---

## 🏗️ Frameworks & Architecture

### Execution Primitives
- **TypeScript**: Strictly required for all projects. It provides essential type safety and prevents UI hallucinations.
- **Bun**: Recommended for package management and execution velocity.

### Framework Selection Guide
Choose the framework that best serves the project's complexity tier and creative ambition.

#### Tier 1: CSS & Lightweight
- **Astro (Latest 5.x)**: The premier choice for content-heavy sites and zero-JS delivery. Leverage **View Transitions API** for app-like navigation and **Server Islands** for high-performance dynamic components.
- **Vite + Vanilla TS**: Maximum control and zero framework overhead. Ideal when every byte and millisecond counts.

#### Tier 2: GSAP & DOM
- **Astro**: Use React or Svelte islands for interactive components while keeping the core document static.
- **TanStack Start**: The standard for full-stack, type-safe React applications. Built on TanStack Router with world-class type safety and efficient server functions.
- **Vite + Vanilla TS**: Predictable behavior for complex DOM orchestrations without hydration edge cases.

#### Tier 3: WebGL, Shaders & Generative
- **Vite + Vanilla TS**: Direct control over the WebGL context without framework abstraction overhead.
- **Astro + React Islands**: Effective for hybrid sites combining standard content with immersive WebGL sections.
- **Three.js + React Three Fiber (R3F)**: Component-based 3D scenes within the React ecosystem (best paired with TanStack Start or Astro).

### 🔄 Framework Synergy: Picking Your Stack
Choosing between **Astro** and **TanStack Start** depends on the project's primary metaphor:

| Vector | Astro (Latest) | TanStack Start |
| :--- | :--- | :--- |
| **Architecture** | MPA (Multi-Page App) + Islands | Full-stack SPA/Hybrid |
| **Performance** | Zero-JS default, ultra-fast LCP | React-first, powerful hydration |
| **Interactivity** | Best for isolated "wow" moments | Best for complex, interconnected state |
| **Data Flow** | **Content Layer** for type-safe data | Unified TanStack Query & Router |

**Rule of Thumb**: Use **Astro** for editorial, brand-heavy, and high-performance storytelling. Use **TanStack Start** for complex applications, dashboards, or logic-heavy creative tools.

### Framework-Agnostic Rules
- Initialize scroll and animation libraries only after the DOM is fully ready.
- Always clean up animation contexts, event listeners, and WebGL resources on component unmount or route changes.
- Avoid blocking the main thread with heavy synchronous initialization.
- Use dynamic imports for large libraries like GSAP or Three.js to optimize initial load performance.

---

## 🎨 Styling & Components

### Styling Strategy
- **Tailwind CSS**: Efficient for rapid prototyping and design-system consistency. Custom CSS or CSS Modules offer more granular control when the design demands bespoke styling.
- **Custom Properties**: Use CSS variables for dynamic values that need to be accessed by both CSS and JavaScript (e.g., mouse position, scroll velocity).
- **Mathematical Spacing**: Derive spacing and typography from mathematical ratios (like the Golden Ratio) for inherent visual harmony.
- **Fluid Typography**: Implement `clamp()` based typography for seamless scaling across all screen sizes.

### Component Foundations
- **shadcn/ui**: Provides accessible component primitives. Requires heavy visual customization — default styles should not ship.
- **Container Queries**: Use native CSS `@container` or framework plugins for component-level responsive adaptation.

---

## ✨ Animation & Motion Tech

### Tier 1: Lightweight Motion
- **CSS Animations**: Best for micro-interactions and simple transitions with zero JS overhead.
- **Motion One**: A small, powerful library built on the Web Animations API. Excellent for simple orchestration.
- **Native Scroll-Driven Animations**: Use for hardware-accelerated, scroll-linked effects without JavaScript dependencies.

### Tier 2: DOM Orchestration
- **GSAP + ScrollTrigger**: Mature and widely documented for complex, scroll-linked storytelling and timeline sequencing.
- **SplitType**: Splits text into animatable spans for character, word, and line-level effects.
- **Lenis**: Provides smooth scrolling with an exposed velocity value useful for physics-based effects and shader distortions.
- **Framer Motion (`motion/react`)**: Ideal for React-based interface transitions, gestures, and layout animations.

### Tier 3: Immersive & Generative
- **Three.js**: The foundational library for 3D on the web. Provides direct access to scenes, cameras, and shaders.
- **OGL**: A minimalist, high-performance alternative to Three.js for shader-pure experiences and lightweight 3D.
- **React Three Fiber (R3F)**: A powerful React reconciler for Three.js, supported by a rich ecosystem like `@react-three/drei`.
- **Curtains.js / gpu-curtains**: Specialized for synchronizing DOM elements with WebGL planes, enabling shaders on standard HTML content.
- **Theatre.js**: A professional-grade motion design tool for sequencing complex animations with a visual keyframe editor.
- **GSAP (at Tier 3)**: Use to orchestrate the DOM and high-level logic while specialized libraries handle the WebGL layer.

---

## 🌎 Physics Engines

Physicality is often the difference between "motion" and "realism."

- **Rapier**: High-performance Rust/WASM physics engine. The preferred choice for complex 3D simulations (Tier 3).
- **Matter.js**: The industry standard for 2D rigid body physics (Tier 2).
- **P2.js**: A specialized 2D physics engine optimized for high-performance constraints and top-down mechanics.

### Shader Resources
- **GLSL**: The primary language for writing custom vertex and fragment shaders.
- **glslify**: Allows for modular shader code and imports.
- **three-custom-shader-material**: Useful for extending standard Three.js materials with custom shader logic.
- **ShaderChunk**: Leverage built-in Three.js shader components for faster development.

---

## 🚀 Performance & Accessibility

- **Image Optimization**: Always use modern formats (WebP/AVIF) and provide explicit dimensions to prevent Layout Shift (CLS).
- **Resource Prioritization**: Preload critical fonts and assets. Lazy-load non-critical components and heavy libraries.
- **Animation Performance**: Only animate `transform` and `opacity` to avoid expensive layout repaints.
- **Reduced Motion**: Always respect the `prefers-reduced-motion` media query by providing simplified or static alternatives.
- **Semantic HTML**: Maintain a logical heading structure and use appropriate ARIA attributes, especially for complex interactive elements.
