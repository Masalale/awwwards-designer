# Awwwards Designer

An AI agent skill for building websites that win or get nominated for Awwwards SOTD, SOTM, or SOTY.

![License](https://img.shields.io/badge/license-MIT-green)

## What This Skill Does

Structures AI agents to produce award-winning web experiences by forcing genuine invention over safe, familiar patterns. The core mechanism is the **Invention Gate** — a mandatory checkpoint that extracts brand metaphors and commits to a signature interaction before any code is written.

**Supports:** Claude Code (`~/.claude/skills/`), OpenClaw (`~/.openclaw/skills/`), and any agent that reads a `SKILL.md` manifest.

## Installation

```bash
git clone git@github.com:Masalale/awwwards-designer.git ~/.agents/skills/awwwards-designer
```

Then symlink into your agent's skills directory:

```bash
# Claude Code
ln -s ~/.agents/skills/awwwards-designer ~/.claude/skills/awwwards-designer

# OpenClaw
ln -s ~/.agents/skills/awwwards-designer ~/.openclaw/skills/awwwards-designer
```

## Skill Architecture

```
SKILL.md                        # 9 Hard Stops + 12-step execution sequence
references/
├── invention-gate.md           # Mandatory brand metaphor extraction + paradigm selection
├── synthesis.md                # INVENTION.md → binding execution decisions
├── section-architecture.md     # Section sequence as narrative argument
├── aesthetic-foundations.md    # Typography system, layout principles, animation timing
├── easing-language.md          # Brand easing curve derivation
├── technique-families.md       # Interaction families × complexity tiers with code examples
├── anti-patterns.md            # Forbidden patterns, overused patterns, encouraged patterns
├── tech-stack.md               # Astro / TanStack Start setup, Lenis + ScrollTrigger sync
├── page-transitions.md         # Barba.js + GSAP transitions, FLIP shared elements
├── descender-safety.md         # Canvas measurement, CSS clearance system
└── audit.md                    # 13 Awwwards-critical pre-launch checks
```

## How It Works

The skill enforces a 12-step execution sequence. Steps cannot be skipped.

**Steps 1–2: Invention Gate + Color**
The agent reads `references/invention-gate.md`, extracts three brand metaphors, selects one signature interaction paradigm from six (Cursor, Scroll, Loading, Hover, Typography, Layout), documents the twist, and writes `INVENTION.md` to the project root. No code before this file exists. Colors are proposed via the `brand-color-psychology` skill and confirmed by the user — never invented by the agent.

**Steps 3–5: Synthesis + Architecture + Design System**
INVENTION.md decisions are translated into binding execution choices (lerp factor, easing curve, hero structure, scroll phase ratios). Section sequence is built as a narrative argument from the brand metaphor. Typography and layout system established mobile-first at 375px.

**Steps 6–8: Build**
Framework scaffolded (Astro or TanStack Start — no other options). Full page structure built before any interaction code. Then the signature interaction is implemented as a single engine: Lenis → gsap.ticker → outputs.

**Steps 9–12: Validation**
Anti-pattern check, page transitions (if multi-page), descender safety on all display text >48px, pre-launch audit.

## Awwwards Scoring

**Design 40% · Usability 30% · Creativity 20% · Content 10%**

Design and Usability form 70% of the score and must be flawless before Creativity is evaluated. The skill builds from the base up — not from the signature interaction outward.

## Hard Stops

The skill has 9 invariant rules that cannot be overridden by project context:

1. No code before `INVENTION.md` is written
2. No single HTML file output — Astro or TanStack Start only
3. One icon system throughout (Lucide recommended)
4. `overflow: visible` on all display text — never `overflow: clip`
5. `dvh` not `vh` for full-screen sections
6. Never override native touch scroll
7. Always fetch current API docs before writing integration code
8. Descender safety protocol mandatory for all text >48px
9. Read `references/anti-patterns.md` before design begins

## Tech Stack

Output is **Astro** (Tier 1/2/2.5) or **TanStack Start** (Tier 2/3). No other frameworks. No single HTML files.

| Tier | Stack | When |
|------|-------|------|
| 1 | CSS scroll-driven animations, vanilla JS | Innovation is visual, not interactive |
| 2 | GSAP + ScrollTrigger + Lenis + SplitType | Motion is the signature moment |
| 2.5 | Tier 2 + CSS 3D or single Three.js mesh | Brand metaphor requires physical depth |
| 3 | Three.js / WebGL / React Three Fiber | Brand requires 3D, generative, or physics |

## License

MIT — Use freely, credit appreciated.
