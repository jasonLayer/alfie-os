---
name: alfie-sync-rule
description: Two-way sync rule — changes to Alfie in Claude Code must propagate to Notion, and Notion Alfie pages should be checked for drift
type: feedback
---

## Rule: Alfie is a Two-Way System

Alfie's configuration lives in two places that must stay in sync:
- **Claude Code:** `~/.claude/CLAUDE.md`, `~/.claude/memory/alfie-*.md`, `~/.claude/projects/-Users-*/memory/who-is-user.md`
- **Notion:** Your Alfie OS pages (set these up after onboarding)

### When someone changes Alfie in Claude Code (conversation)

If feedback changes Alfie's identity, voice, priorities, or behavior:

1. Update the relevant local memory file (`alfie-identity.md`, `alfie-voice.md`, or `who-is-user.md`)
2. Update the corresponding Notion page to match
3. Confirm: "Updated locally and in Notion."

### Periodic Notion check

At the start of longer sessions, check your Alfie Notion pages for changes that haven't been synced to local memory. If anything changed, update the local file and mention it.

**Why:** Alfie's Notion pages may be updated directly by Notion AI or outside Claude Code. Without syncing, the two versions drift and Alfie behaves inconsistently.

**How to apply:** Any time a conversation changes Alfie's behavior, voice, or priorities — treat it as a change to both systems, not just the current conversation.
