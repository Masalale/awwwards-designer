# awwwards-designer

## Why This Exists

You want websites that win on Awwwwards. Not templates — sites with real craft.

Most AI tools do one thing well. They generate code, or they generate design. Neither builds the **motion layer** — the scroll reveals, page transitions, micro-interactions, and spatial depth that separate a SOTD from a Squarespace template.

This skill exists to close that gap. Stitch designs the visual layer. You define the motion intent. Antigravity builds the full site.

---

## Quick Start (<5 minutes to first success)

**Install:**
```bash
git clone https://github.com/Masalale/awwwards-designer.git ~/.agents/skills/awwwards-designer
```

**Set up Stitch MCP** — add to your agent's config:
```json
{
  "mcpServers": {
    "stitch": {
      "type": "http",
      "url": "https://stitch.googleapis.com/mcp",
      "headers": { "X-Goog-Api-Key": "YOUR_API_KEY" }
    }
  }
}
```

**Open Antigravity:** [aistudio.google.com/gemini/agents](https://aistudio.google.com/gemini/agents)

**Load the skill** — tell your agent to read `~/.agents/skills/awwwards-designer/SKILL.md`

**Start your first project** — give your agent a brand brief. They'll ask follow-up questions, generate the design in Stitch, build it in Antigravity, and run the quality gate.

---

## How It Works

```
Brief → Invention Gate → Stitch → Enhancement Layer → Quality Gate
```

**Brief** — 6 questions. Brand, audience, tier, pages, interactive sections, references.

**Invention Gate** — Extracts brand metaphors, derives motion language, generates the animation map. User confirms before Stitch sees anything.

**Stitch** — Designs the 2D visual layer from the confirmed brief. Outputs project files + `DESIGN.md` as the design source of truth.

**Enhancement Layer** — Adds GSAP, Three.js, Lenis, SplitType, and TanStack Router page transitions on top of the Stitch output. All decisions driven by DESIGN.md and the animation map.

**Quality Gate** — Pass/fail checklist. All pass or fix before shipping.

---

## Prerequisites

- **Google Stitch MCP** — `stitch.googleapis.com/mcp`
- **Google Antigravity** — [aistudio.google.com/gemini/agents](https://aistudio.google.com/gemini/agents)
- **Google AI Studio API key** — [aistudio.google.com](https://aistudio.google.com)

---

## Uninstall

```bash
rm -rf ~/.agents/skills/awwwards-designer
```

---

**Hadnoir** — personal assistant to [Chomba Clarence](https://github.com/Masalale)
