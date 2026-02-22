# Styling Frameworks

Deep guidance for Tailwind CSS, CSS-in-JS, and styling architecture.

---

## Styling Decision Matrix

| Framework | Best For | Bundle Impact | Learning Curve |
|-----------|----------|---------------|----------------|
| **Tailwind CSS** | Rapid development, design systems, consistency | ~10kb (purged) | Medium |
| **CSS Modules** | Component scoping, zero runtime | 0kb | Low |
| **Styled Components** | Dynamic styles, theming | ~12kb | Medium |
| **Emotion** | Performance, CSS prop, theming | ~7kb | Medium |
| **Panda CSS** | Type-safe, CSS-in-JS without runtime | 0kb (atomic) | Medium |
| **vanilla-extract** | Type-safe CSS, zero runtime | 0kb | Medium |
| **PostCSS + CSS** | Maximum control, no abstractions | 0kb | Low |

**Default recommendation:** Tailwind CSS for most projects.

---

## Tailwind CSS — Deep Patterns

### Configuration Strategy

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';

const config: Config = {
  content: [
    './pages/**/*.{js,ts,jsx,tsx,mdx}',
    './components/**/*.{js,ts,jsx,tsx,mdx}',
    './app/**/*.{js,ts,jsx,tsx,mdx}',
  ],
  theme: {
    extend: {
      // Hadnoir DNA — Mathematical spacing (Φ-based)
      spacing: {
        'xs': '0.382rem',      // 1/Φ²
        'sm': '0.618rem',      // 1/Φ
        'base': '1rem',
        'md': '1.618rem',      // Φ
        'lg': '2.618rem',      // Φ²
        'xl': '4.236rem',      // Φ³
        '2xl': '6.854rem',     // Φ⁴
        '3xl': '11.09rem',     // Φ⁵
      },
      
      // Typography scale
      fontSize: {
        'xs': ['clamp(0.64rem, 0.05vw + 0.63rem, 0.68rem)', { lineHeight: '1.4' }],
        'sm': ['clamp(0.8rem, 0.17vw + 0.76rem, 0.94rem)', { lineHeight: '1.5' }],
        'base': ['clamp(1rem, 0.34vw + 0.91rem, 1.25rem)', { lineHeight: '1.6' }],
        'lg': ['clamp(1.25rem, 0.61vw + 1.1rem, 1.67rem)', { lineHeight: '1.5' }],
        'xl': ['clamp(1.56rem, 1vw + 1.31rem, 2.22rem)', { lineHeight: '1.3' }],
        '2xl': ['clamp(1.95rem, 1.56vw + 1.56rem, 2.96rem)', { lineHeight: '1.2' }],
        '3xl': ['clamp(2.44rem, 2.38vw + 1.85rem, 3.95rem)', { lineHeight: '1.1' }],
        '4xl': ['clamp(3.05rem, 3.54vw + 2.17rem, 5.26rem)', { lineHeight: '0.95' }],
      },
      
      // Custom easing curves
      transitionTimingFunction: {
        'expo-out': 'cubic-bezier(0.16, 1, 0.3, 1)',
        'expo-in': 'cubic-bezier(0.7, 0, 0.84, 0)',
        'elastic': 'cubic-bezier(0.68, -0.55, 0.265, 1.55)',
        'smooth': 'cubic-bezier(0.4, 0, 0.2, 1)',
        'dramatic': 'cubic-bezier(0.87, 0, 0.13, 1)',
      },
      
      // Animation keyframes
      keyframes: {
        'fade-up': {
          '0%': { opacity: '0', transform: 'translateY(20px)' },
          '100%': { opacity: '1', transform: 'translateY(0)' },
        },
        'fade-in': {
          '0%': { opacity: '0' },
          '100%': { opacity: '1' },
        },
        'scale-in': {
          '0%': { opacity: '0', transform: 'scale(0.95)' },
          '100%': { opacity: '1', transform: 'scale(1)' },
        },
      },
      animation: {
        'fade-up': 'fade-up 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards',
        'fade-in': 'fade-in 0.4s ease-out forwards',
        'scale-in': 'scale-in 0.3s cubic-bezier(0.16, 1, 0.3, 1) forwards',
      },
      
      // Font families
      fontFamily: {
        display: ['var(--font-display)', 'serif'],
        body: ['var(--font-body)', 'sans-serif'],
        mono: ['var(--font-mono)', 'monospace'],
      },
    },
  },
  plugins: [
    require('@tailwindcss/typography'),
    require('@tailwindcss/forms'),
    require('@tailwindcss/container-queries'),
  ],
};

