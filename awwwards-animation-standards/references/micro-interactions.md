# Micro-Interactions — Deep Dive

Complete reference for button states, magnetic elements, custom cursors,
hamburger animations, form feedback, and navigation reveals.

---

## Button States: Full Lifecycle

Every button has a complete interaction arc: **hover → press → release → leave**.
Each phase has distinct animation characteristics. Skipping any phase feels broken.

### Complete Button Arc

```js
// The full button lifecycle with GSAP
const buttons = document.querySelectorAll('.btn');

// Hover — scale up, shadow appears
buttons.forEach(btn => {
  btn.addEventListener('mouseenter', () => {
    gsap.to(btn, {
      scale: 1.05,
      y: -4,
      boxShadow: '0 20px 40px rgba(0, 0, 0, 0.2)',
      duration: 0.3,
      ease: 'power4.out',
    });
  });

  // Press — scale down, shadow reduces
  btn.addEventListener('mousedown', () => {
    gsap.to(btn, {
      scale: 0.97,
      y: 0,
      boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
      duration: 0.15,
      ease: 'power4.in',
    });
  });

  // Release — elastic overshoot (the "premium" feel)
  btn.addEventListener('mouseup', () => {
    gsap.to(btn, {
      scale: 1.05,
      y: -4,
      boxShadow: '0 20px 40px rgba(0, 0, 0, 0.2)',
      duration: 0.4,
      ease: 'back.out(1.5)', // slight overshoot
    });
  });

  // Leave — return to rest state smoothly
  btn.addEventListener('mouseleave', () => {
    gsap.to(btn, {
      scale: 1,
      y: 0,
      boxShadow: '0 4px 12px rgba(0, 0, 0, 0.1)',
      duration: 0.3,
      ease: 'power4.out',
    });
  });
});
```

### CSS-Only Button States (Tier 1)

```css
.btn {
  position: relative;
  overflow: hidden;
  transition:
    transform 0.3s cubic-bezier(0.16, 1, 0.3, 1),
    box-shadow 0.3s cubic-bezier(0.16, 1, 0.3, 1),
    background-color 0.2s ease;
}

.btn:hover {
  transform: translateY(-4px) scale(1.03);
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

/* Press effect */
.btn:active {
  transform: translateY(0) scale(0.97);
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transition-duration: 0.1s;
}

/* Fill animation on hover */
.btn::after {
  content: '';
  position: absolute;
  inset: 0;
  background: rgba(255, 255, 255, 0.1);
  transform: scaleX(0);
  transform-origin: left;
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.btn:hover::after {
  transform: scaleX(1);
}
```

### Button Ripple Effect

```js
// Material-style ripple on click
buttons.forEach(btn => {
  btn.addEventListener('click', (e) => {
    const rect = btn.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;

    const ripple = document.createElement('span');
    ripple.style.cssText = `
      position: absolute;
      width: 10px; height: 10px;
      background: rgba(255, 255, 255, 0.4);
      border-radius: 50%;
      transform: translate(-50%, -50%) scale(0);
      animation: ripple 0.6s ease-out forwards;
      pointer-events: none;
    `;
    ripple.style.left = x + 'px';
    ripple.style.top = y + 'px';
    btn.appendChild(ripple);

    setTimeout(() => ripple.remove(), 600);
  });
});
```

```css
@keyframes ripple {
  to {
    transform: translate(-50%, -50%) scale(40);
    opacity: 0;
  }
}
```

---

## Magnetic Button Pull

Buttons and elements that "pull" toward the cursor. Creates a tactile,
physical feel. Best for CTAs, social icons, and interactive elements.

### Magnetic Element (GSAP)

```js
// Magnetic pull — element follows cursor within a radius
const magneticBtns = document.querySelectorAll('.magnetic-btn');

magneticBtns.forEach(btn => {
  const strength = 0.4;  // How strongly it pulls (0–1)

  btn.addEventListener('mousemove', (e) => {
    const rect = btn.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;

    const deltaX = e.clientX - centerX;
    const deltaY = e.clientY - centerY;

    gsap.to(btn, {
      x: deltaX * strength,
      y: deltaY * strength,
      duration: 0.3,
      ease: 'power2.out',
    });
  });

  btn.addEventListener('mouseleave', () => {
    gsap.to(btn, {
      x: 0,
      y: 0,
      duration: 0.5,
      ease: 'elastic.out(1, 0.4)', // elastic snap back
    });
  });
});
```

