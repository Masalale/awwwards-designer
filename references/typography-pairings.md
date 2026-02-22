# Typography Pairings

Distinctive font combinations that elevate design beyond the generic.

---

## Display + Body Pairings

### 1. Brutalist Impact
| Role | Font | Weight | Use Case |
|------|------|--------|----------|
| Display | **Space Grotesk** | 700 | Headlines, hero text |
| Body | **IBM Plex Mono** | 400 | Body text, captions |
| Accent | **Space Grotesk** | 500 | UI elements |

```css
@import url('https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500&family=Space+Grotesk:wght@500;700&display=swap');

:root {
  --font-display: 'Space Grotesk', sans-serif;
  --font-body: 'IBM Plex Mono', monospace;
}
```

**Personality:** Technical, raw, unpolished elegance. Perfect for developer tools, creative agencies, portfolios.

---

### 2. Editorial Luxury
| Role | Font | Weight | Use Case |
|------|------|--------|----------|
| Display | **Playfair Display** | 700 | Headlines, quotes |
| Body | **Source Sans Pro** | 400 | Body text |
| Accent | **Playfair Display** | 400 italic | Pull quotes |

```css
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;1,400&family=Source+Sans+3:wght@400;600&display=swap');

:root {
  --font-display: 'Playfair Display', serif;
  --font-body: 'Source Sans 3', sans-serif;
}
```

**Personality:** Magazine-quality, refined, intellectual. Perfect for publishing, luxury brands, thought leadership.

---

### 3. Modern Geometric
| Role | Font | Weight | Use Case |
|------|------|--------|----------|
| Display | **Clash Display** | 600 | Headlines |
| Body | **Satoshi** | 400 | Body text |

```css
/* Fontshare fonts */
@import url('https://api.fontshare.com/v2/css?f[]=clash-display@600,700&f[]=satoshi@400,500&display=swap');

:root {
  --font-display: 'Clash Display', sans-serif;
  --font-body: 'Satoshi', sans-serif;
}
```

**Personality:** Bold, contemporary, confident. Perfect for startups, tech products, fashion.

---

### 4. Organic Humanist
| Role | Font | Weight | Use Case |
|------|------|--------|----------|
| Display | **Zodiak** | 700 | Headlines |
| Body | **General Sans** | 400 | Body text |

```css
/* Fontshare fonts */
@import url('https://api.fontshare.com/v2/css?f[]=zodiak@700,800&f[]=general-sans@400,500&display=swap');

:root {
  --font-display: 'Zodiak', serif;
  --font-body: 'General Sans', sans-serif;
}
```

**Personality:** Warm, approachable, artisanal. Perfect for wellness, sustainability, lifestyle brands.

---

### 5. Retro-Futurist
| Role | Font | Weight | Use Case |
|------|------|--------|----------|
| Display | **Neue Machina** | 700 | Headlines |
| Body | **Inter** | 400 | Body text |

```css
/* Fontshare fonts */
@import url('https://api.fontshare.com/v2/css?f[]=neue-machina@700&f[]=inter@400,500&display=swap');

:root {
  --font-display: 'Neue Machina', sans-serif;
  --font-body: 'Inter', sans-serif;
}
```

**Personality:** Mechanical, precise, nostalgic tech. Perfect for gaming, crypto, tech products.

---

### 6. Refined Minimal
| Role | Font | Weight | Use Case |
|------|------|--------|----------|
| Display | **Boska** | 700 | Headlines |
| Body | **Switzer** | 400 | Body text |

```css
/* Fontshare fonts */
@import url('https://api.fontshare.com/v2/css?f[]=boska@700&f[]=switzer@400,500&display=swap');

:root {
  --font-display: 'Boska', serif;
  --font-body: 'Switzer', sans-serif;
}
```

**Personality:** Understated luxury, quiet confidence. Perfect for high-end products, architecture, fashion.

---

## Variable Fonts (Performance + Flexibility)

### Recommended Variable Fonts

| Font | Axes | Use Case |
|------|------|----------|
| **Inter** | wght 100-900 | UI, body text (the one acceptable "safe" choice) |
| **Manrope** | wght 200-800 | Headlines, versatile |
| **Outfit** | wght 100-900 | Geometric, modern |
| **Plus Jakarta Sans** | wght 200-800 | Friendly, approachable |

