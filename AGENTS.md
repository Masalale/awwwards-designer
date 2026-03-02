# PROJECT KNOWLEDGE BASE

**Generated:** 2026-03-02
**Commit:** a368b88
**Branch:** main

## OVERVIEW

AI skill for generating Awwwards-caliber web designs. Documentation-only repository (no executable code). Defines design philosophy, technique families, and anti-patterns to prevent AI design convergence.

## STRUCTURE

```
./
├── SKILL.md                    # AI agent manifest
├── README.md                   # Project overview
├── LICENSE
├── .gitignore
└── references/
    ├── signature-invention.md  # 4-step invention framework
    ├── aesthetic-foundations.md # Typography, palette, composition
    ├── technique-families.md    # 5 interaction families × 3 tiers
    ├── anti-patterns.md        # Forbidden/Overused/Encouraged
    └── tech-stack.md           # Framework-agnostic stack guide
```

## WHERE TO LOOK

| Task | Location | Notes |
|------|----------|-------|
| Edit skill description | SKILL.md | Main AI manifest |
| Add new technique family | references/technique-families.md | 5 families, 6-7 approaches each |
| Update anti-patterns | references/anti-patterns.md | 3-tier classification |
| Philosophy changes | references/aesthetic-foundations.md | Generative rules, no code |

## CONVENTIONS

- **No verbatim code** — All technique references are conceptual, never copy-paste snippets
- **Framework-agnostic** — No framework mandated; agents choose based on tier
- **3-tier model** — CSS-only (Tier 1) / GSAP+DOM (Tier 2) / WebGL+Shaders (Tier 3)
- **Signature Interaction** — Every project must invent ONE novel interaction

## ANTI-PATTERNS (THIS PROJECT)

### FORBIDDEN
- Generic fonts (Inter, Roboto, Arial)
- Default Tailwind blue / purple-to-pink gradients
- Perfect symmetry layouts
- `transition: all` / `ease-in-out` defaults
- Glassmorphism everywhere

### OVERUSED
- `mix-blend-difference` cursors
- GSAP y:40px scroll reveals
- SplitType defaults
- Lenis with default config

### ENCOURAGED
- MSDF text rendering
- Gaussian Splatting
- Curtains.js / Theatre.js
- FBO particle systems

## COMMANDS

```bash
# No build/test commands — this is a documentation-only skill
# View skill: cat SKILL.md
# Update references: edit files in references/
```

## NOTES

- Custom `.sisyphus/` folder contains project tracking (boulder.json, plans/, evidence/)
- No CI/CD, no linting, no tests — pure markdown documentation
- Anti-patterns defined in `references/anti-patterns.md`
