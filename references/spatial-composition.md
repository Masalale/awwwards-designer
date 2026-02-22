# Spatial Composition

Unexpected layouts that break the grid and create visual tension.

---

## Grid Philosophies

### 1. The Broken Grid
Elements intentionally break out of the container.

```css
.container {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  gap: var(--space-lg);
}

.content {
  grid-column: 2 / 8;
}

.image {
  grid-column: 7 / 13; /* Overlaps content */
  margin-right: calc(-1 * var(--space-xl)); /* Breaks container */
}
```

### 2. Asymmetric Grid (Φ Ratio)
Use the Golden Ratio for column divisions.

```css
.asymmetric-grid {
  display: grid;
  grid-template-columns: 1fr 1.618fr; /* Φ ratio */
  gap: var(--space-lg);
}

.asymmetric-grid-reversed {
  display: grid;
  grid-template-columns: 1.618fr 1fr;
}
```

### 3. Modular Grid (Bento Style)
Irregular but harmonious grid cells.

```css
.bento-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  grid-template-rows: repeat(3, 200px);
  gap: var(--space-md);
}

.bento-item:nth-child(1) {
  grid-column: 1 / 3;
  grid-row: 1 / 3;
}

.bento-item:nth-child(2) {
  grid-column: 3 / 5;
}

.bento-item:nth-child(3) {
  grid-column: 3 / 4;
}

.bento-item:nth-child(4) {
  grid-column: 4 / 5;
  grid-row: 2 / 4;
}
```

### 4. Diagonal Flow
Content flows at an angle.

```css
.diagonal-section {
  position: relative;
  clip-path: polygon(0 5%, 100% 0, 100% 95%, 0 100%);
  background: var(--color-surface);
  padding: var(--space-3xl) 0;
}

.diagonal-content {
  transform: skewY(-2deg);
}

.diagonal-content > * {
  transform: skewY(2deg); /* Counter-skew content */
}
```

---

## Overlap Techniques

### Layered Composition

```css
.layered-container {
  display: grid;
  grid-template-columns: 1fr;
  grid-template-rows: 1fr;
}

.layered-container > * {
  grid-column: 1;
  grid-row: 1;
}

.background-layer {
  z-index: 1;
}

.content-layer {
  z-index: 2;
  margin-top: var(--space-xl);
  margin-left: var(--space-xl);
}

.foreground-layer {
  z-index: 3;
  justify-self: end;
  align-self: end;
  margin-right: calc(-1 * var(--space-lg));
}
```

### Bleed Elements

```css
.bleed-left {
  margin-left: calc(-1 * var(--space-xl));
}

.bleed-right {
  margin-right: calc(-1 * var(--space-xl));
}

.bleed-full {
  width: 100vw;
  margin-left: calc(50% - 50vw);
  margin-right: calc(50% - 50vw);
}
```

---

## Visual Tension

### Offset Alignment

```css
.offset-layout {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: var(--space-lg);
}

.offset-left {
  margin-top: var(--space-2xl); /* Pushed down */
}

.offset-right {
  margin-top: calc(-1 * var(--space-xl)); /* Pulled up */
}
```

### Hanging Elements

```css
.hanging-element {
  position: relative;
  top: var(--space-lg); /* Hangs below baseline */
}

.floating-element {
  position: relative;
  top: calc(-1 * var(--space-lg)); /* Floats above */
}
```

---

## Responsive Strategies

### Container Queries (Modern)

```css
.card-grid {
  container-type: inline-size;
  display: grid;
  gap: var(--space-md);
}

@container (min-width: 600px) {
  .card-grid {
    grid-template-columns: repeat(2, 1fr);
  }
}

@container (min-width: 900px) {
  .card-grid {
    grid-template-columns: repeat(3, 1fr);
  }
}
```

### Fluid Typography + Space

```css
.fluid-container {
  width: min(100% - 2rem, 75rem);
  margin-inline: auto;
}

.fluid-grid {
  display: grid;
  grid-template-columns: repeat(
    auto-fit,
    minmax(min(100%, 300px), 1fr)
  );
  gap: clamp(1rem, 3vw, 3rem);
}
```

---

## Negative Space Strategies

### Macro Whitespace
Generous breathing room around major elements.

```css
.section {
  padding: var(--space-3xl) 0;
}

.hero {
  min-height: 90vh;
  display: flex;
  align-items: center;
  justify-content: center;
}
```

### Micro Whitespace
Controlled spacing between related elements.

```css
.stack {
  display: flex;
  flex-direction: column;
  gap: var(--space-md);
}

.stack-tight {
  gap: var(--space-sm);
}

.stack-loose {
  gap: var(--space-lg);
}
```

### Isolation
Single element with massive surrounding space.

```css
.isolated-element {
  margin: var(--space-3xl) auto;
  max-width: 40ch;
  text-align: center;
}
```

---

## Layout Patterns by Aesthetic

### Brutalist
- Exposed grid lines
- Asymmetric, aggressive
- Elements touching edges
- No rounded corners

```css
.brutalist-layout {
  display: grid;
  grid-template-columns: 100px 1fr 100px;
  border: 2px solid currentColor;
}

.brutalist-layout > * {
  border: 1px solid currentColor;
  padding: var(--space-md);
}
```

### Editorial
- Magazine-style asymmetric
- Pull quotes breaking flow
- Image heavy, text wraps
- Generous margins

```css
.editorial-layout {
  display: grid;
  grid-template-columns: 1fr 2fr 1fr;
  gap: var(--space-lg);
}

.editorial-main {
  grid-column: 2;
}

.editorial-pullquote {
  grid-column: 1;
  grid-row: span 2;
  position: sticky;
  top: var(--space-xl);
}
```

### Maximalist
- Dense information
- Overlapping layers
- Multiple visual hierarchies
- Rich textures

```css
.maximalist-layout {
  display: grid;
  grid-template-columns: repeat(12, 1fr);
  grid-template-rows: repeat(6, 150px);
  gap: var(--space-sm);
}

.maximalist-item {
  background: var(--color-surface);
  border: 1px solid var(--color-border);
  padding: var(--space-sm);
}
```

---

## Common Anti-Patterns

| Pattern | Problem | Solution |
|---------|---------|----------|
| Always centered | Predictable, boring | Intentional asymmetry |
| Equal column widths | Static, lifeless | Φ ratio or irregular |
| Everything in containers | Constrained, safe | Bleed elements, break grid |
| Symmetrical everything | No visual interest | Offset, overlap, layer |
| Tight spacing everywhere | Claustrophobic | Generous whitespace |

---

## CSS Subgrid (When Available)

```css
/* Parent defines grid */
.grid-parent {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-lg);
}

/* Child aligns to parent's grid */
.card {
  display: grid;
  grid-template-rows: subgrid;
  grid-row: span 3;
}

/* Card content aligns with other cards */
.card-header,
.card-body,
.card-footer {
  /* Aligns to parent grid rows */
}
```

---

## Summary Principles

1. **Asymmetry creates interest** — Perfect symmetry is boring
2. **Overlap creates depth** — Layers feel more sophisticated
3. **Whitespace is active** — It's a design element, not emptiness
4. **Break the container** — Bleed elements create drama
5. **Grid is a guide, not a cage** — Know when to break it