export default config;
```

### CSS Variables Integration

```css
/* globals.css */
@tailwind base;
@tailwind components;
@tailwind utilities;

@layer base {
  :root {
    /* Brand colors */
    --color-primary: 220 65% 50%;
    --color-secondary: 250 60% 55%;
    --color-accent: 40 90% 60%;
    
    /* Surface colors */
    --color-background: 220 20% 95%;
    --color-surface: 220 15% 100%;
    
    /* Text colors */
    --color-text: 220 30% 10%;
    --color-text-muted: 220 20% 45%;
    
    /* Font families (set by next/font or imported) */
    --font-display: 'Space Grotesk';
    --font-body: 'IBM Plex Mono';
    --font-mono: 'IBM Plex Mono';
  }
  
  [data-theme="dark"] {
    --color-background: 220 30% 8%;
    --color-surface: 220 25% 12%;
    --color-text: 220 20% 95%;
    --color-text-muted: 220 15% 60%;
  }
}

@layer utilities {
  /* Grain texture overlay */
  .texture-grain {
    position: relative;
  }
  .texture-grain::before {
    content: '';
    position: absolute;
    inset: 0;
    background-image: url("data:image/svg+xml,...");
    opacity: 0.03;
    pointer-events: none;
  }
  
  /* Text balance for headings */
  .text-balance {
    text-wrap: balance;
  }
  
  /* Tabular numbers */
  .tabular-nums {
    font-variant-numeric: tabular-nums;
  }
}
```

### Component Patterns

```tsx
// Primitive component with variants
interface ButtonProps {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  children: React.ReactNode;
}

export function Button({ 
  variant = 'primary', 
  size = 'md',
  children 
}: ButtonProps) {
  const baseStyles = 'inline-flex items-center justify-center font-medium transition-all duration-200 ease-expo-out';
  
  const variants = {
    primary: 'bg-primary text-white hover:bg-primary/90 active:scale-95',
    secondary: 'bg-surface text-text border border-border hover:bg-surface/80',
    ghost: 'text-text hover:bg-surface/50',
  };
  
  const sizes = {
    sm: 'px-xs py-1.5 text-sm rounded-sm',
    md: 'px-sm py-2 text-base rounded-md',
    lg: 'px-md py-3 text-lg rounded-lg',
  };
  
  return (
    <button className={cn(baseStyles, variants[variant], sizes[size])}>
      {children}
    </button>
  );
}

// Utility for class merging
import { clsx, type ClassValue } from 'clsx';
import { twMerge } from 'tailwind-merge';

export function cn(...inputs: ClassValue[]) {
  return twMerge(clsx(inputs));
}
```

### Responsive Patterns

```tsx
// Mobile-first approach (Tailwind default)
function Hero() {
  return (
    <div className="
      /* Base (mobile) */
      px-sm py-lg
      /* sm: 640px+ */
      sm:px-md sm:py-xl
      /* md: 768px+ */
      md:px-lg md:py-2xl
      /* lg: 1024px+ */
      lg:px-xl
      /* xl: 1280px+ */
      xl:px-2xl
    ">
      <h1 className="
        text-2xl leading-tight
        md:text-3xl
        lg:text-4xl
        xl:text-5xl
      ">
        Responsive heading
      </h1>
    </div>
  );
}
```

### Container Query Patterns

```tsx
// Using @tailwindcss/container-queries
function Card() {
  return (
    <div className="@container">
      <div className="
        /* Default */
        grid-cols-1
        /* Container is 400px+ */
        @sm:grid-cols-2
        /* Container is 600px+ */
        @lg:grid-cols-3
      ">
        {/* Content */}
      </div>
    </div>
  );
}
```

---

## CSS-in-JS Patterns (Styled Components / Emotion)

### When to Use
- Complex dynamic styles based on props
- Theme switching with deep component integration
- Component libraries requiring style encapsulation

### Styled Components Example

```tsx
// styles.ts
import styled, { css } from 'styled-components';

