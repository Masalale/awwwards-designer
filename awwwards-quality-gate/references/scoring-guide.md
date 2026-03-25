# Awwwwards Scoring Guide

> Load when evaluating Gate 2 (Creativity) or when preparing a submission. This guide covers official scoring, jury process, common rejections, and strategic paths.

---

## Official Awwwwards Scoring Criteria

| Criterion   | Weight | Description |
|-------------|--------|-------------|
| **Design**  | 40%    | Visual impact, typography, color palette, layout design, consistency, brand coherence, aesthetic sophistication |
| **Usability**| 30%   | Navigation clarity and discoverability, mobile experience, touch target sizing, form functionality, overall ease of use |
| **Creativity**| 20% | Uniqueness of concept, memorable first impression, surprising interactions, creative use of technology and animation |
| **Content** | 10%    | Quality and relevance of copy, brand voice consistency, information hierarchy, CTAs, overall content strategy |

**Calculating your target:** To reach Honorable Mention (≥6.5), you need a weighted average ≥6.5 across both jury and user scores. That means:
- If you score 7.0 Design, 7.0 Usability, 6.5 Creativity, 6.5 Content = 6.975 weighted average
- **SOTD requires consistency** — a single 4.0 in any category can sink an otherwise strong submission

---

## Jury Evaluation Process

