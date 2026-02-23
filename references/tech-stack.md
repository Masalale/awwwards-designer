# Tech Stack & Implementation Guide

This guide condenses the fundamental technologies and technical best practices for building Awwwards-caliber websites. *Always leverage your latest model context and capabilities when implementing these tools.*

---

## 🏗️ Frameworks & Architecture
Choose the right tool for the job. Default to React-based ecosystems unless static generation is the primary requirement.

- **Next.js (App Router)**: SEO-critical, complex web apps. Use Server Components by default; only use `'use client'` where interactivity or animation is required.
- **Astro**: Content-heavy, fast static sites. Use the Islands Architecture (`client:visible`, `client:load`) to hydrate only the interactive parts, minimizing shipped JS.
- **Remix & TanStack Start**: Excellent for heavy routing or form-mutations.
- **Vite + React**: Rapid prototyping and SPAs.

*Performance Rule*: Always optimize images (explicit width/height to prevent CLS), lazy-load below the fold, and preload critical fonts.

---

## 🎨 Styling & Components
Tailwind CSS is the default choice for velocity and consistency, but CSS-in-JS can be used if requested.

- **Tailwind CSS Strategy**:
  - Extend the config with custom, mathematically derived spacing based on the Golden Ratio:
    `spacing: { 'sm': '0.618rem', 'base': '1rem', 'md': '1.618rem', 'lg': '2.618rem', 'xl': '4.236rem', '2xl': '6.854rem' }`
  - Use custom `cubic-bezier` easing curves in `theme.transitionTimingFunction` (e.g. `'expo-out': 'cubic-bezier(0.16, 1, 0.3, 1)'`).
  - Prefer `@tailwindcss/container-queries` for fluid, component-level responsiveness over rigid screen breakpoints.
- **shadcn/ui Integration**: 
  - Use shadcn as a **foundation**, but immediately override the default styles.
  - Round out the default hard corners, adjust the default `ring` focus state, and apply distinctive brand styling.
  - *Never* ship default shadcn verbatim.
- **Anti-Patterns**: Avoid `!important`, deeply nested inline styles, and using UI libraries that force difficult-to-override generic styling (e.g., standard Material UI).

---

## ✨ Animation & Motion Tech
Motion should feel orchestrated, never random.

- **CSS Animations**: Use for micro-interactions, hover states, and simple UI transitions. Zero JS overhead.
- **Framer Motion**: The go-to for React interface orchestration. Ideal for gestures, `AnimatePresence` (entry/exit animations), and layout transitions.
- **GSAP + ScrollTrigger**: The gold standard for complex, scroll-linked storytelling, pinning, and sequenced timelines.
  - *Critical fix*: Always cleanup GSAP contexts in React using `ctx.revert()` in the `useEffect` cleanup function.
- **Lenis**: Use for buttery smooth scrolling foundations.
- **Three.js / React Three Fiber (R3F)**: Use solely for immersive 3D experiences, WebGL shaders, and high-end interactive hero sections.
  - *WebGL Performance Rule*: **Always** cap pixel ratios and use frameloop on demand when possible to save battery: `<Canvas dpr={[1, 1.5]} frameloop="demand">`. Limit lights to a maximum of 2-3 per scene.

*Performance Rule*: Only animate `transform` and `opacity`. Animating `width`, `height`, or `top` triggers layout repaints and causes jank.

---

## 🔣 Iconography
- **Use Lucide Icons**. They are clean, modern, and consistent.
- **Avoid FontAwesome** or mixing different random SVG sets.
- Always add `aria-label` to icon-only buttons for accessibility.