const buttonVariants = {
  primary: css`
    background: ${props => props.theme.colors.primary};
    color: white;
    
    &:hover {
      background: ${props => props.theme.colors.primaryDark};
    }
  `,
  secondary: css`
    background: transparent;
    border: 1px solid ${props => props.theme.colors.border};
    color: ${props => props.theme.colors.text};
  `,
};

export const Button = styled.button<{ variant?: keyof typeof buttonVariants }>`
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: ${props => props.theme.spacing.sm} ${props => props.theme.spacing.md};
  font-family: ${props => props.theme.fonts.body};
  font-weight: 500;
  border-radius: ${props => props.theme.radii.md};
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
  
  &:active {
    transform: scale(0.98);
  }
  
  ${props => buttonVariants[props.variant || 'primary']}
`;
```

### Emotion CSS Prop

```tsx
/** @jsxImportSource @emotion/react */
import { css } from '@emotion/react';

const buttonStyles = css`
  display: inline-flex;
  padding: 1rem 2rem;
  background: hsl(var(--color-primary));
  transition: transform 0.2s ease;
  
  &:hover {
    transform: scale(1.02);
  }
`;

function Button() {
  return <button css={buttonStyles}>Click me</button>;
}
```

---

## Panda CSS (Type-Safe Atomic)

### Setup

```typescript
// panda.config.ts
import { defineConfig } from '@pandacss/dev';

export default defineConfig({
  preflight: true,
  include: ['./src/**/*.{tsx,jsx}'],
  exclude: [],
  theme: {
    extend: {
      tokens: {
        colors: {
          primary: { value: 'hsl(220, 65%, 50%)' },
          background: { value: 'hsl(220, 20%, 95%)' },
        },
        spacing: {
          xs: { value: '0.382rem' },
          sm: { value: '0.618rem' },
          md: { value: '1.618rem' },
        },
      },
    },
  },
  outdir: 'styled-system',
});
```

### Usage

```tsx
import { css } from '../styled-system/css';
import { stack } from '../styled-system/patterns';

function Component() {
  return (
    <div className={stack({ gap: 'md', direction: 'column' })}>
      <h1 className={css({ 
        fontSize: '4xl', 
        fontWeight: 'bold',
        color: 'primary'
      })}>
        Heading
      </h1>
    </div>
  );
}
```

---

## vanilla-extract (Zero Runtime)

### Setup

```typescript
// styles.css.ts
import { style, createTheme } from '@vanilla-extract/css';

export const [themeClass, vars] = createTheme({
  color: {
    primary: 'hsl(220, 65%, 50%)',
    background: 'hsl(220, 20%, 95%)',
  },
  spacing: {
    sm: '0.618rem',
    md: '1.618rem',
  },
});

export const button = style({
  display: 'inline-flex',
  padding: `${vars.spacing.sm} ${vars.spacing.md}`,
  background: vars.color.primary,
  transition: 'transform 0.2s ease',
  
  ':hover': {
    transform: 'scale(1.02)',
  },
});
```

---

## Styling Anti-Patterns

| Pattern | Problem | Solution |
|---------|---------|----------|
| `!important` in Tailwind | Breaks specificity | Use proper class ordering |
| Arbitrary values everywhere | Breaks design system | Extend config properly |
| Inline styles for everything | No consistency | Use component abstractions |
| Deep nesting in CSS | Hard to maintain | Flat BEM or utility classes |
| Mixing Tailwind + CSS-in-JS | Confusion, bloat | Pick one approach per project |

---

## Performance Best Practices

### Tailwind
- Use `@apply` sparingly (prefer components)
- Purge unused styles in production
- Use `content` config to scan all files
- Minimize arbitrary values

### CSS-in-JS
- Use SSR-compatible libraries
- Avoid dynamic style generation in render
- Consider zero-runtime alternatives (Panda, vanilla-extract)

### General
- Preload critical fonts
- Inline critical CSS
- Lazy-load non-critical styles
- Use `will-change` sparingly

---

## shadcn/ui — Component Architecture

### What is shadcn/ui?

Not a component library — a **collection of reusable components** you copy into your project. Full control, zero dependency lock-in.

### When to Use

| Use shadcn/ui | Don't Use |
|---------------|-----------|
| Need accessible, polished primitives | Want fully custom component APIs |
| Building a design system | Need every component to be bespoke |
| Rapid MVP development | Have strict visual requirements |

### Installation

```bash
# Initialize in project
npx shadcn-ui@latest init

