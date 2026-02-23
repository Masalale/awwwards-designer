# Tech Stack & Implementation Guide

This guide condenses the fundamental technologies and technical best practices for building Awwwards-caliber websites. *Always leverage your latest model context and capabilities when implementing these tools.*

---

## 🏗️ Frameworks & Architecture
**Mandatory Default: Astro.**
Astro is the undisputed king for 95% of Awwwards-caliber sites (portfolios, landing pages, immersive scroll storytelling). 
- **Islands Architecture**: Use `client:load` or `client:visible` to hydrate heavy React/WebGL chunks while keeping the rest of the DOM blazing fast with zero JS.
- **Native Superpowers**: Always use `<ViewTransitions />` for SPA-like page morphing, `<Image />` from `astro:assets` for automatic format optimization/lazy-loading, and **Content Collections** for type-safe project data.
- **State Management**: To share state across isolated React islands in Astro, use `@nanostores/react` (or vanilla nanostores). *Never* attempt to wrap an Astro layout in a React `<Context.Provider>`—it will crash.

**The Only Escape Hatch: TanStack Start.**
Use TanStack Start *only* if the user explicitly demands a complex, state-heavy, full-stack authenticated web application or SaaS dashboard. You must use your available web search or documentation-reading tools to pull the absolute latest TanStack Start documentation before writing its code, as its syntax evolves rapidly.

*Do not use Next.js, Remix, or plain Vite.* Next.js server-component boundaries cause UI animation doom loops, and Remix's v7 router migration is chaotic. Stick to the Astro / TanStack binary.

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
- **Framer Motion (`motion/react`)**: The go-to for React interface orchestration. Ideal for gestures, `AnimatePresence` (entry/exit animations), and layout transitions. Note: The package was recently renamed to `motion/react` (formerly `framer-motion`).
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