### Magnetic with Inner Text Pull

```js
// The button moves, but text moves MORE in opposite direction
// Creates depth — like layers
magneticBtns.forEach(btn => {
  const innerText = btn.querySelector('.btn-text');
  const strength = 0.3;
  const textStrength = 0.6; // text moves opposite

  btn.addEventListener('mousemove', (e) => {
    const rect = btn.getBoundingClientRect();
    const centerX = rect.left + rect.width / 2;
    const centerY = rect.top + rect.height / 2;

    const deltaX = e.clientX - centerX;
    const deltaY = e.clientY - centerY;

    gsap.to(btn, {
      x: deltaX * strength,
      y: deltaY * strength,
      duration: 0.3,
      ease: 'power2.out',
    });

    gsap.to(innerText, {
      x: -deltaX * textStrength,
      y: -deltaY * textStrength,
      duration: 0.3,
      ease: 'power2.out',
    });
  });

  btn.addEventListener('mouseleave', () => {
    gsap.to(btn, {
      x: 0, y: 0,
      duration: 0.6,
      ease: 'elastic.out(1, 0.4)',
    });
    gsap.to(innerText, {
      x: 0, y: 0,
      duration: 0.6,
      ease: 'elastic.out(1, 0.4)',
    });
  });
});
```

---

## Custom Cursor

Custom cursors add personality. Use a hidden native cursor and replace it
with a custom element. Support both cursor-follow (laggy) and magnetic (sticky) modes.

### Dual-Element Cursor

```html
<div class="cursor-dot"></div>
<div class="cursor-ring"></div>
```

```css
/* Dot — follows exactly */
.cursor-dot {
  width: 8px;
  height: 8px;
  background: var(--color-accent);
  border-radius: 50%;
  position: fixed;
  pointer-events: none;
  z-index: 10001;
  mix-blend-mode: difference;
}

/* Ring — follows with lag */
.cursor-ring {
  width: 40px;
  height: 40px;
  border: 1px solid var(--color-accent);
  border-radius: 50%;
  position: fixed;
  pointer-events: none;
  z-index: 10000;
  mix-blend-mode: difference;
  transition: width 0.2s, height 0.2s, border-color 0.2s;
}

/* Expand on interactive elements */
.cursor-ring.is-hovering {
  width: 60px;
  height: 60px;
  border-color: var(--color-accent-2);
}

/* Hide on mobile */
@media (max-width: 768px) {
  .cursor-dot, .cursor-ring { display: none; }
}
```

```js
// Dual-element cursor implementation
const dot = document.querySelector('.cursor-dot');
const ring = document.querySelector('.cursor-ring');

let mouseX = 0, mouseY = 0;
let dotX = 0, dotY = 0;
let ringX = 0, ringY = 0;

// Track mouse position
document.addEventListener('mousemove', (e) => {
  mouseX = e.clientX;
  mouseY = e.clientY;
});

// RAF loop for smooth animation
function animateCursor() {
  // Dot follows exactly (or with tiny lag for smoothness)
  dotX += (mouseX - dotX) * 0.9;
  dotY += (mouseY - dotY) * 0.9;
  dot.style.transform = `translate(${dotX - 4}px, ${dotY - 4}px)`; // center

  // Ring follows with more lag
  ringX += (mouseX - ringX) * 0.15;
  ringY += (mouseY - ringY) * 0.15;
  ring.style.transform = `translate(${ringX - 20}px, ${ringY - 20}px)`; // center

  requestAnimationFrame(animateCursor);
}

animateCursor();

// Expand on interactive elements
const interactives = document.querySelectorAll('a, button, .interactive');

interactives.forEach(el => {
  el.addEventListener('mouseenter', () => ring.classList.add('is-hovering'));
  el.addEventListener('mouseleave', () => ring.classList.remove('is-hovering'));
});
```

### Cursor States