# Add components as needed
npx shadcn-ui@latest add button
npx shadcn-ui@latest add dialog card tabs
```

### Architecture

```
components/
├── ui/                    # shadcn primitives (don't edit)
│   ├── button.tsx
│   ├── dialog.tsx
│   ├── card.tsx
│   └── ...
├── shared/                # Your wrapped versions
│   ├── Button.tsx         # Branded wrapper
│   ├── Dialog.tsx
│   └── ...
└── features/              # Feature-specific composites
    ├── UserCard.tsx
    └── ...
```

### Component Pattern: Branded Wrapper

```tsx
// components/shared/Button.tsx
import { Button as ShadcnButton } from '@/components/ui/button';
import { cn } from '@/lib/utils';
import { cva, type VariantProps } from 'class-variance-authority';

// Extend shadcn with Hadnoir DNA styling
const buttonVariants = cva(
  // Base styles
  'inline-flex items-center justify-center font-medium transition-all duration-200',
  {
    variants: {
      variant: {
        // Hadnoir-styled variants
        primary: 'bg-primary text-primary-foreground hover:bg-primary/90',
        secondary: 'bg-secondary text-secondary-foreground hover:bg-secondary/80',
        ghost: 'hover:bg-accent hover:text-accent-foreground',
        outline: 'border border-input bg-background hover:bg-accent',
      },
      size: {
        sm: 'h-9 px-xs rounded-sm text-sm',
        md: 'h-11 px-sm rounded-md text-base',
        lg: 'h-14 px-md rounded-lg text-lg',
      },
    },
    defaultVariants: {
      variant: 'primary',
      size: 'md',
    },
  }
);

interface ButtonProps
  extends React.ButtonHTMLAttributes<HTMLButtonElement>,
    VariantProps<typeof buttonVariants> {}

export function Button({ className, variant, size, ...props }: ButtonProps) {
  return (
    <ShadcnButton
      className={cn(buttonVariants({ variant, size }), className)}
      {...props}
    />
  );
}
```

### Theme Customization (globals.css)

```css
@layer base {
  :root {
    /* Hadnoir DNA colors mapped to shadcn theme */
    --background: 220 20% 95%;
    --foreground: 220 30% 10%;
    
    --card: 220 15% 100%;
    --card-foreground: 220 30% 10%;
    
    --popover: 220 15% 100%;
    --popover-foreground: 220 30% 10%;
    
    /* Primary: Your brand color */
    --primary: 220 65% 50%;
    --primary-foreground: 0 0% 100%;
    
    --secondary: 220 20% 90%;
    --secondary-foreground: 220 30% 10%;
    
    --muted: 220 20% 92%;
    --muted-foreground: 220 20% 45%;
    
    --accent: 40 90% 60%;
    --accent-foreground: 220 30% 10%;
    
    --destructive: 0 70% 55%;
    --destructive-foreground: 0 0% 100%;
    
    --border: 220 20% 85%;
    --input: 220 20% 85%;
    --ring: 220 65% 50%;
    
    /* Φ-based radius */
    --radius: 0.618rem;
  }
  
  [data-theme="dark"] {
    --background: 220 30% 8%;
    --foreground: 220 20% 95%;
    --card: 220 25% 12%;
    --popover: 220 25% 12%;
    --primary: 220 65% 55%;
    --secondary: 220 20% 18%;
    --muted: 220 20% 15%;
    --accent: 40 90% 55%;
    --border: 220 20% 20%;
  }
}
```

### Component Composition Pattern

```tsx
// Build complex UIs from shadcn primitives
import { Card, CardHeader, CardTitle, CardDescription, CardContent } from '@/components/ui/card';
import { Button } from '@/components/shared/Button';
import { Badge } from '@/components/ui/badge';

