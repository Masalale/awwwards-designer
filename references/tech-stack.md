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
- **Astro**: Excellent for content-heavy sites and zero-JS delivery. Use islands architecture for isolated interactivity.
- **SvelteKit**: Offers a highly efficient compiler and built-in transitions, resulting in minimal bundle sizes.
- **Vite + Vanilla TS**: Provides maximum control and zero framework overhead. Ideal when every byte and millisecond counts.

#### Tier 2: GSAP & DOM
- **Astro**: Remains a strong choice. Use React or Svelte islands for GSAP-heavy components while keeping the rest of the page static.
- **Next.js**: Viable for complex applications. Use `"use client"` directives carefully and ensure GSAP contexts are cleaned up on unmount.
- **SvelteKit**: The `onMount` lifecycle aligns naturally with GSAP initialization patterns.
- **Vite + Vanilla TS**: Offers the most predictable behavior for complex DOM orchestrations without hydration edge cases.

#### Tier 3: WebGL, Shaders & Generative
- **Vite + Vanilla TS**: The preferred choice for maximum performance. Direct control over the WebGL context without framework abstraction overhead.
- **Astro + React Islands**: Effective for hybrid sites combining standard content with immersive WebGL sections.
- **Three.js + React Three Fiber (R3F)**: The standard for component-based 3D scenes within the React ecosystem.
- **Next.js**: Use with caution for WebGL. Utilize dynamic imports with `ssr: false` for all canvas-based components to avoid server-side conflicts.

### Framework-Agnostic Rules
- Initialize scroll and animation libraries only after the DOM is fully ready.
- Always clean up animation contexts, event listeners, and WebGL resources on component unmount or route changes.
- Avoid blocking the main thread with heavy synchronous initialization.
- Use dynamic imports for large libraries like GSAP or Three.js to optimize initial load performance.

---

## 🎨 Styling & Components

### Styling Strategy
- **Tailwind CSS**: Preferred for rapid development and design system consistency.
- **Custom Properties**: Use CSS variables for dynamic values that need to be accessed by both CSS and JavaScript (e.g., mouse position, scroll velocity).
- **Mathematical Spacing**: Derive spacing and typography from mathematical ratios (like the Golden Ratio) for inherent visual harmony.
- **Fluid Typography**: Implement `clamp()` based typography for seamless scaling across all screen sizes.

### Component Foundations
- **shadcn/ui**: A solid starting point for accessible components. Always customize the default styles to match the project's unique aesthetic. Never ship default shadcn styles.
- **Container Queries**: Use `@tailwindcss/container-queries` for components that need to adapt based on their parent container's size rather than the viewport.

---

## ✨ Animation & Motion Tech

### Tier 1: Lightweight Motion
- **CSS Animations**: Best for micro-interactions and simple transitions with zero JS overhead.
- **Motion One**: A small, powerful library built on the Web Animations API. Excellent for simple orchestration.
- **Native Scroll-Driven Animations**: Use for hardware-accelerated, scroll-linked effects without JavaScript dependencies.

### Tier 2: DOM Orchestration
- **GSAP + ScrollTrigger**: The industry standard for complex, scroll-linked storytelling and timeline sequencing.
- **SplitType**: Essential for character, word, and line-based text animations.
- **Lenis**: Recommended for smooth scrolling. It exposes a velocity value that is critical for driving physical simulations and shader distortions.
- **Framer Motion (`motion/react`)**: Ideal for React-based interface transitions, gestures, and layout animations.

### Tier 3: Immersive & Generative
- **Three.js**: The foundational library for 3D on the web. Provides direct access to scenes, cameras, and shaders.
- **React Three Fiber (R3F)**: A powerful React reconciler for Three.js, supported by a rich ecosystem like `@react-three/drei`.
- **Curtains.js / gpu-curtains**: Specialized for synchronizing DOM elements with WebGL planes, enabling shaders on standard HTML content.
- **Theatre.js**: A professional-grade motion design tool for sequencing complex animations with a visual keyframe editor.
- **GSAP (at Tier 3)**: Use to orchestrate the DOM and high-level logic while specialized libraries handle the WebGL layer.

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
