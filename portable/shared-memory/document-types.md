# Alfie Document Type System

> Used across ALL teamspaces (8thday.io, Icon, majorGTM, PoaM, Radhouse Games). Each teamspace may use a subset of these types.
> Source: `Tutorial: When to Use Each Document Template` (2b90d32a281680c690a4de95912f337e) and `AI Instruction: Document Format Conversion` (f95abcbdfff54a888d9875e234b6235e)

## The 12 Types

| Type | Purpose | Audience | Title Format |
|---|---|---|---|
| **Tutorial** | Teach something new from scratch | Beginners | `Tutorial: [Topic]` |
| **Guide** | Help achieve a specific goal | Intermediate users | `Guide: [Topic]` |
| **Explanation** | Provide deep "why" understanding | Experts & developers | `Explanation: [Topic]` |
| **Reference** | Technical specs & definitions for lookup | Experienced users | `Reference: [Topic]` |
| **Flowchart SOP** | Document a process with decision points | Anyone following a process | `SOP: [Process]` |
| **Talk Track** | Script for specific conversations | Sales, support, comms | `Talk Track: [Conversation]` |
| **Playbook** | Organize 5+ related docs for one workflow | Teams running complete workflows | `Playbook: [Process]` |
| **Plan** | Set goals, milestones, KPIs | Teams executing toward targets | `Plan: [Target]` |
| **Analysis** | Personal thinking & synthesis | You (future you) | `Analysis: [Topic]` |
| **AI Background** | Context for AI to understand something | AI assistants (Alfie) | `AI Background: [Topic]` |
| **AI Instruction** | Teach AI how to perform a task | AI assistants (Alfie) | `AI Instruction: [Task]` |
| **Manuscript** | Creative long-form writing | Readers, publishers | `Manuscript: [Title]` |
| **Raw** | Unprocessed input / quick captures | Needs conversion to proper type | (no prefix — default for new captures) |

## Decision Matrix (ask in order)

1. Needs 5+ documents of different types? → **Playbook**
2. Setting goals, milestones, KPIs? → **Plan**
3. Teaching a beginner from scratch? → **Tutorial**
4. Helping intermediate user do a task? → **Guide**
5. Deep "why" understanding for experts? → **Explanation**
6. Technical specs for lookup? → **Reference**
7. Documenting a process with decisions? → **Flowchart SOP**
8. Script for a conversation? → **Talk Track**
9. Personal intellectual work/synthesis? → **Analysis**
10. Context for AI to understand? → **AI Background**
11. Teaching AI to do a task? → **AI Instruction**
12. Polished creative writing for readers? → **Manuscript**

## Template Structures

### Tutorial
Introduction → Prerequisites → Step 1, 2, 3... (each produces visible result) → Conclusion → Troubleshooting

### Guide
Purpose → Intended Audience → Prerequisites → Step-by-Step Instructions → Expected Outcome → Common Pitfalls → Related Guides

### Explanation
Overview → Intended Audience → Background → Core Concepts → Design Philosophy → Internal Workings → Trade-offs → Future Directions → Further Reading

### Reference
Introduction → Intended Audience → Component Overview → Technical Specifications → Usage Examples → Common Pitfalls → Performance Considerations → Related Components

### Flowchart SOP
Purpose → Flowchart (visual diagram) → Framework OR Step-by-Step → Instructions for Use

### Talk Track
Talk Track (the script) → Why it works

### Playbook
Overview → Document Index (grouped by type) → How to Use This Playbook (table matching needs to documents)

### Plan
Target/Goal Statement → Assumptions → Time-Bound Milestones (with Key Hires/Resourcing + Goals checkboxes) → KPI Guardrails → Status

### Analysis
Introduction → Source Material → Core Analysis → Alignments → Tensions → Synthesis → Personal Reflection → Open Questions

### AI Background
Overview → Intended Audience → Background → Core Concepts → Design Philosophy → Internal Workings → Relationships → Trade-offs → Future Directions → Further Reading

### AI Instruction
Overview → Intended Audience → When to Use → Core Principles → Standard Structure → Step-by-Step Process → Quality Checklist → Common Mistakes → Examples → Voice Guidelines → Reference Material

### Manuscript
Freeform — structure serves content

## Key Distinctions

- **Tutorial vs Guide**: Tutorial = beginner, learning from scratch. Guide = intermediate, accomplishing a task.
- **Explanation vs Analysis**: Explanation = teaching others. Analysis = personal thinking work.
- **Plan vs Guide**: Plan = what we're aiming for (targets). Guide = how to get there (steps).
- **Plan vs SOP**: Plan = goal-oriented, time-bound. SOP = process-oriented, repeatable.
- **AI Background vs AI Instruction**: Background = knowledge (understand). Instruction = skills (do).
- **Manuscript vs Analysis**: Manuscript = polished output for readers. Analysis = thinking for yourself.
- **Playbook vs SOP**: Playbook = organizes 5+ docs. SOP = single process doc.

## Conversion Rules

- Each document gets ONE primary type (no hybrids)
- Preserve all meaningful information — restructure, don't delete
- Match the original's energy — concise stays concise, detailed stays detailed
- Name follows `[Type]: [Topic]` convention
- Set the Type property in JRHQ_DocsAndResource_DB

## Common Mistakes

- Tutorial when Guide is appropriate (reader already knows basics)
- Explanation for how-to content (Explanation = "why", not "how")
- Hybrid formats (pick ONE)
- Over-structuring Manuscripts (deliberately freeform)
- Playbook for simple processes (single SOP covers it)
- Plan when Guide is appropriate (Plan = targets, Guide = how-to)