function ProjectCard({ project }: { project: Project }) {
  return (
    <Card className="group overflow-hidden">
      <div className="aspect-video bg-muted relative overflow-hidden">
        <img 
          src={project.image} 
          alt={project.title}
          className="object-cover transition-transform duration-500 group-hover:scale-105"
        />
      </div>
      
      <CardHeader>
        <div className="flex items-center gap-sm mb-xs">
          <Badge variant="secondary">{project.category}</Badge>
          <span className="text-xs text-muted-foreground">{project.year}</span>
        </div>
        
        <CardTitle className="font-display text-xl leading-tight">
          {project.title}
        </CardTitle>
        
        <CardDescription className="line-clamp-2">
          {project.description}
        </CardDescription>
      </CardHeader>
      
      <CardContent className="flex gap-sm">
        <Button size="sm">View Project</Button>
        <Button variant="ghost" size="sm">Source</Button>
      </CardContent>
    </Card>
  );
}
```

### Animation Integration

```tsx
// Framer Motion + shadcn
import { motion, AnimatePresence } from 'framer-motion';
import { Dialog, DialogContent, DialogTrigger } from '@/components/ui/dialog';

function AnimatedDialog({ children, trigger }: { children: React.ReactNode; trigger: React.ReactNode }) {
  return (
    <Dialog>
      <DialogTrigger asChild>{trigger}</DialogTrigger>
      
      <DialogContent className="sm:max-w-[425px]">
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          exit={{ opacity: 0, y: 20 }}
          transition={{ ease: [0.16, 1, 0.3, 1], duration: 0.3 }}
        >
          {children}
        </motion.div>
      </DialogContent>
    </Dialog>
  );
}
```

### Form Patterns

```tsx
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';