```js
// Different cursor states based on context
function setCursorState(state) {
  ring.classList.remove('state-default', 'state-hover', 'state-drag', 'state-link');

  switch(state) {
    case 'hover':
      ring.classList.add('state-hover');
      gsap.to(ring, { scale: 1.5, duration: 0.3 });
      break;
    case 'drag':
      ring.classList.add('state-drag');
      gsap.to(ring, { scale: 2, borderRadius: '30%', duration: 0.3 });
      break;
    case 'link':
      gsap.to(ring, { scale: 0.5, duration: 0.2 });
      dot.style.transform = 'scale(2)';
      break;
    default:
      gsap.to(ring, { scale: 1, borderRadius: '50%', duration: 0.3 });
      gsap.to(dot, { scale: 1, duration: 0.2 });
  }
}
```

---

## Hamburger → X Animation

The hamburger menu icon is a micro-interaction that sets expectations for
the entire navigation experience. It must feel fluid and satisfying.

### GSAP Implementation

```js
const hamburger = document.querySelector('.hamburger');
const lines = hamburger.querySelectorAll('.hamburger-line');

let isOpen = false;

hamburger.addEventListener('click', () => {
  isOpen = !isOpen;

  if (isOpen) {
    // Animate to X
    const tl = gsap.timeline();

    // Line 1: moves to center, rotates 45°
    tl.to(lines[0], {
      y: 0,
      rotation: 45,
      top: '50%',
      duration: 0.3,
      ease: 'power4.out',
    })
    // Line 2: scales to 0
    .to(lines[1], {
      scaleX: 0,
      duration: 0.2,
      ease: 'power4.in',
    }, '<')
    // Line 3: moves to center, rotates -45°
    .to(lines[2], {
      y: 0,
      rotation: -45,
      top: '50%',
      duration: 0.3,
      ease: 'power4.out',
    }, '<');
  } else {
    // Animate back to hamburger
    const tl = gsap.timeline();

    tl.to([lines[0], lines[2]], {
      y: (i) => i === 0 ? -8 : 8,
      rotation: 0,
      top: (i) => i === 0 ? '20%' : '80%',
      duration: 0.3,
      ease: 'power4.out',
    })
    .to(lines[1], {
      scaleX: 1,
      duration: 0.2,
      ease: 'power4.out',
    }, '<');
  }
});
```

```html
<div class="hamburger">
  <span class="hamburger-line"></span>
  <span class="hamburger-line"></span>
  <span class="hamburger-line"></span>
</div>
```

```css
.hamburger {
  width: 32px;
  height: 24px;
  position: relative;
  cursor: pointer;
}

.hamburger-line {
  position: absolute;
  left: 0;
  width: 100%;
  height: 2px;
  background: currentColor;
  transform-origin: center;
}

.hamburger-line:nth-child(1) { top: 20%; }
.hamburger-line:nth-child(2) { top: 50%; }
.hamburger-line:nth-child(3) { top: 80%; }
```

### CSS-Only Hamburger → X

```css
/* Pure CSS approach using transforms */
.hamburger {
  width: 32px;
  height: 24px;
  cursor: pointer;
  position: relative;
}

.hamburger-line {
  position: absolute;
  left: 0;
  width: 100%;
  height: 2px;
  background: currentColor;
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1),
              top 0.3s cubic-bezier(0.16, 1, 0.3, 1),
              opacity 0.3s ease;
}

.hamburger-line:nth-child(1) { top: 0; }
.hamburger-line:nth-child(2) { top: 50%; transform: translateY(-50%); }
.hamburger-line:nth-child(3) { top: 100%; }

/* Open state */
.nav-is-open .hamburger-line:nth-child(1) {
  top: 50%;
  transform: translateY(-50%) rotate(45deg);
}
.nav-is-open .hamburger-line:nth-child(2) {
  opacity: 0;
}
.nav-is-open .hamburger-line:nth-child(3) {
  top: 50%;
  transform: translateY(-50%) rotate(-45deg);
}
```

---

## Form Validation Feedback

Form interactions should confirm, guide, and celebrate. Every state transition
should be animated.

### Input Focus Animation

