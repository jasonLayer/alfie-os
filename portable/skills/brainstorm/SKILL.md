---
name: brainstorm
description: Explore what to build through collaborative dialogue before planning. Use before /plan for any new feature, component, or significant change. Triggers on "let's brainstorm", "I want to build", "what should we do about", ambiguous feature requests, or when requirements have multiple valid interpretations.
argument-hint: "[feature idea or problem to explore]"
---

# Brainstorm: Ideas Into Specs

Turn ideas into approved design specs through collaborative dialogue. This is step 0 of the dev flow — it answers **WHAT** to build before `/plan` answers **HOW**.

## Hard Gate

Do NOT write code, invoke `/plan`, or take any implementation action until:
1. A design spec has been presented
2. The user has approved it
3. It's been saved to a file

This applies to EVERY feature regardless of perceived simplicity. "Simple" projects are where unexamined assumptions waste the most work. The spec can be short (a few sentences), but it must exist and be approved.

## Anti-Rationalization

If you're thinking any of these, stop:
- "This is too simple to need a spec" — No. Every feature gets one.
- "I already know what they want" — You don't. Ask.
- "Let me just start coding and we'll iterate" — That's not how we work.

## Process

### Phase 1: Understand Context

Before asking any questions:
1. Check the codebase — what exists that's related? (`git log`, relevant files, existing patterns)
2. Check `docs/plans/` — is there prior work or a related plan?
3. Check project memory — is there context about this feature area?

### Phase 2: Collaborative Dialogue

Ask questions **one at a time** using AskUserQuestion. Don't overwhelm.

**Question order:**
1. **Purpose** — What problem does this solve? Who is it for?
2. **Success criteria** — How will we know it's working?
3. **Constraints** — What can't change? What must it integrate with?
4. **Scope** — What's explicitly NOT in this version? (Apply YAGNI hard)
5. **Edge cases** — What happens when things go wrong?

**Guidelines:**
- Prefer multiple choice when natural options exist
- Start broad, then narrow
- Validate assumptions explicitly — "So to confirm, you want X but not Y?"
- Stop when the idea is clear OR the user says "proceed"

### Phase 3: Explore Approaches

Propose **2-3 concrete approaches**. For each:
- Brief description (2-3 sentences)
- Pros and cons
- When it's the right choice

**Lead with your recommendation and explain why.** Apply YAGNI — prefer the simpler option unless there's a concrete reason not to.

Ask which approach the user prefers.

### Phase 4: Present the Design

Present the design in sections, scaled to complexity:
- Simple aspect → a few sentences
- Complex aspect → up to 200-300 words

**Sections to cover** (skip any that don't apply):
- What we're building (the "elevator pitch" for this feature)
- Architecture / data flow
- Key components
- API changes (if any)
- Error handling
- Testing approach
- Open questions

**Ask after each section:** "Does this look right so far?"

Be ready to go back and revise. This is a dialogue, not a presentation.

### Phase 5: Write the Spec

Once the user approves the design:

1. Save to `docs/specs/YYYY-MM-DD-<topic>-design.md`
2. Ensure `docs/specs/` directory exists first
3. Format:

```markdown
# <Feature Name> — Design Spec

> Brainstormed on YYYY-MM-DD

## What We're Building
[Elevator pitch]

## Why This Approach
[The chosen approach and why we picked it over alternatives]

## Key Decisions
- [Decision 1]: [rationale]
- [Decision 2]: [rationale]

## Design
[Architecture, components, data flow — as detailed as needed]

## Testing Approach
[How we'll verify this works]

## Out of Scope
[What we explicitly decided NOT to build]

## Open Questions
[Anything unresolved — resolve these before /plan]
```

### Phase 6: Handoff

Present next steps:
1. **Proceed to planning** — run `/plan <name>` (will reference this spec)
2. **Refine further** — keep asking questions
3. **Done for now** — come back later

Display:
```
Brainstorm complete!

Spec: docs/specs/YYYY-MM-DD-<topic>-design.md

Key decisions:
- [Decision 1]
- [Decision 2]

Next: Run `/plan <name>` when ready to implement.
```

## Key Principles

- **One question at a time** — don't overwhelm
- **YAGNI ruthlessly** — remove unnecessary features from all designs
- **Explore alternatives** — always propose 2-3 approaches
- **Incremental validation** — get approval before moving on
- **Spec before plan, plan before code** — no shortcuts
