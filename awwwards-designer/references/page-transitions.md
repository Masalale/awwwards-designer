# Page Transitions

> **Intent:** Every route change must feel like a deliberate narrative transition — not a hard cut. The leaving page should exit with purpose; the entering page should arrive with intention. The specific tools used to achieve this are secondary to the quality of the result.

TanStack Start is a React SPA/SSR framework using TanStack Router for client-side navigation. The patterns below use GSAP as the reference implementation because it offers the most choreographic control. The same outcomes are achievable with Framer Motion, native CSS View Transitions, or any other animation library — choose based on animation map complexity and bundle budget. For simple fades, the CSS View Transitions API (zero JS) is often the right choice. For clip-path wipes, shared-element morphs, or multi-element sequences, a JS animation library integrated with TanStack Router's lifecycle hooks gives the most control.

> **Before writing any animation library integration code**, use Context7 to pull current API docs for the chosen library and TanStack Router. APIs evolve — code from memory produces subtle bugs.

---

## Root Layout Pattern

All transition logic lives in `src/routes/__root.tsx`. This is the persistent shell that wraps every page. The `<Outlet />` renders the current route's component.

```tsx
// src/routes/__root.tsx
import { createRootRoute, Outlet, useRouterState } from '@tanstack/react-router'
import { useLayoutEffect, useRef } from 'react'
import gsap from 'gsap'
import { ScrollTrigger } from 'gsap/ScrollTrigger'

gsap.registerPlugin(ScrollTrigger)

function RootLayout() {
  const containerRef = useRef<HTMLDivElement>(null)
  const overlayRef = useRef<HTMLDivElement>(null)
  const { location } = useRouterState()
  const ctx = useRef<gsap.Context | null>(null)

  useLayoutEffect(() => {
    // Kill all ScrollTrigger instances from the previous page
    ScrollTrigger.getAll().forEach(t => t.kill())

    // Scroll to top on every route change
    window.scrollTo(0, 0)

    // Enter animation for new page
    ctx.current = gsap.context(() => {
      gsap.from(containerRef.current, {
        opacity: 0,
        y: 24,
        duration: 0.6,
        ease: 'power3.out',
        clearProps: 'all',
      })
    })

    // Refresh ScrollTrigger after new DOM is rendered
    ScrollTrigger.refresh()

    return () => {
      ctx.current?.revert()
    }
  }, [location.pathname])

  return (
    <>
      {/* Persistent elements — rendered outside the animated container */}
      <nav className="site-nav" id="persistent-nav">
        {/* Navigation content — persists across all route changes */}
      </nav>

      {/* Transition overlay — used for wipe effects (see clip-path wipe below) */}
      <div
        ref={overlayRef}
        id="transition-overlay"
        style={{
          position: 'fixed',
          inset: 0,
          zIndex: 9999,
          pointerEvents: 'none',
          display: 'none',
          background: 'var(--color-bg-primary)',
        }}
      />

      {/* Animated page container */}
      <div ref={containerRef} id="page-container">
        <Outlet />
      </div>
    </>
  )
}

export const Route = createRootRoute({
  component: RootLayout,
})
```

---

## Leave Animation (Exit Before Navigation)

TanStack Router navigates instantly. To play a leave animation *before* the route changes, intercept navigation with a custom hook. Use this on `<Link>` components or programmatic navigation calls.

```tsx
// hooks/useAnimatedNavigation.ts
import { useRouter } from '@tanstack/react-router'
import gsap from 'gsap'

export function useAnimatedNavigation() {
  const router = useRouter()

  async function navigate(to: string) {
    // Leave animation — exits the current page
    await gsap.to('#page-container', {
      opacity: 0,
      y: -16,
      duration: 0.3,
      ease: 'power2.in',
    })

    // Navigate — root layout's useLayoutEffect will run the enter animation
    router.navigate({ to })
  }

  return navigate
}
```

```tsx
// Usage in a component
import { useAnimatedNavigation } from '~/hooks/useAnimatedNavigation'

function WorkGrid() {
  const navigate = useAnimatedNavigation()

  return (
    <button onClick={() => navigate('/work/project-id')}>
      View Project
    </button>
  )
}
```

---

## Clip-Path Wipe (Most Common SOTD Pattern)

A full-screen overlay sweeps across covering the old page, then reveals the new one.

```tsx
// In RootLayout's useLayoutEffect
useLayoutEffect(() => {
  const overlay = overlayRef.current
  if (!overlay) return

  ScrollTrigger.getAll().forEach(t => t.kill())
  window.scrollTo(0, 0)

  const tl = gsap.timeline({ onComplete: () => ScrollTrigger.refresh() })

  tl.set(overlay, { display: 'block', clipPath: 'inset(0 100% 0 0)' })
    .to(overlay, {
      clipPath: 'inset(0 0% 0 0)',
      duration: 0.4,
      ease: 'power4.inOut',
    })
    .set(containerRef.current, { opacity: 1 })
    .to(overlay, {
      clipPath: 'inset(0 0% 0 100%)',
      duration: 0.4,
      ease: 'power4.inOut',
    })
    .set(overlay, { display: 'none' })

  return () => { tl.kill() }
}, [location.pathname])
```

---

## GSAP FLIP Shared-Element Morph

The premium technique — an element on the current page morphs into its position on the new page. Works in TanStack Start via GSAP Flip's state capture before navigation and restoration after.

```tsx
// Store Flip state in a ref accessible to both pages
// src/store/flipState.ts
import { Flip } from 'gsap/Flip'
gsap.registerPlugin(Flip)

export let capturedFlipState: ReturnType<typeof Flip.getState> | null = null

export function captureForFlip(element: Element) {
  capturedFlipState = Flip.getState(element)
}
```