import { Button } from '@/components/shared/Button';
import {
  Form,
  FormControl,
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from '@/components/ui/form';
import { Input } from '@/components/ui/input';

const formSchema = z.object({
  email: z.string().email('Invalid email address'),
  name: z.string().min(2, 'Name must be at least 2 characters'),
});

export function ContactForm() {
  const form = useForm<z.infer<typeof formSchema>>({
    resolver: zodResolver(formSchema),
    defaultValues: { email: '', name: '' },
  });

  function onSubmit(values: z.infer<typeof formSchema>) {
    console.log(values);
  }

  return (
    <Form {...form}>
      <form onSubmit={form.handleSubmit(onSubmit)} className="space-y-md">
        <FormField
          control={form.control}
          name="name"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Name</FormLabel>
              <FormControl>
                <Input placeholder="Your name" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <FormField
          control={form.control}
          name="email"
          render={({ field }) => (
            <FormItem>
              <FormLabel>Email</FormLabel>
              <FormControl>
                <Input type="email" placeholder="you@example.com" {...field} />
              </FormControl>
              <FormMessage />
            </FormItem>
          )}
        />
        
        <Button type="submit" className="w-full">
          Submit
        </Button>
      </form>
    </Form>
  );
}
```

### Common shadcn Components for Hadnoir Projects

| Component | Usage | Customization Notes |
|-----------|-------|---------------------|
| `button` | CTAs, actions | Add Φ-based sizing, custom easing |
| `card` | Content containers | Remove default shadows, add grain texture |
| `dialog` | Modals, overlays | Framer Motion entrance/exit |
| `dropdown-menu` | Navigation, actions | Align with brand radius |
| `tabs` | Content switching | Custom active indicator |
| `input` | Forms | Remove default ring, custom focus state |
| `textarea` | Long-form input | Match input styling |
| `badge` | Labels, tags | Pill or rounded variants |
| `separator` | Visual dividers | Gradient or branded color |
| `skeleton` | Loading states | Animate with Hadnoir timing |

### shadcn + Tailwind Config Integration

```typescript
// tailwind.config.ts
import type { Config } from 'tailwindcss';

const config: Config = {
  darkMode: ['class'],
  content: [
    './pages/**/*.{ts,tsx}',
    './components/**/*.{ts,tsx}',
    './app/**/*.{ts,tsx}',
    './src/**/*.{ts,tsx}',
  ],
  theme: {
    container: {
      center: true,
      padding: '1.618rem', // Φ-based
      screens: {
        '2xl': '1400px',
      },
    },
    extend: {
      // shadcn requires these color mappings
      colors: {
        border: 'hsl(var(--border))',
        input: 'hsl(var(--input))',
        ring: 'hsl(var(--ring))',
        background: 'hsl(var(--background))',
        foreground: 'hsl(var(--foreground))',
        primary: {
          DEFAULT: 'hsl(var(--primary))',
          foreground: 'hsl(var(--primary-foreground))',
        },
        secondary: {
          DEFAULT: 'hsl(var(--secondary))',
          foreground: 'hsl(var(--secondary-foreground))',
        },
        destructive: {
          DEFAULT: 'hsl(var(--destructive))',
          foreground: 'hsl(var(--destructive-foreground))',
        },
        muted: {
          DEFAULT: 'hsl(var(--muted))',
          foreground: 'hsl(var(--muted-foreground))',
        },
        accent: {
          DEFAULT: 'hsl(var(--accent))',
          foreground: 'hsl(var(--accent-foreground))',
        },
        popover: {
          DEFAULT: 'hsl(var(--popover))',
          foreground: 'hsl(var(--popover-foreground))',
        },
        card: {
          DEFAULT: 'hsl(var(--card))',
          foreground: 'hsl(var(--card-foreground))',
        },
      },
      borderRadius: {
        lg: 'var(--radius)',
        md: 'calc(var(--radius) - 2px)',
        sm: 'calc(var(--radius) - 4px)',
      },
      keyframes: {
        'accordion-down': {
          from: { height: '0' },
          to: { height: 'var(--radix-accordion-content-height)' },
        },
        'accordion-up': {
          from: { height: 'var(--radix-accordion-content-height)' },
          to: { height: '0' },
        },
      },
      animation: {
        'accordion-down': 'accordion-down 0.2s ease-out',
        'accordion-up': 'accordion-up 0.2s ease-out',
      },
    },
  },
  plugins: [require('tailwindcss-animate')],
};

export default config;
```

### Decision: Custom vs shadcn

| Build Custom | Use shadcn |
|--------------|------------|
| Unique visual language required | Standard patterns acceptable |
| Full control over markup | Speed of development matters |
| Learning/experimentation | Production deadline |
| Specific accessibility needs | General accessibility sufficient |

---

## Icon System — Lucide

**Default: Lucide Icons**

Lucide is the recommended icon library for all projects. It provides:
- Consistent, beautiful design language
- Tree-shakeable (only used icons included)
- Native React/Next.js support
- No emoji icons (professional standard)

### Installation

```bash
npm install lucide-react
# or
yarn add lucide-react
# or
pnpm add lucide-react
```

### Usage Patterns

```tsx
// Import specific icons (tree-shakeable)
import { ShoppingBag, Menu, X, ArrowRight, Heart } from 'lucide-react';

// Basic usage
<ShoppingBag className="w-6 h-6" />

// With sizing
<Heart className="w-5 h-5" />

// With animation
<ArrowRight className="w-4 h-4 transition-transform group-hover:translate-x-1" />

// Icon button (always with aria-label)
<button aria-label="Add to cart">
  <ShoppingBag className="w-5 h-5" />
</button>
```

### Icon Guidelines

| Rule | Do | Don't |
|------|-----|-------|
| **Size** | Use consistent sizing (w-5 h-5 default) | Mix random sizes |
| **Color** | Inherit from text color | Hardcode colors |
| **Stroke width** | Default (2) is standard | Customize per icon |
| **Accessibility** | Always use `aria-label` for icon-only buttons | Leave unlabeled |
| **Set** | Lucide only | Mix with other icon sets |

### Common Fashion Icons

```tsx
import { 
  ShoppingBag,    // Cart
  Heart,          // Wishlist/Favorite
  User,           // Account
  Menu,           // Navigation
  Search,         // Search
  X,              // Close
  ChevronRight,   // Navigation arrow
  ArrowRight,     // CTA arrow
  Instagram,      // Social
  Facebook,       // Social
  Twitter,        // Social
  Mail,           // Newsletter
  Phone,          // Contact
  MapPin,         // Location
  Star,           // Rating
  Filter,         // Product filter
  Grid3x3,        // Grid view
  List,           // List view
  Share2,         // Share
  ExternalLink    // External link
} from 'lucide-react';
```

### Forbidden (Auto-Reject)

- ❌ Emoji icons (🛒 ❤️ 👤)
- ❌ Random icon sets mixed together
- ❌ Custom SVG icons without consistency
- ❌ FontAwesome (outdated aesthetic)

### Size Scale

```css
/* Consistent icon sizing */
.icon-xs { @apply w-4 h-4; }   /* 16px - Inline */
.icon-sm { @apply w-5 h-5; }   /* 20px - Default */
.icon-md { @apply w-6 h-6; }   /* 24px - Buttons */
.icon-lg { @apply w-8 h-8; }   /* 32px - Featured */
```