```css
@import url('https://fonts.googleapis.com/css2?family=Manrope:wght@200..800&display=swap');

/* Fluid weight based on viewport */
.fluid-headline {
  font-family: 'Manrope', sans-serif;
  font-weight: clamp(400, 8vw, 800);
}
```

---

## Typography Scale

### Hadnoir Type Scale (Φ-based)

```css
:root {
  /* Base: 16px = 1rem */
  --text-xs: clamp(0.64rem, 0.05vw + 0.63rem, 0.68rem);   /* 10-11px */
  --text-sm: clamp(0.8rem, 0.17vw + 0.76rem, 0.94rem);    /* 13-15px */
  --text-base: clamp(1rem, 0.34vw + 0.91rem, 1.25rem);    /* 16-20px */
  --text-lg: clamp(1.25rem, 0.61vw + 1.1rem, 1.67rem);    /* 20-27px */
  --text-xl: clamp(1.56rem, 1vw + 1.31rem, 2.22rem);      /* 25-36px */
  --text-2xl: clamp(1.95rem, 1.56vw + 1.56rem, 2.96rem);  /* 31-47px */
  --text-3xl: clamp(2.44rem, 2.38vw + 1.85rem, 3.95rem);  /* 39-63px */
  --text-4xl: clamp(3.05rem, 3.54vw + 2.17rem, 5.26rem);  /* 49-84px */
  --text-5xl: clamp(3.81rem, 5.18vw + 2.52rem, 7.01rem);  /* 61-112px */
  --text-6xl: clamp(4.77rem, 7.48vw + 2.9rem, 9.35rem);   /* 76-150px */
}
```

### Line Heights

```css
:root {
  --leading-tight: 0.85;   /* Display headlines */
  --leading-snug: 1.0;     /* Large headlines */
  --leading-normal: 1.5;   /* Body text */
  --leading-relaxed: 1.75; /* Long-form reading */
}
```

### Letter Spacing

```css
:root {
  --tracking-tight: -0.05em;    /* Large headlines */
  --tracking-normal: 0;         /* Body text */
  --tracking-wide: 0.05em;      /* Small caps, labels */
  --tracking-wider: 0.1em;      /* All-caps text */
  --tracking-widest: 0.2em;     /* Micro labels */
}
```

---

## Typographic Treatments

### Oversized Display
```css
.hero-headline {
  font-family: var(--font-display);
  font-size: var(--text-6xl);
  line-height: var(--leading-tight);
  letter-spacing: var(--tracking-tight);
  text-transform: uppercase;
}
```

### Editorial Pull Quote
```css
.pull-quote {
  font-family: var(--font-display);
  font-size: var(--text-2xl);
  line-height: var(--leading-snug);
  font-style: italic;
  border-left: 2px solid var(--color-accent);
  padding-left: var(--space-md);
}
```

### Technical Label
```css
.label {
  font-family: var(--font-body);
  font-size: var(--text-xs);
  letter-spacing: var(--tracking-widest);
  text-transform: uppercase;
  font-weight: 500;
}
```

### Fluid Typography
```css
.fluid-hero {
  font-size: clamp(3rem, 12vw, 10rem);
  line-height: 0.85;
  letter-spacing: -0.04em;
}
```

---

## Anti-Patterns (Never Do)

| Pattern | Why | Instead |
|---------|-----|---------|
| Inter for headlines | Overused, boring | Any distinctive display font |
| More than 2 fonts | Chaotic | Max 2: 1 display + 1 body |
| Thin font weights (100-200) | Illegible, weak | 400+ for body, 600+ for display |
| System fonts as primary | No personality | Load distinctive web fonts |
| Tight line-height on body | Unreadable | 1.5-1.75 for body text |
| Center-aligned long text | Hard to read | Left-align body, center short headlines |

---

## Font Loading Strategy

```html
<!-- Preconnect to Google Fonts -->
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

<!-- Preload critical fonts -->
<link rel="preload" href="https://fonts.gstatic.com/s/spacegrotesk/v16/V8mQoQDjQSkFtoMM3T6r8E7mF71Q-gOoraIAEj7oUXskPMBBSSJLm2E.woff2" as="font" type="font/woff2" crossorigin>

<!-- Async load rest -->
<link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@500;700&family=IBM+Plex+Mono:wght@400;500&display=swap" rel="stylesheet">
```

```css
/* Font display swap for fast initial render */
@import url('...&display=swap');
```
