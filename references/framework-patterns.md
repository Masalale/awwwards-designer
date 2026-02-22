# Framework Patterns

Framework-aware, not framework-locked. Adapt these patterns based on the chosen stack.

---

## Framework Decision Matrix

| Choose | When | Avoid When |
|--------|------|------------|
| **Next.js** | SEO-critical, complex apps, React ecosystem | Simple static sites (overkill) |
| **Astro** | Content-heavy, fast static, multi-page | Heavy interactivity needed |
| **TanStack Start** | Full-stack React, type-safe APIs, file routing | Need mature ecosystem |
| **Remix** | Forms-heavy, nested routing, web standards | Need edge/Node flexibility |
| **Vite + React** | SPAs, rapid prototyping, flexibility | SEO requirements |

---

## Next.js App Router

### Architecture Patterns

```typescript
// app/layout.tsx — Root layout with providers
export default function RootLayout({ children }) {
  return (
    <html lang="en" className={inter.variable}>
      <body>
        <DesignProvider>
          <Navigation />
          {children}
          <Footer />
        </DesignProvider>
      </body>
    </html>
  );
}
```

```typescript
// app/page.tsx — Server Component by default
import { Hero } from '@/components/Hero';
import { getContent } from '@/lib/content';

// Data fetching in Server Component
export default async function HomePage() {
  const content = await getContent();
  
  return (
    <main>
      <Hero data={content.hero} />
      <Features />
    </main>
  );
}
```

```typescript
// components/InteractiveWidget.tsx — Client Component
'use client';

import { motion } from 'framer-motion';

export function InteractiveWidget() {
  // Client-side interactivity
  return (
    <motion.div
      whileHover={{ scale: 1.02 }}
      whileTap={{ scale: 0.98 }}
    >
      {/* Interactive content */}
    </motion.div>
  );
}
```

### Animation with Next.js

```typescript
// For scroll animations, use GSAP in useEffect
'use client';

import { useEffect, useRef } from 'react';
import gsap from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

gsap.registerPlugin(ScrollTrigger);

export function ScrollSection() {
  const sectionRef = useRef(null);
  
  useEffect(() => {
    const ctx = gsap.context(() => {
      gsap.from('.reveal-item', {
        y: 100,
        opacity: 0,
        stagger: 0.1,
        scrollTrigger: {
          trigger: sectionRef.current,
          start: 'top 80%',
          toggleActions: 'play none none reverse'
        }
      });
    }, sectionRef);
    
    return () => ctx.revert();
  }, []);
  
  return (
    <section ref={sectionRef}>
      <div className="reveal-item">...</div>
      <div className="reveal-item">...</div>
    </section>
  );
}
```

### Critical Rules
- Keep Server Components default — only 'use client' when needed
- Use `next/image` with explicit width/height
- Use `next/font` for optimal font loading
- Server Actions for form mutations
- Parallel data fetching with `Promise.all`

---

## Astro

### Islands Architecture

```astro
---
// pages/index.astro — Server-rendered by default
import Layout from '../layouts/Layout.astro';
import Hero from '../components/Hero.astro';
import InteractiveCounter from '../components/InteractiveCounter.jsx';

const content = await fetch('https://api.example.com/content').then(r => r.json());
---

<Layout>
  <!-- Static, server-rendered -->
  <Hero content={content.hero} />
  
  <!-- Hydrated island (only this component ships JS) -->
  <InteractiveCounter client:visible />
  
  <!-- Other client directives:
    client:load — hydrate immediately
    client:visible — hydrate when visible
    client:media="(min-width: 768px)" — hydrate on media query
    client:only="react" — client-only, no SSR
  -->
</Layout>
```

### Content Collections

```typescript
// content/config.ts
import { defineCollection, z } from 'astro:content';

const projectsCollection = defineCollection({
  schema: z.object({
    title: z.string(),
    description: z.string(),
    publishDate: z.date(),
    tags: z.array(z.string()),
    featured: z.boolean().default(false)
  })
});

export const collections = {
  projects: projectsCollection
};
```

### Critical Rules
- Use `client:*` directives sparingly — every island adds JS
- Content collections for structured data
- Image optimization with `astro:assets`
- View Transitions API for page transitions

---

## TanStack Start

### File-Based Routing

```typescript
// app/routes/__root.tsx — Root layout
import { Outlet, createRootRoute } from '@tanstack/react-router';

export const Route = createRootRoute({
  component: RootComponent
});

function RootComponent() {
  return (
    <div>
      <Navigation />
      <Outlet />
    </div>
  );
}
```

```typescript
// app/routes/index.tsx — Home route
import { createFileRoute } from '@tanstack/react-router';

export const Route = createFileRoute('/')({
  component: HomeComponent,
  loader: async () => {
    // Server-side data fetching
    return { content: await fetchContent() };
  }
});

function HomeComponent() {
  const { content } = Route.useLoaderData();
  return <Hero content={content} />;
}
```

### Server Functions

```typescript
// app/utils/content.ts
import { createServerFn } from '@tanstack/react-start';

export const getProjects = createServerFn({ method: 'GET' })
  .handler(async () => {
    // Server-side only
    return db.query.projects.findMany();
  });
```

---

## Remix

### Loaders and Actions

```typescript
// app/routes/_index.tsx
import { json, type LoaderFunctionArgs } from '@remix-run/node';
import { useLoaderData } from '@remix-run/react';

export async function loader({ request }: LoaderFunctionArgs) {
  const content = await getContent();
  return json({ content });
}

export default function Index() {
  const { content } = useLoaderData<typeof loader>();
  return <Hero content={content} />;
}
```

```typescript
// Forms with actions
import { type ActionFunctionArgs } from '@remix-run/node';

export async function action({ request }: ActionFunctionArgs) {
  const formData = await request.formData();
  const email = formData.get('email');
  
  // Validate and process
  await subscribeEmail(email);
  
  return json({ success: true });
}
```

### Critical Rules
- Use `useNavigation` for pending UI states
- Error boundaries for route errors
- Optimistic UI with `useFetcher`

---

## Universal Patterns (All Frameworks)

### Project Structure
```
src/
├── components/
│   ├── ui/           # Primitive components (Button, Card)
│   ├── layout/       # Layout components (Header, Footer)
│   └── features/     # Feature-specific components
├── lib/
│   ├── utils/        # Utility functions
│   ├── hooks/        # Custom React hooks
│   └── animations/   # Animation configs
├── styles/
│   ├── globals.css   # Global styles
│   ├── tokens.css    # CSS variables
│   └── animations.css # Keyframe animations
└── types/            # TypeScript types
```

### Animation Library Integration

**GSAP (All frameworks):**
```typescript
// Initialize in useEffect (React) or onMount (Svelte/Vue)
// Always cleanup with ctx.revert() or gsap.killTweensOf()
```

**Framer Motion (React only):**
```typescript
// Use for component-level animations
// AnimatePresence for enter/exit
// Layout animations for automatic layout transitions
```

**CSS Animations (Universal):**
```css
/* Prefer for simple transitions */
.element {
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}
```

### Performance Checklist
- [ ] Images optimized and sized
- [ ] Fonts preloaded/subset
- [ ] Animations use transform/opacity
- [ ] Code split by route
- [ ] Lazy load below-fold content