```js
const inputs = document.querySelectorAll('.form-input');

inputs.forEach(input => {
  const label = input.querySelector('.input-label');
  const line = input.querySelector('.input-line');

  // Focus — label floats up, line expands
  input.addEventListener('focus', () => {
    gsap.to(label, {
      y: -24,
      scale: 0.85,
      color: 'var(--color-accent)',
      duration: 0.3,
      ease: 'power4.out',
    });
    gsap.to(line, {
      scaleX: 1,
      duration: 0.4,
      ease: 'power4.out',
    });
  });

  // Blur — label returns if empty, line shrinks
  input.addEventListener('blur', () => {
    if (!input.value) {
      gsap.to(label, {
        y: 0,
        scale: 1,
        duration: 0.3,
        ease: 'power4.out',
      });
    }
    gsap.to(line, {
      scaleX: 0,
      duration: 0.3,
      ease: 'power4.in',
    });
  });
});
```

```html
<div class="form-field">
  <input type="text" class="form-input" id="email" placeholder=" ">
  <label class="input-label" for="email">Email address</label>
  <span class="input-line"></span>
</div>
```

```css
/* Floating label CSS */
.input-label {
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  color: var(--color-text-muted);
  pointer-events: none;
  transition: transform 0.3s cubic-bezier(0.16, 1, 0.3, 1),
              color 0.3s cubic-bezier(0.16, 1, 0.3, 1);
}

.input-line {
  position: absolute;
  bottom: 0;
  left: 0;
  width: 100%;
  height: 2px;
  background: var(--color-accent);
  transform: scaleX(0);
  transform-origin: left;
}
```

### Validation Feedback

```js
// Success — green check, shake or bounce
function showValidation(input, isValid, message) {
  const feedback = input.parentElement.querySelector('.input-feedback');

  if (isValid) {
    gsap.fromTo(input,
      { borderColor: 'var(--color-error)' },
      { borderColor: 'var(--color-success)', duration: 0.3 }
    );
    // Tiny bounce
    gsap.fromTo(input,
      { x: -5 },
      { x: 0, duration: 0.4, ease: 'elastic.out(1, 0.5)' }
    );
    feedback.textContent = '✓';
    feedback.style.color = 'var(--color-success)';
  } else {
    gsap.fromTo(input,
      { x: -5 },
      {
        x: 0,
        duration: 0.5,
        ease: 'elastic.out(1, 0.3)',
      }
    );
    feedback.textContent = message;
    feedback.style.color = 'var(--color-error)';
  }
}
```

### Submit Button Loading + Success

```js
const submitBtn = document.querySelector('.submit-btn');
const btnText = submitBtn.querySelector('.btn-text');
const originalText = btnText.textContent;

submitBtn.addEventListener('click', async () => {
  // Loading state
  gsap.to(btnText, {
    opacity: 0,
    y: 10,
    duration: 0.2,
    onComplete: () => {
      btnText.textContent = 'Sending...';
      gsap.to(btnText, { opacity: 1, y: 0, duration: 0.2 });
    },
  });

  // Simulate API call
  const success = await submitForm();

  if (success) {
    // Success state — checkmark animation
    gsap.to(btnText, {
      opacity: 0,
      duration: 0.2,
      onComplete: () => {
        btnText.innerHTML = '<span class="checkmark">✓</span> Sent!';
        gsap.fromTo(btnText,
          { opacity: 0, scale: 0.8 },
          { opacity: 1, scale: 1, duration: 0.4, ease: 'back.out(2)' }
        );
      },
    });
  } else {
    // Error state — shake
    gsap.to(submitBtn, {
      x: [-10, 10, -10, 10, 0],
      duration: 0.5,
      ease: 'power2.inOut',
    });
  }
});
```

---

## Navigation Menu Reveals

Navigation reveals set the tone for the entire site. They should feel
inevitable and satisfying, not jarring.

### Full-Screen Menu Overlay