```tsx
// In the work grid — capture before navigating
import { captureForFlip } from '~/store/flipState'
import { useAnimatedNavigation } from '~/hooks/useAnimatedNavigation'

function ProjectCard({ project }) {
  const navigate = useAnimatedNavigation()
  const thumbRef = useRef(null)

  async function handleClick() {
    captureForFlip(thumbRef.current) // capture position before nav
    navigate(`/work/${project.slug}`)
  }

  return (
    <div onClick={handleClick}>
      <img ref={thumbRef} src={project.thumb} data-flip-id={project.slug} />
    </div>
  )
}
```

```tsx
// In the project detail page — apply Flip on mount
import { capturedFlipState } from '~/store/flipState'
import { Flip } from 'gsap/Flip'

function ProjectDetail() {
  const heroRef = useRef(null)

  useLayoutEffect(() => {
    if (!capturedFlipState || !heroRef.current) return

    Flip.from(capturedFlipState, {
      targets: heroRef.current,
      duration: 0.9,
      ease: 'power3.inOut',
      absolute: true,
    })

    capturedFlipState = null // consume and clear
  }, [])

  return <img ref={heroRef} src={project.hero} data-flip-id={project.slug} />
}
```

---

## Lenis Reinitialization on Route Change

Lenis creates a virtual scroll container bound to the DOM. When TanStack Router replaces the route component, the previous scroll context may be stale. Reinitialize in the root layout's `useLayoutEffect`.

```tsx
// In RootLayout
import Lenis from 'lenis'

const lenisRef = useRef<Lenis | null>(null)

useLayoutEffect(() => {
  // Destroy previous Lenis instance
  if (lenisRef.current) {
    lenisRef.current.destroy()
    gsap.ticker.remove(lenisRaf)
  }

  // Create fresh Lenis instance
  lenisRef.current = new Lenis({
    duration: 1.2,
    easing: (t) => Math.min(1, 1.001 - Math.pow(2, -10 * t)),
    smoothTouch: false, // HARD STOP — never true
    syncTouch: false,
  })

  function lenisRaf(time: number) {
    lenisRef.current?.raf(time * 1000)
  }

  gsap.ticker.add(lenisRaf)
  gsap.ticker.lagSmoothing(0)
  lenisRef.current.on('scroll', ScrollTrigger.update)

  // Kill and refresh ScrollTrigger
  ScrollTrigger.getAll().forEach(t => t.kill())
  ScrollTrigger.refresh()

  return () => {
    gsap.ticker.remove(lenisRaf)
  }
}, [location.pathname])
```

---

## Route-Specific Transitions

Different routes can use different transition styles. Branch inside `useLayoutEffect` based on `location.pathname`.

```tsx
useLayoutEffect(() => {
  ScrollTrigger.getAll().forEach(t => t.kill())
  window.scrollTo(0, 0)

  // Choose transition based on destination route
  if (location.pathname.startsWith('/work/')) {
    // Project detail: FLIP or scale-up
    playProjectEnterTransition(containerRef.current)
  } else if (location.pathname === '/') {
    // Home: full wipe
    playWipeTransition(overlayRef.current, containerRef.current)
  } else {
    // Default: fade
    gsap.from(containerRef.current, { opacity: 0, duration: 0.5, ease: 'power3.out' })
  }

  ScrollTrigger.refresh()

  return () => { ctx.current?.revert() }
}, [location.pathname])
```

---

## Native CSS View Transitions (Lightest Option)

For Tier 1 or performance-critical builds, use the browser-native View Transitions API. Zero JavaScript animation library required.

```tsx
// src/router.ts — enable in router config
import { createRouter } from '@tanstack/react-router'
import { routeTree } from './routeTree.gen'

export const router = createRouter({
  routeTree,
  defaultViewTransition: true,  // enables View Transitions API on every navigation
})
```

```css
/* Define transition animations */
::view-transition-old(root) {
  animation: 300ms cubic-bezier(0.65, 0, 0.35, 1) both fade-out;
}

::view-transition-new(root) {
  animation: 500ms cubic-bezier(0.16, 1, 0.3, 1) both fade-in;
}

@keyframes fade-out {
  from { opacity: 1; transform: translateY(0); }
  to   { opacity: 0; transform: translateY(-16px); }
}

@keyframes fade-in {
  from { opacity: 0; transform: translateY(24px); }
  to   { opacity: 1; transform: translateY(0); }
}
```

---

## Checklist: Page Transitions (TanStack Start)

- [ ] All transition logic in `__root.tsx` `useLayoutEffect` keyed on `location.pathname`
- [ ] All scroll trigger instances killed at start of every route change
- [ ] `window.scrollTo(0, 0)` on every route change
- [ ] Scroll triggers refreshed after new page content renders
- [ ] Smooth scroll instance destroyed and reinitialized on route change (if used)
- [ ] Animation context scoped and reverted on cleanup (e.g. `gsap.context()`, Framer `AnimatePresence`)
- [ ] Transition overlay element rendered outside `<Outlet />` for wipe effects
- [ ] Navigation and persistent elements in root layout, outside `<Outlet />`
- [ ] Leave animation implemented before navigation where needed
- [ ] At least 2 transition variants (default + one route-specific)
- [ ] `prefers-reduced-motion` respected — skip JS animation if `window.matchMedia('(prefers-reduced-motion: reduce)').matches`
- [ ] Tested with browser back/forward buttons
- [ ] No memory leaks after 10+ navigations (check DevTools Performance tab)
