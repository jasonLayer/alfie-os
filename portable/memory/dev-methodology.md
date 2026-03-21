---
name: dev-methodology
description: Jason's complete development workflow — brainstorm, plan, work, review, codify, done + discipline skills
type: feedback
---

## The Stack

**Workflow engine:** Compound Engineering plugin (`/plan`, `/work`, `/review`, `/codify`, `/done`)
**Custom skills:** `~/.claude/skills/` — `/brainstorm`, `/debug`, `/verify`, `/receive-review`
**Philosophy:** TDD, readability-first, no over-engineering

## How It All Fits Together

```
Feature request or idea
        |
   /brainstorm           ← explore what to build, produce approved spec (docs/specs/)
        |                   Hard gate: no code until spec is approved
        |
   /plan <name>          ← turn spec into implementation plan (docs/plans/)
        |
   /work <name>          ← create branch, TDD Iron Law applies
        |                   (every task: failing test → implementation → green)
        |
   [bug during work?]    → /debug (4-phase: evidence → pattern → hypothesis → fix)
        |
   /review               ← structured P1/P2/P3 code review
        |
   [receiving feedback?] → /receive-review (verify before implementing, no sycophancy)
        |
   /verify               ← before claiming done: run tests, show output, evidence only
        |
   /codify <topic>       ← write learnings to docs/solutions/
        |
   /done <name>          ← release notes, delete plan, recap
```

## Key Rules

1. **Brainstorm gate:** No planning without an approved spec. No code without a plan. Exception: small bug fixes can skip brainstorm.
2. **TDD Iron Law:** No production code without a failing test first. Delete and restart if violated.
3. **Evidence before assertions:** Never say "it works" without showing test output in the same message.
4. **3-Fix Rule:** If 3+ fix attempts fail, stop — it's likely an architectural issue, not a code bug.
5. **No sycophantic review responses:** When receiving feedback, verify claims before implementing.
6. **Specs in `docs/specs/`**, plans in `docs/plans/` — always. Not `docs/superpowers/` or anywhere else.
7. **Release log:** Every completed plan gets release notes in `docs/RELEASE_LOG.md`.
8. **Plan recap:** After finishing, summarize: what we did, what went well, amendments, plain English capabilities.

## Why This Exists

**Why:** Jason tried both Superpowers and Compound Engineering plugins. They overlapped heavily and caused inconsistencies (plans saved to wrong dirs, different conventions). We audited both on 2026-03-15, extracted the unique value from Superpowers into 4 custom skills (`/brainstorm`, `/debug`, `/verify`, `/receive-review`), and consolidated on CE as the single workflow engine with custom skills filling the gaps.

**How to apply:** Always use this flow. The custom skills supplement the CE steps — they don't replace them. `/brainstorm` is the new step 0 before `/plan`.