```js
const nav = document.querySelector('.nav');
const menuBtn = document.querySelector('.menu-toggle');
const menuOverlay = document.querySelector('.menu-overlay');
const menuItems = menuOverlay.querySelectorAll('.menu-item');
const menuLines = menuOverlay.querySelectorAll('.menu-line');

let isMenuOpen = false;

menuBtn.addEventListener('click', () => {
  isMenuOpen = !isMenuOpen;

  if (isMenuOpen) {
    // Open: overlay fades in, lines expand, items stagger in
    document.body.style.overflow = 'hidden';

    const tl = gsap.timeline();

    tl.to(menuOverlay, {
      clipPath: 'inset(0% 0% 0% 0%)',
      duration: 0.6,
      ease: 'power4.out',
    })
    .from(menuLines, {
      scaleX: 0,
      transformOrigin: 'left',
      duration: 0.4,
      stagger: 0.05,
      ease: 'power4.out',
    }, '-=0.3')
    .from(menuItems, {
      y: 60,
      opacity: 0,
      duration: 0.6,
      stagger: 0.08,
      ease: 'power4.out',
    }, '-=0.2');
  } else {
    // Close: reverse — items out, lines collapse, overlay fades
    const tl = gsap.timeline({
      onComplete: () => {
        document.body.style.overflow = '';
        gsap.set(menuOverlay, { clipPath: 'inset(0% 0% 100% 0%)' });
      },
    });

    tl.to(menuItems, {
      y: -30,
      opacity: 0,
      duration: 0.4,
      stagger: { each: 0.05, from: 'end' },
      ease: 'power4.in',
    })
    .to(menuLines, {
      scaleX: 0,
      transformOrigin: 'right',
      duration: 0.3,
      stagger: 0.03,
      ease: 'power4.in',
    }, '-=0.2')
    .to(menuOverlay, {
      clipPath: 'inset(0% 0% 100% 0%)',
      duration: 0.4,
      ease: 'power4.in',
    }, '-=0.1');
  }
});
```

```html
<div class="menu-overlay">
  <nav class="menu-nav">
    <div class="menu-line"></div>
    <a href="/work" class="menu-item">Work</a>
    <div class="menu-line"></div>
    <a href="/about" class="menu-item">About</a>
    <div class="menu-line"></div>
    <a href="/contact" class="menu-item">Contact</a>
    <div class="menu-line"></div>
  </nav>
</div>
```

```css
.menu-overlay {
  position: fixed;
  inset: 0;
  background: var(--color-bg);
  clip-path: inset(0% 0% 100% 0%); /* Starts hidden from bottom */
  z-index: 100;
  display: flex;
  align-items: center;
  justify-content: center;
}

.menu-line {
  height: 1px;
  background: var(--color-text);
  margin: 1.5rem 0;
  transform-origin: left;
}

.menu-item {
  font-size: clamp(2rem, 8vw, 5rem);
  font-family: var(--font-display);
  display: block;
  padding: 0.5rem 0;
}
```

### Mobile Drawer Navigation

```js
// Slide-in drawer from left
const drawer = document.querySelector('.nav-drawer');
const drawerMask = document.querySelector('.drawer-mask');

menuBtn.addEventListener('click', () => {
  const isOpen = drawer.classList.contains('is-open');

  if (isOpen) {
    // Close
    gsap.to(drawer, {
      x: '-100%',
      duration: 0.4,
      ease: 'power4.in',
    });
    gsap.to(drawerMask, {
      opacity: 0,
      duration: 0.3,
      onComplete: () => {
        drawerMask.style.display = 'none';
        drawer.classList.remove('is-open');
      },
    });
    document.body.style.overflow = '';
  } else {
    // Open
    drawer.style.display = 'block';
    drawer.classList.add('is-open');
    gsap.fromTo(drawer,
      { x: '-100%' },
      { x: 0, duration: 0.4, ease: 'power4.out' }
    );
    gsap.fromTo(drawerMask,
      { opacity: 0 },
      { opacity: 1, duration: 0.3 }
    );
    document.body.style.overflow = 'hidden';
  }
});
```

---

## Micro-Interaction Performance Notes

- Use `transform` and `opacity` only — never animate layout properties in micro-interactions
- Magnetic effects on mobile cause jank — detect touch and disable
- Custom cursor hidden on touch devices via CSS media query
- Button ripple effects: limit to one active ripple at a time
- Form validation animations: debounce to prevent spam triggering
- RAF-based cursor: use `requestAnimationFrame`, not scroll/mousemove event throttling