1. **Minimum 18 jury members** evaluate each site
2. **Top 3 highest and lowest scores are removed** as outliers (extreme votes don't count)
3. **Remaining scores are averaged** to produce the jury score
4. **Separate user vote** runs simultaneously — users also score 1–10
5. **Honorable Mention** requires: **jury ≥6.5 AND users ≥6.5**

**What jury members look for:**
- First 3 seconds: Is this memorable?
- First scroll: Is there a creative concept beyond "website"?
- Navigation: Can I find what I need?
- Performance: Does it load fast?
- Details: Are there signs of craft (micro-interactions, consistent type, thoughtful spacing)?
- Mobile: Does it work perfectly at 375px?
- Uniqueness: Is this the same as 10 other sites I've reviewed this week?

---

## Honorable Mention Threshold

To receive **Honorable Mention** (the minimum recognition tier):

- **Jury average ≥ 6.5** (after outlier removal)
- **User average ≥ 6.5**
- Both thresholds must be met simultaneously

Honorable Mention is the minimum bar for a successful submission. Below 6.5 on either metric = rejection, no recognition.

---

## SOTD (Site of the Day) Eligibility

- **Eligibility window**: Within **3 months** of the site's live launch date
- **Competition pool**: SOTD is the highest tier — only the top ~1% of all submissions reach it
- **Typical scores for SOTD**: 7.5–9.5 range across all criteria
- **SOTD is not required** for a successful career — many studios build excellent sites that don't win SOTD but still attract premium clients

---

## Developer Award

The **Developer Award** is Awwwwards' recognition for technical excellence:

- Requires **>7.0 average** on the technical/coding criteria subset
- Evaluated separately from the main 4-criteria scoring
- A good path for technically impressive sites that may not have the most creative concept

---

## CSSA (Community Site Feature Award)

**CSSA is a more accessible path** to Awwwwards recognition:

- Evaluated by community reviewers (not the expert jury)
- Lower bar than the main competition
- Still appears on the site with a badge
- **Strategy**: If your site scores well on Design + Usability but lacks a groundbreaking creative concept, CSSA is the realistic goal
- Many excellent studios build their reputation through CSSA + Developer Award before targeting SOTD

---

## Common Rejection Reasons

These patterns appear repeatedly in rejected submissions. Avoid all of them:

### Design Failures
- **Generic template aesthetic** — Looks like a Squarespace/Wix/SaaS template. No unique visual identity.
- **Default fonts** — Arial, Helvetica, or system fonts in the wild. No custom type.
- **Stock photo overload** — 5+ generic stock photos of "diverse team in meeting." Immediate rejection signal.
- **Inconsistent spacing** — Random padding values everywhere. No spacing scale.
- **Poor color choices** — Colors that clash, look cheap, or have no relationship to each other.

### Usability Failures
- **Broken navigation** — Links go nowhere. Dropdowns don't work. Mobile nav broken.
- **Poor mobile experience** — Horizontal scroll. Tiny text. Features that only work on desktop.
- **Tiny touch targets** — Buttons <44×44px. Unusable on actual phones.
- **No 404 page** — Server error or blank page when visiting invalid URL.
- **No keyboard navigation** — Keyboard users are completely lost.

### Performance Failures
- **Slow load times** — LCP >4s. Users see blank screen. Jury bounces.
- **Blocking scripts** — Render-blocking JS. Page doesn't paint until JS loads.
- **Unoptimized images** — Multi-megabyte hero images. No lazy loading. Wrong formats.

### Creativity Failures
- **No creative concept** — "It's a website for a company." That's not enough.
- **Forgettable first impression** — If the jury can't remember what the site looked like 5 minutes after reviewing it, it's a fail.
- **No surprising interactions** — Everything works exactly as expected. Nothing rewards exploration.
- **Copy-paste animation** — Same GSAP boilerplate from every other site. No signature interaction.

### Animation Failures
- **`transition: all`** — Awwwards jury sees this immediately. Shows a lack of craft.
- **Linear easing** — Robotic, cheap-looking. Immediate red flag.
- **`100vh` on mobile** — Address bar overlap shows the jury you didn't test on real mobile.
- **`prefers-reduced-motion` ignored** — Accessibility failure AND sign of copy-paste code.

### Technical Failures
- **jQuery** — jQuery in 2024/2025 is an automatic rejection signal.
- **Mixed icon libraries** — Multiple icon sets (FA + Heroicons + Lucide) = messy codebase.
- **`<div>` soup** — No semantic HTML. Pure `<div>`堆积. No landmarks.
- **Dead routes** — Defined routes that return blank pages.
- **Broken assets** — 404 on images, fonts, scripts.

---

## Japanese Studios Dominance Analysis

Japanese studios (like Utsubo, CYM, Monogrid, and many others) consistently win SOTD at rates far exceeding their representation in the global dev community. Key reasons:

### The Concept of "Ma" (間)
- **Ma** = negative space, the meaningful pause, the silence between notes
- Japanese web design embraces emptiness. Generous whitespace. Nothing is crowded.
- Western sites often try to fill every pixel. Japanese sites let content breathe.

### Meticulous Craft
- Every pixel is deliberate. Every animation has a reason.
- Micro-interactions that feel hand-crafted, not library-generated.
- Typography is treated as a primary design element, not an afterthought.

### Signature Interactions
- A single memorable interaction that becomes associated with the studio.
- Not trying to do everything — doing one thing exceptionally well.
- The interaction serves the concept, not the other way around.

### Performance as Default
- Japanese studios typically have near-perfect performance because they care about every byte.
- Minimal dependencies. Purpose-built animations. No bloated frameworks.

**Takeaway:** You don't need to "do more" to win. You need to do fewer things with more care. Meticulous craft + clear concept + restraint beats feature overload every time.

---

## CSSA Strategy (Accessible Path to Recognition)

If SOTD feels out of reach, the CSSA path is legitimate and still provides:
- Official Awwwwards recognition badge
- Profile on the Awwwwards site
- Community visibility
- Developer Award if technical scores are strong

**CSSA strategy:**
1. Nail Design (40%) — Great typography, cohesive color, consistent spacing
2. Nail Usability (30%) — Flawless mobile, accessible, clear nav
3. Solid Creativity (20%) — A clear concept, even if not groundbreaking
4. Good Content (10%) — Real copy, clear hierarchy, strong CTAs
5. Developer Award — If you can score >7.0 on technical criteria, you get a second badge

---

## Red Flags Summary

**Automatic rejections (zero tolerance):**
- `transition: all` in CSS
- `animation: linear` anywhere
- jQuery usage
- `100vh` on mobile full-screen sections
- Default system fonts
- Generic stock photo overload
- Broken mobile nav
- Dead routes
- 404 assets on critical paths
- `overflow: clip` on text
- Mixed icon libraries (anything besides Lucide)
- `<div>` soup with no semantic structure

**Near-automatic rejections:**
- LCP >4s
- No concept beyond "website"
- No memorable moment in first scroll
- Horizontal overflow on 375px
- No keyboard navigation
- No `prefers-reduced-motion` support
- Build errors (TypeScript, ESLint, etc.)

**These will NOT save you:**
- Amazing animation on top of broken usability
- Beautiful design with poor mobile
- Creative concept with no accessibility
- Fast load on top of jQuery and mixed icon libraries
